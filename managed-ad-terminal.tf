resource "aws_instance" "managed_ad_terminal" {
  ami                    = local.managed_terminal_ami
  instance_type          = local.managed_terminal_instance_type
  subnet_id              = local.private_subnet_az_a_mgmt_id
  key_name               = local.ec2_key
  iam_instance_profile   = "${local.iam_name_prefix}Profile"
  vpc_security_group_ids = [aws_security_group.sgrp_devnet_ad_mgmt_terminal.id]
  # user_data = ...
  tags = {
    Name = local.managed_terminal_instance_name
  }
}