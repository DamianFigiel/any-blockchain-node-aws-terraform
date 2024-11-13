chain             = "polkadot"
node_docker_image = "parity/polkadot:latest"
node_ports        = [9615, 9944, 30333]
node_name         = "polkadot-node"
command = [
  "--name=polkadot-node",
  "--rpc-external",
  "--rpc-cors=all",
  "--chain=polkadot",
  "--base-path=/data",
  "--prometheus-external"
]

# Your public ssh key and IP address
# developer_public_key = "ssh-rsa AAABBBCCC your.email@example.com"
# (optional, but recommended) developer_ip_for_ssh = "194.163.156.10/32"

# Polkadot node data EBS volume size is bigger then default 100GB. If you want to sync complete history uncomment this line.
# ebs_volume_size = 1500
