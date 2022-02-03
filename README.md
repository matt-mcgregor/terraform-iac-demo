# Terraform IAC Demo

An example of creating and publishing a docker image to support a consistent infrastucture-as-code approach, then consuming that image to publish AWS resources. Uses the [3musketeers](https://3musketeers.io) pattern and [Terraform image](https://hub.docker.com/r/hashicorp/terraform).

### Prerequisites

* File called 'credentials' in an .aws folder (root of this repository) containing either JWT token or access keys:

```
[default]
aws_access_key_id=[key here]
aws_secret_access_key=[key here]
```

### Getting Started

Validate the terraform (which will initialise Terraform and the AWS provider):
``` 
make test
```
Should result in the following:
```
docker-compose run --rm terraform init -input=false
Creating terraform-iac-demo_terraform_run ... done

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v3.74.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
docker-compose run --rm terraform validate
Creating terraform-iac-demo_terraform_run ... done
Success! The configuration is valid.
```
Then build the terraform plan:
```
make build
```
Should result in the following:
```
docker-compose run --rm terraform plan -var region=eu-west-2 -var-file=config/eu-west-2.tfvars -out terraform-iac-demo.plan
Creating terraform-iac-demo_terraform_run ... done

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.bucket will be created
  + resource "aws_s3_bucket" "bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "mattmcgregor.terraform.iac.demo.online"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "Dev"
          + "Name"        = "My bucket"
        }
      + tags_all                    = {
          + "Environment" = "Dev"
          + "Name"        = "My bucket"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: terraform-iac-demo.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "terraform-iac-demo.plan"
```
Then deploy the resource based on the plan:
```
make deploy
```
Should result in the following:
```
docker-compose run --rm terraform apply terraform-iac-demo.plan
Creating terraform-iac-demo_terraform_run ... done
aws_s3_bucket.bucket: Creating...
aws_s3_bucket.bucket: Creation complete after 2s [id=mattmcgregor.terraform.iac.demo.online]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
Finally, destroy the resource:
```
make destroy
```
Should result in the following:
```
docker-compose run --rm terraform destroy -input=false -auto-approve -var region=eu-west-2 -var-file=config/eu-west-2.tfvars
Creating terraform-iac-demo_terraform_run ... done
aws_s3_bucket.bucket: Refreshing state... [id=mattmcgregor.terraform.iac.demo.online]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_s3_bucket.bucket will be destroyed
  - resource "aws_s3_bucket" "bucket" {
      - acl                         = "private" -> null
      - arn                         = "arn:aws:s3:::mattmcgregor.terraform.iac.demo.online" -> null
      - bucket                      = "mattmcgregor.terraform.iac.demo.online" -> null
      - bucket_domain_name          = "mattmcgregor.terraform.iac.demo.online.s3.amazonaws.com" -> null
      - bucket_regional_domain_name = "mattmcgregor.terraform.iac.demo.online.s3.eu-west-2.amazonaws.com" -> null
      - force_destroy               = false -> null
      - hosted_zone_id              = "Z3GKZC51ZF0DB4" -> null
      - id                          = "mattmcgregor.terraform.iac.demo.online" -> null
      - region                      = "eu-west-2" -> null
      - request_payer               = "BucketOwner" -> null
      - tags                        = {
          - "Environment" = "Dev"
          - "Name"        = "My bucket"
        } -> null
      - tags_all                    = {
          - "Environment" = "Dev"
          - "Name"        = "My bucket"
        } -> null

      - versioning {
          - enabled    = false -> null
          - mfa_delete = false -> null
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.
aws_s3_bucket.bucket: Destroying... [id=mattmcgregor.terraform.iac.demo.online]
aws_s3_bucket.bucket: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.
```
