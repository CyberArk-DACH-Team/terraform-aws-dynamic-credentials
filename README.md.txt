# Setup for AWS dynamic credentials from Conjur

## Configure your AWS dynamic credentials
https://docs.cyberark.com/conjur-cloud/latest/en/content/operations/dynamic-secrets-aws.htm

## Create a host with API Token access and provide the host access to the dynamic credentials


Sample policy:
```
- !permit
  role: !host tf-setup-host-name  # Update with your host
  resource: !variable dynamic/AWS-S3-Bucket-Creation # Update your variable path 
  privileges: [ read, execute ]

```

## Terraform Setup
Take a look at the `main.tf` file. Update the values to match yours where noted. Run `terraform init`. 
Execute a `terraform plan` to check for the changes, if you're happy with the planned changes, run
`terraform apply` and provision the infrastructure.