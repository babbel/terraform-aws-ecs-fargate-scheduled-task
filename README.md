# AWS ECS Fargate Scheduled Task Terraform Module

[![Terraform Status](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/workflows/Lint/badge.svg)](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/actions)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/blob/master/LICENCE)
[![GitHub release](https://img.shields.io/github/release/babbel/terraform-aws-ecs-fargate-scheduled-task.svg)](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/releases)

A Terraform module to create an ECS Fargate Task Definition which can be scheduled via CloudWatch Events, with the related CloudWatch Log Group and IAM resources.

Available through the [Terraform registry](https://registry.terraform.io/modules/babbel/ecs-fargate-scheduled-task/aws).

## Assumptions

* You want to create an ECS Fargate Task Definition and schedule its execution via CloudWatch Events.
* You have created a Virtual Private Cloud (VPC) and subnets where you intend to put the ECS resources.
* You have created a NAT Gateway in one of the public subnets of the VPC with necessary routes for traffic from the private subnets (needed for ECR integration).
* You have created an ECS Cluster and a [Task Execution IAM Role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html).
* You have created an ECR Repository containing a Docker image that you want to deploy using the module.

## Usage example

A full example leveraging other community modules is contained in the [`/examples/complete`](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/tree/master/examples/complete) directory.
Here's the gist of using it via GitHub source:

```hcl
module "fargate_task" {
  source                  = "babbel/ecs-fargate-scheduled-task/aws"
  region                  = "eu-west-1"
  task_name               = "fargate-task"
  schedule_expression     = "rate(30 minutes)"
  ecs_cluster_arn         = "my-cluster"
  task_execution_role_arn = "arn:aws:iam::123456789012:role/my-task-execution-role"
  task_definition         = "task-definition.json"
  task_policy             = "policy.json"
  vpc_subnets             = ["subnet-123456789abcdefgh", "subnet-abcdefgh123456789"]
  vpc_security_groups     = ["sg-123456789abcdefgh"]
}
```

## Doc generation

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).

Follow [these instructions](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) to install pre-commit locally.

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/issues/new) section.

Full contributing [guidelines are covered here](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/blob/master/CONTRIBUTING.md).

## Authors

Created by [Data Platfrom at Babbel](https://github.com/babbel-data-platform).

## License

MIT Licensed. See [LICENSE](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/blob/master/LICENSE) for full details.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| assign\_public\_ip | (Optional) Assign a public IP to the EC2 instance running the Fargate task | bool | `"false"` | no |
| ecs\_cluster\_arn | (Required) ARN of the ECS Cluster where to deploy the Fargate task | string | n/a | yes |
| logs\_retention\_days | (Optional) Retention days for logs of the Fargate task log group | number | `"14"` | no |
| platform\_version | (Optional) Fargate platform version | string | `"LATEST"` | no |
| region | (Required) AWS region | string | n/a | yes |
| schedule\_expression | (Required) CRON schedule expression to trigger the Fargate task | string | n/a | yes |
| task\_cpu | (Optional) CPU value for the Fargate task | number | `"256"` | no |
| task\_definition | (Required) Path to the Task Definition JSON file | string | n/a | yes |
| task\_execution\_role\_arn | (Required) ARN of the Task Execution Role for the Fargate task | string | n/a | yes |
| task\_memory | (Optional) Memory value for the Fargate task | number | `"512"` | no |
| task\_name | (Required) Name of the Fargate task | string | n/a | yes |
| task\_policy | (Required) Path to the Task IAM Policy JSON file | string | n/a | yes |
| ephemeral\_storage | (Optional) The amount(in GiB) of ephemeral storage to allocate for the task | number | n/a | no |
| vpc\_security\_groups | (Required) List of security groups for the EC2 instance running the Fargate task | list(string) | n/a | yes |
| vpc\_subnets | (Required) List of subnets were AWS will spawn an EC2 instance running the Fargate task | list(string) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch\_event\_iam\_role\_arn | ARN of the CloudWatch Events IAM Role |
| cloudwatch\_event\_rule\_id | Name of the CloudWatch Events Rule |
| cloudwatch\_log\_group\_name | Name of the CloudWatch log group |
| scheduled\_task\_arn | ARN of the scheduled ECS Fargate Task Definition |
| scheduled\_task\_family | Family of the scheduled ECS Fargate Task Definition |
| scheduled\_task\_iam\_role\_arn | ARN of the ECS Fargate task IAM Role |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
