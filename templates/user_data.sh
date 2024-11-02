#!/bin/bash
echo "ECS_CLUSTER=${ecs_cluster_name}" >> /etc/ecs/ecs.config

# Create directory for blockchain data
mkdir -p /data
chmod 777 /data

# Install additional packages
yum install -y amazon-efs-utils 