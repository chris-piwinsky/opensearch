output "ssm_parameter_name" {
  value = aws_ssm_parameter.opensearch_master_user.name
}

output "os_uri" {
  value = aws_opensearch_domain.opensearch.endpoint
}
