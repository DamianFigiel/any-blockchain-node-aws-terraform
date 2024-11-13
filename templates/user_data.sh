#!/bin/bash
echo "ECS_CLUSTER=${ecs_cluster_name}" >> /etc/ecs/ecs.config

TARGET_DEVICE=/dev/nvme1n1
TARGET_DEVICE_FS=ext4
MOUNT_DIR=/data
MOUNT_DIR_OWNER=ec2-user

sudo mkfs -t $TARGET_DEVICE_FS $TARGET_DEVICE
TARGET_DEVICE_UUID=$(sudo blkid $TARGET_DEVICE -o export | grep UUID | sed 's/UUID=//' | tr -d '\n')
sudo mkdir -p $MOUNT_DIR
sudo sh -c "printf 'UUID=$TARGET_DEVICE_UUID       $MOUNT_DIR   $TARGET_DEVICE_FS    defaults,nofail 0       2\n' >> /etc/fstab"
sudo mount -a
sudo mkdir -p $MOUNT_DIR/chainstate $MOUNT_DIR/shared
sudo chown -R $MOUNT_DIR_OWNER: $MOUNT_DIR
