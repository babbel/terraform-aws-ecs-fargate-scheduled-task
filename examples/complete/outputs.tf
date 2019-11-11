output "scheduled_task_arn" {
  description = "ARN of the scheduled ECS Fargate Task Definition"
  value       = module.fargate_task.scheduled_task_arn
}

output "scheduled_task_family" {
  description = "Family of the scheduled ECS Fargate Task Definition"
  value       = module.fargate_task.scheduled_task_family
}

output "scheduled_task_iam_role_arn" {
  description = "ARN of the ECS Fargate task IAM Role"
  value       = module.fargate_task.scheduled_task_iam_role_arn
}

output "cloudwatch_event_iam_role_arn" {
  description = "ARN of the CloudWatch Events IAM Role"
  value       = module.fargate_task.cloudwatch_event_iam_role_arn
}

output "cloudwatch_event_rule_id" {
  description = "Name of the CloudWatch Events Rule"
  value       = module.fargate_task.cloudwatch_event_rule_id
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.fargate_task.cloudwatch_log_group_name
}
