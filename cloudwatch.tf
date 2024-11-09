resource "aws_cloudwatch_log_group" "node" {
  name              = "/ecs/${local.name_prefix}"
  retention_in_days = 30

  tags = local.common_tags
} 