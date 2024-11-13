locals {
  name_prefix = var.node_name

  common_tags = merge(
    var.tags,
    {
      ManagedBy = "terraform"
    }
  )
}

locals {
  task_definitions = {
    "ethereum"  = try(aws_ecs_task_definition.ethereum_node[0].arn, null)
    "polkadot" = try(aws_ecs_task_definition.substrate_node[0].arn, null)
    "enjin"     = try(aws_ecs_task_definition.substrate_node[0].arn, null)
  }
}
