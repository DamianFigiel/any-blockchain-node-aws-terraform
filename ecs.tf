resource "aws_ecs_cluster" "main" {
  name = "${local.name_prefix}-cluster"

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "node" {
  family = "${local.name_prefix}-task"
  
  container_definitions = jsonencode([
    {
      name      = "${local.name_prefix}-container"
      image     = var.docker_image
      cpu       = 0
      memory    = var.node_memory
      essential = true
      
      portMappings = [
        {
          containerPort = var.node_port
          hostPort      = var.node_port
          protocol      = "tcp"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = "blockchain-data"
          containerPath = "/data"
          readOnly     = false
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
  task_role_arn           = aws_iam_role.ecs_task.arn
  execution_role_arn      = aws_iam_role.ecs_task.arn

  tags = local.common_tags
}

resource "aws_ecs_service" "node" {
  name            = "${local.name_prefix}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.node.arn
  desired_count   = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  placement_constraints {
    type       = "memberOf"
    expression = "ec2InstanceId == ${aws_instance.node.id}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
      aws ecs update-service --cluster ${self.cluster} --service ${self.name} --desired-count 0 --force-new-deployment
    EOF 
  }
  timeouts {
    delete = "5m"
  }

  tags = local.common_tags
}