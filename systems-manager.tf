resource "aws_ssm_document" "dns_for_domain_join" {
  name          = "windows_set_dns_for_domain"
  document_type = "Command"
  content       = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Command Document for running powershell script",
    "parameters": {},
    "mainSteps":[
        {
            "action": "aws:runPowerShellScript",
            "name": "setDNStoDomainControllers",
            "inputs": {
                "runCommand": [
                    "Set-DnsClientServerAddress -interfacealias Ethernet* -serveraddresses (\"${element(tolist(aws_directory_service_directory.directory_service.dns_ip_addresses), 0)},10.0.0.2\")"
                ]
            }
        }
    ]
  }
DOC
}