resource "aws_security_group" "node" {
  name        = "${local.name_prefix}-sg"
  description = "Security group for blockchain node"
  vpc_id      = module.app.vpc_id

  dynamic "ingress" {
    for_each = var.node_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sg"
  })
}

resource "aws_key_pair" "node" {
  key_name   = "${local.name_prefix}-key"
  public_key = var.developer_public_key
}

resource "aws_instance" "node" {
  depends_on    = [aws_ecs_cluster.main]
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = module.app.public_subnets[0]

  vpc_security_group_ids = [aws_security_group.node.id]
  key_name               = aws_key_pair.node.key_name

  iam_instance_profile = aws_iam_instance_profile.node.name
  user_data = templatefile("${path.module}/templates/user_data.sh", {
    ecs_cluster_name = aws_ecs_cluster.main.name
  })

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  ebs_block_device {
    device_name = "/dev/xvdf"
    volume_size = var.ebs_volume_size
    volume_type = "gp3"
    encrypted   = true

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-data"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-instance"
  })
} 