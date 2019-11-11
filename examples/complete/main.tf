provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "fargate-example-vpc"

  cidr = "10.1.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

################################################################################
# AWS ECS Cluster
################################################################################

resource "aws_ecs_cluster" "example" {
  name = "fargate-example-cluster"
}

################################################################################
# Default Task Execution Role
################################################################################

resource "aws_iam_role" "example" {
  name               = "fargate-example-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "example" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

################################################################################
# Fargate Task
################################################################################

module "fargate_task" {
  source                  = "../.."
  region                  = "eu-west-1"
  task_name               = "fargate-task"
  schedule_expression     = "rate(30 minutes)"
  ecs_cluster_arn         = aws_ecs_cluster.example.arn
  task_execution_role_arn = aws_iam_role.example.arn
  task_definition         = "task/task-definition.json"
  task_policy             = "task/policy.json"
  vpc_subnets             = module.vpc.private_subnets
  vpc_security_groups     = [module.vpc.default_security_group_id]
}
