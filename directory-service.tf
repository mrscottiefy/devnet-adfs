data "aws_secretsmanager_secret_version" "directory_service_secret" {
  secret_id = local.directory_service_secret_name
}

resource "aws_directory_service_directory" "directory_service" {
  name     = local.directory_service_name
  password = local.directory_service_creds.password
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = local.vpc_id
    subnet_ids = [local.private_subnet_az_a_id, local.private_subnet_az_b_id]
  }
}