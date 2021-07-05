resource "aws_security_group" "sandbox-managed-ad-terminal-sec-grp" {
  name        = "sgrp-managed-ad-terminal"
  description = "SG for connecting, joining and administering the managed-ad"
  vpc_id      = local.vpc_id

  ingress {
    description = "RDP from OpenVPN Server"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.198/32"]
  }
  ingress {
    description = "LDAP from Domain Controllers"
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SMB from Domain Controllers"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "DNS TCP/UDP from Domain Controllers"
    from_port   = 53
    to_port     = 53
    protocol    = "-1"
    cidr_blocks = ["${aws_directory_service_directory.sandbox-domain-service.dns_ip_addresses[0]}/32",
      "${aws_directory_service_directory.sandbox-domain-service.dns_ip_addresses[1]}/32"
    ]
  }
  egress {
    description = "All traffic to reosurces within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.vpc_cidr_block]
  }
}