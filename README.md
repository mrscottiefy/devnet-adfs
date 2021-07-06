# Active Directory Federation Services (ADFS) for HDB's Development Tooling and Network Platform

This project creates the ...

### Contents

- main.tf
- security-groups.tf
- iam-roles.tf
- directory-service.tf
- managed-ad-terminal.tf
- adfs-instances.tf
- systems-manager.tf
- vpc-endpoints.tf


## Terraform Cheat Sheet

### terraform-test
```
>> terraform init
>> terraform fmt
>> terraform validate
>> terraform plan
>> terraform apply
```

### Create a workspace
```
>> terraform workspace new [NAME]
```

### For multiple environments 'workspaces'
```
>> terraform workspace select dev
>> terraform apply -var-file=dev.tfvars
>> terraform destroy -var-file=dev.tfvars
```