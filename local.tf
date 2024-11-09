locals {
  name_prefix = var.node_name

  common_tags = merge(
    var.tags,
    {
      ManagedBy = "terraform"
    }
  )
} 