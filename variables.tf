variable "region" {
  type        = string
  description = "(Required) AWS region"
}

variable "task_name" {
  type        = string
  description = "(Required) Name of the Fargate task"
}

variable "schedule_expression" {
  type        = string
  description = "(Required) CRON schedule expression to trigger the Fargate task"
}

variable "ecs_cluster_arn" {
  type        = string
  description = "(Required) ARN of the ECS Cluster where to deploy the Fargate task"
}

variable "platform_version" {
  type        = string
  description = "(Optional) Fargate platform version"
  default     = "LATEST"
}

variable "task_execution_role_arn" {
  type        = string
  description = "(Required) ARN of the Task Execution Role for the Fargate task"
}

variable "task_definition" {
  type        = string
  description = "(Required) Path to the Task Definition JSON file"
}

variable "task_policy" {
  type        = string
  description = "(Required) Path to the Task IAM Policy JSON file"
}

variable "task_cpu" {
  type        = number
  description = "(Optional) CPU value for the Fargate task"
  default     = 256
}

variable "task_memory" {
  type        = number
  description = "(Optional) Memory value for the Fargate task"
  default     = 512
}

variable "ephemeral_storage" {
  type        = number
  description = "(Optional) The amount(in GiB) of ephemeral storage to allocate for the task"
  default     = 0
}

variable "assign_public_ip" {
  type        = bool
  description = "(Optional) Assign a public IP to the EC2 instance running the Fargate task"
  default     = false
}

variable "vpc_subnets" {
  type        = list(string)
  description = "(Required) List of subnets were AWS will spawn an EC2 instance running the Fargate task"
}

variable "vpc_security_groups" {
  type        = list(string)
  description = "(Required) List of security groups for the EC2 instance running the Fargate task"
}

variable "logs_retention_days" {
  type        = number
  description = "(Optional) Retention days for logs of the Fargate task log group "
  default     = 14
}


