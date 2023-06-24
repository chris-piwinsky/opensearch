resource "aws_security_group" "opensearch_security_group" {
  name        = "${var.domain}-sg"
  vpc_id      = var.vpc_id
  description = "Allow inbound HTTP traffic"

  ingress {
    description = "HTTP from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    cidr_blocks = [
      var.cidr_block,
    ]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_security_group_rule" "allow_opensearch_ingress_vpn" {
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   source_security_group_id = # VPN's security group source Id 
#   security_group_id        = aws_security_group.opensearch_security_group.id
#   description              = "Allow connections from AWS VPN"
# }
