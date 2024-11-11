docker_image         = "enjin/relaychain:latest" #if you plan to use it for production, please use specfic image version, not latest, to avoid unintended version updates
node_ports           = [9615, 9944, 30333, 30334]
node_name            = "enjin-relaychain-node"
command = [
  "--name=enjin-relaychain-rpc",
  "--rpc-external",
  "--rpc-cors=all",
  "--chain=enjin",
  "--base-path=/data",
  "--prometheus-external"
]

# Your public ssh key and IP address
# developer_public_key="ssh-rsa AAABBBCCC your.email@example.com"
# (optional) developer_ip_for_ssh = "194.163.156.10/32"

# Enjin Relaychain node data EBS volume size is bigger then default 100GB. If you want to sync complete history uncomment this line.
# ebs_volume_size = 300

