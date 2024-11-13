output "instance_public_ips" {
  description = "Public IPs of the blockchain nodes"
  value       = aws_instance.node.*.public_ip
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.node.*.id
}

output "instance_dns_to_ssh" {
  value       = formatlist("ec2-user@%s", aws_instance.node[*].public_dns)
  description = "The DNS addresses to SSH to the instances"
}
