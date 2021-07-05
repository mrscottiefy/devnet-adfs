resource "aws_instance" "managed_ad_terminal" {
  ami             = local.managed_terminal_ami
  instance_type   = local.managed_terminal_instance_type
  subnet_id       = local.private_subnet_az_a_mgmt_id
  key_name        = local.ec2_key
  security_groups = aws_security_group.sgrp_managed_ad_terminal.id
  tags = {
    Name = "vm-devnet-sbxezit-mgmt-terminal-01"
  }
}