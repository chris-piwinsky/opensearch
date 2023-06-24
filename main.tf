locals {
  service        = "opensearch"
  domain         = "${local.service}-engine"
  custom_domain  = "${local.domain}.${data.aws_route53_zone.domain.name}"
  subnet_ids     = slice(data.aws_subnets.private.ids, 0, 2)
  master_user    = "${local.service}-masteruser"
  security_group = "sg-03cd1c2ab903862cb"
}

module "acm" {
  source      = "./acm_cert"
  domain_name = var.domain_name 
  zone_id     = data.aws_route53_zone.domain.zone_id
}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

module "opensearch" {
  depends_on = [
    module.acm,
    aws_iam_service_linked_role.es
  ]
  source                   = "./opensearch"
  account_id               = data.aws_caller_identity.current.account_id
  region                   = data.aws_region.current.name
  vpc_id                   = data.aws_vpc.production_vpc.id
  domain                   = local.domain
  custom_domain            = local.custom_domain
  certificate_arn          = module.acm.certificate_arn
  zone_id                  = data.aws_route53_zone.domain.zone_id
  subnet_ids               = data.aws_subnets.private.ids
  cidr_block               = data.aws_vpc.production_vpc.cidr_block
  master_user              = local.master_user
  engine_version           = "2.5"
  security_options_enabled = true
  volume_type              = "gp3"
  throughput               = 250
  ebs_enabled              = true
  ebs_volume_size          = 45
  service                  = local.service
  instance_type            = "t3.small.search"
  instance_count           = 3
  dedicated_master_enabled = true
  dedicated_master_count   = 3
  dedicated_master_type    = "t3.small.search"
  zone_awareness_enabled   = true
}

module "lambda_layer" {
  source = "./lambda_layer"
}

module "lambda_os_load" {
  depends_on = [
    module.opensearch
  ]
  source             = "./lambda_load"
  subnet_ids         = local.subnet_ids
  layers             = [module.lambda_layer.layer_arn]
  security_group_ids = [local.security_group]
  ssm_parameter_name = module.opensearch.ssm_parameter_name
  os_uri             = "https://${module.opensearch.os_uri}/"
  master_user        = local.master_user
}

