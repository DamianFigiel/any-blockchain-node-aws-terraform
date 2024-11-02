variable "aws_region" {
  type        = string
  description = "AWS region to use for resources."
  default     = "eu-west-1"
}

variable "docker_image" {
  type        = string
  description = "Docker image to use for the node (e.g. parity/polkadot:latest)"
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "r6i.large"
}

variable "node_memory" {
  type        = number
  description = "Memory for the node"
  default     = 15360
}

variable "ebs_volume_size" {
  type        = number
  description = "Size of EBS volume for node data"
  default     = 100
}

variable "node_port" {
  type        = number
  description = "Port for blockchain node"
  default     = 30333
}

variable "node_name" {
  type        = string
  description = "Name for the blockchain node"
}

variable "developer_public_key" {
  type        = string
  description = "Public key for SSH access"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
} 