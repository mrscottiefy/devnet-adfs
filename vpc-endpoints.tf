resource "aws_vpc_endpoint" "vpcep_ssm" {
  vpc_id            = local.vpc_id
  service_name      = local.vpcep_service_name_ssm
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.sgrp_ec2_for_ssm.id,
  ]
  tags = {
    Name = local.vpcep_name_ssm
  }
}
resource "aws_vpc_endpoint" "vpcep_ssmmsgs" {
  vpc_id            = local.vpc_id
  service_name      = local.vpcep_service_name_ssmmsgs
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.sgrp_ec2_for_ssm.id,
  ]
  tags = {
    Name = local.vpcep_name_ssmmsgs
  }
}
resource "aws_vpc_endpoint" "vpcep_ec2msgs" {
  vpc_id            = local.vpc_id
  service_name      = local.vpcep_service_name_ec2msgs
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.sgrp_ec2_for_ssm.id,
  ]
  tags = {
    Name = local.vpcep_name_ec2msgs
  }
}