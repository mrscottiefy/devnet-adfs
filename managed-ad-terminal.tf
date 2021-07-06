resource "aws_instance" "managed_ad_terminal" {
  ami                    = local.managed_terminal_ami
  instance_type          = local.managed_terminal_instance_type
  subnet_id              = local.private_subnet_az_a_mgmt_id
  key_name               = local.ec2_key
  iam_instance_profile   = "devnet-EC2DirectoryServiceProfile"
  vpc_security_group_ids = [aws_security_group.sgrp_managed_ad_terminal.id]
  user_data              = <<-EOF
          wmic nicconfig where (IPEnabled=TRUE) call SetDNSServerSearchOrder ()
          wmic nicconfig where (IPEnabled=TRUE) call SetDNSServerSearchOrder ("100.0.3.133", "10.0.0.2")
          EOF
  tags = {
    Name = "vm-devnet-sbxezit-mgmt-terminal-01"
  }
}

# output "directory_service_dc1" {
#   value = sort(aws_directory_service_directory.directory_service.dns_ip_addresses)[0]
# }