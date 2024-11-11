docker_image             = "ethereum/client-go:latest"
node_ports               = [8545, 8546, 8551, 30303, 9000, 5052]
node_name                = "ethereum-node"
consensus_client_enabled = true # Enable for Ethereum
consensus_client_image   = "sigp/lighthouse:latest"
command = [
  "--identity=ethereum-node",
  "--http",
  "--http.addr=0.0.0.0",
  "--http.api=eth,net,web3,txpool",
  "--http.corsdomain=*",
  "--ws",
  "--ws.addr=0.0.0.0",
  "--ws.api=eth,net,web3,txpool",
  "--datadir=/data",
  "--metrics",
  "--metrics.addr=0.0.0.0",
  "--authrpc.addr=0.0.0.0",
  "--authrpc.port=8551",
  "--authrpc.vhosts=*",
  "--authrpc.jwtsecret=/data/jwt.hex"
]

# Your public ssh key and IP address
# developer_public_key="ssh-rsa AAABBBCCC your.email@example.com"
# (optional) developer_ip_for_ssh = "194.163.156.10/32"

# Ethereum node data EBS volume size is bigger then default 100GB. If you want to sync uncomment this line.
# ebs_volume_size = 2000