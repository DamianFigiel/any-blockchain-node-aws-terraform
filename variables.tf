variable "aws_region" {
  type        = string
  description = "AWS region to use for resources."
  default     = "eu-west-1"
}

variable "subnets_count" {
  type        = number
  description = "Number of subnets to use"
  default     = 1
}

variable "node_count" {
  type        = number
  description = "Number of nodes to use"
  default     = 1
}

variable "node_docker_image" {
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

variable "node_ports" {
  type        = list(number)
  description = "Ports for blockchain node"
  default     = [30333]
}

variable "node_name" {
  type        = string
  description = "Name for the blockchain node"
}

variable "developer_public_key" {
  type        = string
  description = "Public key for SSH access"
}

variable "developer_ip_for_ssh" {
  type        = string
  description = "IP address for SSH access"
  default     = "0.0.0.0/0"
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
variable "command" {
  type        = list(string)
  description = "Command to run for the node"
  default     = []
}

variable "consensus_client_image" {
  type        = string
  description = "Docker image for consensus client"
  default     = "sigp/lighthouse:latest"
}

variable "consensus_client_ports" {
  type        = list(number)
  description = "Ports for consensus client"
  default     = [9000, 5052]
}

variable "consensus_client_memory" {
  type        = number
  description = "Memory for consensus client"
  default     = 5120
}

variable "chain" {
  type        = string
  description = "Blockchain node (ethereum, polkadot, enjin, etc.)"
  validation {
    condition     = contains(["ethereum", "polkadot", "enjin"], var.chain)
    error_message = "Valid values for chain are: ethereum, polkadot, enjin"
  }
}
