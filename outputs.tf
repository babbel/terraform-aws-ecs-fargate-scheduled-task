output "scheduled_task_arn" {
  description = "ARN of the scheduled ECS Fargate Task Definition"
  value       = aws_ecs_task_definition.fargate_task.arn
}

output "scheduled_task_family" {
  description = "Family of the scheduled ECS Fargate Task Definition"
  value       = aws_ecs_task_definition.fargate_task.family
}

output "scheduled_task_iam_role_arn" {
  description = "ARN of the ECS Fargate task IAM Role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "cloudwatch_event_iam_role_arn" {
  description = "ARN of the CloudWatch Events IAM Role"
  value       = aws_iam_role.cloudwatch_events_role.arn
}

output "cloudwatch_event_rule_id" {
  description = "Name of the CloudWatch Events Rule"
  value       = aws_cloudwatch_event_rule.schedule.id
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.logs.name
}
