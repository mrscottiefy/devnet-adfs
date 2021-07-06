resource "aws_instance" "adfs_instance1" {
  ami                    = local.adfs_ami
  instance_type          = local.adfs_instance_type
  subnet_id              = local.private_subnet_az_a_mgmt_id
  key_name               = local.ec2_key
  iam_instance_profile   = "${local.iam_name_prefix}Profile"
  vpc_security_group_ids = [aws_security_group.sgrp_devnet_ad_mgmt_terminal.id]
  tags = {
    Name = local.adfs_instance_name
  }
}