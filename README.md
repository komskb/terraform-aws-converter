# KOMSKB Framework Terraform Media Convert module 

AWS Media Convert를 사용하기 위한 람다함수를 생성하는 Terraform 모듈 입니다.

내부적으로 사용하는 리소스 및 모듈:

* [AWS IAM ROLE](https://www.terraform.io/docs/providers/aws/r/iam_role.html)
* [AWS Lambda](https://www.terraform.io/docs/providers/aws/r/lambda_function.html)


## Usage

```hcl
module "converter" {
  source = "komskb/terraform-module-converter"

  project = "${var.project}"
  environment = "${var.environment}"
  api_endpoint = "${format("https://%s/api/v1", var.domain)}"
  jwt_secret_key = "${module.ecs.jwt_secret_key}"

  tags = {
    Terraform = "${var.terraform_repo}"
    Environment = "${var.environment}"
  }
}
```

## Terraform version

Terraform version 0.11.13 or newer is required for this module to work.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| api\_endpoint | Content convert result api endpoint | string | n/a | yes |
| environment | Deploy environment | string | `"production"` | no |
| jwt\_secret\_key | Check jwt secret key | string | n/a | yes |
| project | Project name to use on all resources created (VPC, ALB, etc) | string | n/a | yes |
| tags | A map of tags to use on all resources | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_cloudwatch\_event\_rule\_arn | Cloudwatch event rule arn |
| this\_cloudwatch\_event\_rule\_name | Cloudwatch event rule name |
| this\_lambda\_arn | Lambda arn |
| this\_lambda\_name | Lambda name |
| this\_lambda\_role\_arn | IAM role arn |
| this\_mediaconvert\_role\_arn | IAM role arn |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Authors

Module is maintained by [komskb](https://github.com/komskb).

## License

MIT licensed. See LICENSE for full details.