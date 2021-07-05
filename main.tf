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
  vpc_id                 = "vpc-02b8bbfcc9e439e23"
  vpc_cidr_block         = "10.0.0.0/16"
  private_subnet_az_a_id = "subnet-0b426229916942e24" //sub-a-devnet-sbxezit-IT01
  private_subnet_az_b_id = "subnet-0782e33d3e8c212c4" //sub-b-devnet-sbxezit-IT02
  ec2_key                = "scott-keypair"
}