terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.32.0"
    }
  }
}

provider "aws" {
  profile = "dev-aws"
  region  = "ap-southeast-1"
}

locals {
  //General AWS Comparment Variables 
  vpc_id                      = "vpc-02b8bbfcc9e439e23"    //vpc main
  vpc_cidr_block              = "10.0.0.0/16"              //vpc main cidr range
  openvpn_cidr_block          = "10.0.3.198/32"            //ip address of open vpn server for RDP
  private_subnet_az_a_id      = "subnet-0b426229916942e24" //sub-a-devnet-sbxezit-IT01
  private_subnet_az_b_id      = "subnet-0782e33d3e8c212c4" //sub-b-devnet-sbxezit-IT02
  private_subnet_az_a_mgmt_id = "subnet-0b426229916942e24" //sub-a-devnet-sbxezit-IT01
  ec2_key                     = "scott-keypair"

  //AWS Directory Service Variables
  directory_service_name        = "soedev.gov.sg"
  directory_service_secret_name = "directory-service-soedev-admin"
  directory_service_creds = jsondecode(
    data.aws_secretsmanager_secret_version.directory_service_secret.secret_string
  )
  //AWS EC2 Management Terminal Variables
  managed_terminal_ami           = "ami-0e0c0f774a3f68bf9"
  managed_terminal_instance_type = "t3.small"
  managed_terminal_ec2_role      = "iam:devnet-EC2DirectoryServiceMgmt"

}