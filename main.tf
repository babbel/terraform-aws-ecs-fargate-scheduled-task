################################################################################
# CloudWatch Events - Role Management
################################################################################

resource "aws_iam_role" "cloudwatch_events_role" {
  name               = "${var.task_name}-events"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_events_role_assume_policy.json
}

data "aws_iam_policy_document" "cloudwatch_events_role_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "cloudwatch_events_role_run_task" {
  name   = "${aws_ecs_task_definition.fargate_task.family}-events-ecs"
  role   = aws_iam_role.cloudwatch_events_role.id
  policy = data.aws_iam_policy_document.cloudwatch_events_role_run_task_policy.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cloudwatch_events_role_run_task_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task-definition/${aws_ecs_task_definition.fargate_task.family}:*"]

    condition {
      test     = "StringLike"
      variable = "ecs:cluster"
      values   = [var.ecs_cluster_arn]
    }
  }
}

resource "aws_iam_role_policy" "cloudwatch_events_role_pass_role" {
  name   = "${aws_ecs_task_definition.fargate_task.family}-events-ecs-pass-role"
  role   = aws_iam_role.cloudwatch_events_role.id
  policy = data.aws_iam_policy_document.cloudwatch_events_role_pass_role_policy.json
}

data "aws_iam_policy_document" "cloudwatch_events_role_pass_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]

    resources = [
      var.task_execution_role_arn,
      aws_iam_role.ecs_task_role.arn,
    ]
  }
}

################################################################################
# CloudWatch Events Rule
################################################################################

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${var.task_name}-scheduled-event"
  description         = "Runs Fargate task ${var.task_name}: ${var.schedule_expression}"
  schedule_expression = var.schedule_expression
}

################################################################################
# CloudWatch Events ECS Target
################################################################################

resource "aws_cloudwatch_event_target" "esc_target" {
  target_id = var.task_name
  arn       = var.ecs_cluster_arn
  rule      = aws_cloudwatch_event_rule.schedule.name
  role_arn  = aws_iam_role.cloudwatch_events_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.fargate_task.arn
    launch_type         = "FARGATE"
    platform_version    = var.platform_version

    network_configuration {
      assign_public_ip = var.assign_public_ip
      security_groups  = var.vpc_security_groups
      subnets          = var.vpc_subnets
    }
  }
}

################################################################################
# Fargate Task Role
################################################################################

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.task_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_assume_policy.json
}

data "aws_iam_policy_document" "ecs_task_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

data "local_file" "task_policy" {
  filename = var.task_policy
}

resource "aws_iam_policy" "ecs_task_role_policy" {
  name   = "${var.task_name}-task-role-policy"
  policy = data.local_file.task_policy.content
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_task_role.id
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
}

################################################################################
# Fargate Task Definition
################################################################################

data "local_file" "task_definition" {
  filename = var.task_definition
}

resource "aws_ecs_task_definition" "fargate_task" {
  family                   = var.task_name
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.local_file.task_definition.content
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage > 20 ? [var.ephemeral_storage] : []
    content {
      size_in_gib = var.ephemeral_storage
    }
  }

  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
}


################################################################################
# CloudWatch Log Group
################################################################################

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/${var.task_name}-logs"
  retention_in_days = var.logs_retention_days
}
