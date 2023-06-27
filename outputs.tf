output "os_uri" {
    value = "https://${module.opensearch.os_uri}/"
}

output "ssm_name" {
    value = module.opensearch.ssm_parameter_name
}

output "master_user" {
    value = local.master_user
}