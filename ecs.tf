resource "aws_ecs_cluster" "main" {
  name = "${local.name_prefix}-cluster"

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "substrate_node" {
  count = var.consensus_client_enabled ? 0 : 1

  family = "${local.name_prefix}-task"

  container_definitions = jsonencode([
    {
      name      = "${local.name_prefix}-container"
      image     = var.docker_image
      cpu       = 0
      memory    = var.node_memory
      essential = true
      command   = var.command

      portMappings = [
        for port in var.node_ports : {
          containerPort = port
          hostPort      = port
          protocol      = "tcp"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = "blockchain-data"
          containerPath = "/data"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.node.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  volume {
    name      = "blockchain-data"
    host_path = "/data"
  }

  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_task.arn

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "ethereum_node" {
  count = var.consensus_client_enabled ? 1 : 0

  family = "${local.name_prefix}-task"

  container_definitions = jsonencode([
    {
      name      = "${local.name_prefix}-execution"
      image     = var.docker_image
      cpu       = 0
      memory    = var.node_memory - var.consensus_client_memory
      essential = true
      command   = var.command

      portMappings = [
        for port in setsubtract(var.node_ports, var.consensus_client_ports) : {
          containerPort = port
          hostPort      = port
          protocol      = "tcp"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = "blockchain-data"
          containerPath = "/data"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.node.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "execution"
        }
      }
    },
    {
      name      = "${local.name_prefix}-consensus"
      image     = var.consensus_client_image
      cpu       = 0
      memory    = var.consensus_client_memory
      essential = true
      command   = [
        "lighthouse",
        "bn",
        "--network=mainnet",
        "--execution-endpoint=http://${local.name_prefix}-execution:8551",
        "--execution-jwt=/data/jwt.hex",
        "--http",
        "--http-address=0.0.0.0",
        "--metrics",
        "--metrics-address=0.0.0.0",
        "--checkpoint-sync-url=https://mainnet.checkpoint.sigp.io"
      ]

      portMappings = [
        for port in var.consensus_client_ports : {
          containerPort = port
          hostPort      = port
          protocol      = "tcp"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = "blockchain-data"
          containerPath = "/data"
          readOnly      = false
        }
      ]

      links = [
        "${local.name_prefix}-execution"
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.node.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "consensus"
        }
      }
    }
  ])

  volume {
    name      = "blockchain-data"
    host_path = "/data"
  }

  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_task.arn

  tags = local.common_tags
}

resource "aws_ecs_service" "node" {
  name            = "${local.name_prefix}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = var.consensus_client_enabled ? aws_ecs_task_definition.ethereum_node[0].arn : aws_ecs_task_definition.substrate_node[0].arn
  desired_count   = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  placement_constraints {
    type       = "memberOf"
    expression = "ec2InstanceId == ${aws_instance.node.id}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws ecs update-service --cluster ${self.cluster} --service ${self.name} --desired-count 0 --force-new-deployment"
  }

  timeouts {
    delete = "5m"
  }

  tags = local.common_tags
}