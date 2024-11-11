output "instance_public_ip" {
  description = "Public IP of the blockchain node"
  value       = aws_instance.node.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.node.id
}

output "instance_dns_to_ssh" {
  description = "DNS of the EC2 instance"
  value       = "ec2-user@${aws_instance.node.public_dns}"
}
