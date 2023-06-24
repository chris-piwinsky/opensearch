
variable "security_group_ids" {}
variable "subnet_ids" {}
variable "layers" {
  default = "none"
}

variable "ssm_parameter_name" {}
variable "os_uri" {}
variable "master_user" {}
