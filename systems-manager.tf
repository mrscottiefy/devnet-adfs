resource "aws_ssm_document" "ssm_set_dns_for_domain_join" {
  name          = "windows-set-dns-for-domain"
  document_type = "Command"
  tags = {
    Name = "windows-set-dns-for-domain"
  }
  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Setting Windows DNS Server Preferred & Secondary addresses to AWS Directory Services' Managed Active Directory domain controllers. [FOR FIRST DOMAIN JOIN]",
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
  name          = "windows-install-ad-admin-tools"
  document_type = "Command"
  tags = {
    Name = "windows-install-ad-admin-tools"
  }
  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Installs Windows Features for AD Tools and DNS Server to administer the users and DNS records for AWS Directory Services' Managed Active Directory domain controllers. These do not require restarts.",
    "parameters": {},
    "mainSteps":[
        {
            "action": "aws:runPowerShellScript",
            "name": "installRSATADTools",
            "inputs": {
                "runCommand": [
                    "$logPath = 'C:\\logs\\install-ad-admin-tools-logs.txt'",
                    "$errorPath = 'C:\\logs\\install-ad-admin-tools-error.txt'",
                    "$out = Install-WindowsFeature -Name RSAT-AD-Tools -IncludeAllSubFeature -IncludeManagementTools  -LogPath $logPath",
                    "if ($out.ExitCode -ne 'Success'){$out | out-file $errorPath}"
                ]
            }
        }
        ,
        {
            "action": "aws:runPowerShellScript",
            "name": "installRSATDNSServer",
            "inputs": {
                "runCommand": [
                    "$logPath = 'C:\\logs\\install-ad-admin-tools-logs.txt'",
                    "$errorPath = 'C:\\logs\\install-ad-admin-tools-error.txt'",
                    "$out = Install-WindowsFeature -Name RSAT-DNS-Server -IncludeAllSubFeature -IncludeManagementTools  -LogPath $logPath",
                    "if ($out.ExitCode -ne 'Success'){$out | out-file $errorPath}"
                ]
            }
        }
    ]
}
DOC
}

resource "aws_ssm_document" "ssm_join_domain" {
  name          = "windows-join-domain"
  document_type = "Command"
  tags = {
    Name = "windows-join-domain"
  }
  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Join the AWS Directory Services' Managed Active Directory Domain. [FOR FIRST DOMAIN JOIN]",
    "parameters": {},
    "mainSteps":[
        {
            "action": "aws:runPowerShellScript",
            "name": "joinWindowsDomain",
            "inputs": {
                "runCommand": [
                    "$errorPath = 'C:\\logs\\install-ad-admin-tools-error.txt'",
                    "$password = ConvertTo-SecureString '${local.directory_service_creds.password}' -AsPlainText -Force",
                    "$joinCred = New-Object System.Management.Automation.PSCredential ('${local.directory_service_netbios_name}\\Admin', $password)",
                    "$out = Add-Computer -ComputerName . -DomainName '${local.directory_service_name}' -Credential $joinCred -PassThru -Verbose",
                    "if ($out.HasSucceeded -ne 'True'){$out | out-file $errorPath}"
                ]
            }
        }
    ]
  }
DOC
}

resource "aws_ssm_document" "ssm_install_adfs_tools" {
  name          = "windows-install-ad-fs-tools"
  document_type = "Command"
  tags = {
    Name = "windows-install-ad-fs-tools"
  }
  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Install the AD FS tools required to federate authentication with AWS Directory Services' Managed Active Directory Domain.",
    "parameters": {},
    "mainSteps":[
        {
            "action": "aws:runPowerShellScript",
            "name": "installADFSTools",
            "inputs": {
                "runCommand": [
                    "$logPath = 'C:\\logs\\install-adfs-tools-logs.txt'",
                    "$errorPath = 'C:\\logs\\install-adfs-tools-error.txt'",
                    "$out = Install-windowsfeature adfs-federation –IncludeManagementTools -LogPath $logPath",
                    "if ($out.ExitCode -ne 'Success'){$out | out-file $errorPath}"
                ]
            }
        }
    ]
  }
DOC
}

//create SSM Doc for adding AD DS users
//create SSM Doc for installing AD FS