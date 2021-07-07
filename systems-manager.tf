resource "aws_ssm_document" "ssm_set_dns_for_domain_join" {
  name          = "windows_set_dns_for_domain"
  document_type = "Command"
  content       = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Setting Windows DNS Server Preferred & Secondary addresses to AWS Directory Services' Managed Active Directory domain controllers.",
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

resource "aws_ssm_document" "ssm_install_rsat_tools" {
  name          = "windows_install_ad_admin_tools"
  document_type = "Command"
  content       = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Installs Windows Features for AD Tools and DNS Server to administer the users and DNS records for AWS Directory Services' Managed Active Directory domain controllers.",
    "parameters": {},
    "mainSteps":[
        {
            "action": "aws:runPowerShellScript",
            "name": "installRSATADTools",
            "inputs": {
                "runCommand": [
                    "$out = Install-WindowsFeature -Name RSAT-AD-Tools -IncludeAllSubFeature -IncludeManagementTools  -LogPath 'C:\logs\install-adfs-logs.txt'",
                    "if ($out.ExitCode -ne 'Success'){$out | out-file 'C:\logs\install-adfs-error.txt'}"
                ]
            }
        },
        {
            "action": "aws:runPowerShellScript",
            "name": "installRSATDNSServer",
            "inputs": {
                "runCommand": [
                    "$out = Install-WindowsFeature -Name RSAT-DNS-Server -IncludeAllSubFeature -IncludeManagementTools  -LogPath 'C:\logs\install-adfs-logs.txt'",
                    "if ($out.ExitCode -ne 'Success'){$out | out-file 'C:\logs\install-adfs-error.txt'}"
                ]
            }
        }
    ]
  }
DOC
}