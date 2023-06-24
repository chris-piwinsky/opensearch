resource "random_password" "password" {
  length  = 32
  special = true
}

resource "aws_ssm_parameter" "opensearch_master_user" {
  name        = "/service/${var.service}/MASTER_USER"
  description = "opensearch_password for ${var.service} domain"
  type        = "SecureString"
  value       = random_password.password.result
}

resource "aws_opensearch_domain" "opensearch" {
  domain_name    = var.domain
  engine_version = "OpenSearch_${var.engine_version}"

  cluster_config {
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = var.dedicated_master_type
    dedicated_master_enabled = var.dedicated_master_enabled
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    zone_awareness_enabled   = var.zone_awareness_enabled
    zone_awareness_config {
      availability_zone_count = var.zone_awareness_enabled ? length(var.subnet_ids) : null
    }
  }

  advanced_security_options {
    enabled                        = var.security_options_enabled
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.master_user
      master_user_password = random_password.password.result
    }
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    custom_endpoint_enabled         = true
    custom_endpoint                 = var.custom_domain
    custom_endpoint_certificate_arn = var.certificate_arn
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_size = var.ebs_volume_size
    volume_type = var.volume_type
    throughput  = var.throughput
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_log_group_index_slow_logs.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_log_group_search_slow_logs.arn
    log_type                 = "SEARCH_SLOW_LOGS"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_log_group_es_application_logs.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  node_to_node_encryption {
    enabled = true
  }

  # vpc_options {
  #   subnet_ids = var.subnet_ids

  #   security_group_ids = [aws_security_group.opensearch_security_group.id]
  # }


  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${var.region}:${var.account_id}:domain/${var.domain}/*"
        }
    ]
}
CONFIG
}

resource "aws_route53_record" "opensearch_domain_record" {
  zone_id = var.zone_id
  name    = var.custom_domain
  type    = "CNAME"
  ttl     = "300"

  records = [aws_opensearch_domain.opensearch.endpoint]
}
