resource "aws_security_group" "sgrp_managed_ad_terminal" {
  name        = "sgrp-managed-ad-terminal"
  description = "SG for connecting, joining and administering the managed-ad"
  vpc_id      = local.vpc_id

  tags = {
    Name = "sgrp-managed-ad-terminal"
  }

  ingress {
    description = "RDP from OpenVPN Server"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.198/32"]
  }
  ingress {
    description = "LDAP from AWS Directory Service Managed AD Domain Controllers"
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = formatlist("%s/32", aws_directory_service_directory.directory_service.dns_ip_addresses) //to append CIDR block range of /32 to each string array value of dns_ip_addresses
  }
  ingress {
    description = "SMB from AWS Directory Service Managed AD Domain Controllers"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = formatlist("%s/32", aws_directory_service_directory.directory_service.dns_ip_addresses) //to append CIDR block range of /32 to each string array value of dns_ip_addresses
  }
  ingress {
    description = "DNS TCP from AWS Directory Service Managed AD Domain Controllers"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = formatlist("%s/32", aws_directory_service_directory.directory_service.dns_ip_addresses) //to append CIDR block range of /32 to each string array value of dns_ip_addresses
  }
  ingress {
    description = "DNS UDP from AWS Directory Service Managed AD Domain Controllers"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = formatlist("%s/32", aws_directory_service_directory.directory_service.dns_ip_addresses) //to append CIDR block range of /32 to each string array value of dns_ip_addresses
  }
  egress {
    description = "All traffic to resources within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.vpc_cidr_block]
  }
}

# resource "aws_security_group" "sgrp_ec2_for_ssm" {
#   name        = "sgrp-ec2-ssm"
#   description = "SG for SSM to act on EC2 service"
#   vpc_id      = local.vpc_id

#   tags = {
#     Name = "sgrp-ec2-ssm"
#   }

#   ingress {
#     description = "HTTPS for SSM endpoints within VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [local.vpc_cidr_block]
#   }

#   egress {
#     description = "All traffic to resources within VPC"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = [local.vpc_cidr_block]
#   }
# }