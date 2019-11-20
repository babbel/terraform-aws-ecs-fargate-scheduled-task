# Complete ECS Fargate example for scheduling task

Configuration in this directory creates a set of ECS resources including ECS Cluster, ECS Task Execution IAM Role, ECS Fargate Task Definition.

This configuration also provisions all the resources needed for the module to function properly like VPC, Subnets, Routes, NAT Gateway and Security Groups.

## Task Definition

The Task Definition is declared in [`/task/task-definition.json`](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/tree/master/examples/complete/task/task-definition.json).

In this JSON file the following placeholders need to be replaced based on AWS Account and ECR Repository information:
* `${image_name}`: The name of the Docker image stored in ECR (including tag)
* `${account_id}`: The ID of the AWS Account
* `${region}`: The region of the ECR Repository

For example:
```json
[
    {
        "name": "fargate-example",
        "image": "123456789012.dkr.ecr.eu-west-1.amazonaws.com/fargate-example",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/fargate-example-logs",
                "awslogs-region": "eu-west-1",
                "awslogs-stream-prefix": "ecs"
            }
        }
    }
]
```

## Policy

The IAM Policy attached to the IAM Role of the task is declared in [`/task/policy.json`](https://github.com/babbel/terraform-aws-ecs-fargate-scheduled-task/tree/master/examples/complete/task/policy.json).

In this JSON file can be specified any permission the task needs to interact with AWS.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch\_event\_iam\_role\_arn | ARN of the CloudWatch Events IAM Role |
| cloudwatch\_event\_rule\_id | Name of the CloudWatch Events Rule |
| cloudwatch\_log\_group\_name | Name of the CloudWatch log group |
| scheduled\_task\_arn | ARN of the scheduled ECS Fargate Task Definition |
| scheduled\_task\_family | Family of the scheduled ECS Fargate Task Definition |
| scheduled\_task\_iam\_role\_arn | ARN of the ECS Fargate task IAM Role |