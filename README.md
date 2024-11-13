# Any Blockchain Node Deployment on AWS

This repository contains Infrastructure as Code (IaC) templates and instructions for deploying blockchain nodes on AWS infrastructure. The templates support multiple blockchain networks and can be easily extended to support additional chains.

## Supported Chains

Currently supported blockchain networks:

- Ethereum (Execution + Consensus clients)
- Polkadot
- Enjin Relaychain

## Prerequisites

Before you begin, ensure you have:

- AWS Account with appropriate permissions
- AWS CLI installed and configured
- SSH key pair for EC2 access
- Terraform installed (>= 1.2.0)

### AWS Credentials Setup

Configure your AWS credentials using one of these methods:

1. Environment variables:
   ```bash
   export AWS_ACCESS_KEY_ID=your-access-key
   export AWS_SECRET_ACCESS_KEY=your-secret-access-key
   export AWS_REGION=your-preferred-region
   ```

2. Or using AWS CLI:
   ```bash
   aws configure
   ```

⚠️ **Security Note:** Never commit AWS credentials to version control. Consider using AWS Vault or similar tools for credential management in production environments.

## Important Considerations

### Storage Requirements

⚠️ **Important:** The default EBS volume size is 100GB, which is insufficient for most blockchain full nodes. You should adjust the volume size based on your specific blockchain requirements:

- Ethereum: Recommended 2TB+
- Polkadot: Recommended 1.5TB+
- Enjin Relaychain: Recommended 300GB+

To modify the storage size, uncomment and adjust the `ebs_volume_size` variable in the respective chain's `.tfvars` file.

## Deployment Instructions

### 1. Configure SSH Access

1. Generate an SSH key pair if you don't have one:
   ```bash
   ssh-keygen -t rsa -b 4096
   ```

2. Copy your public key content:
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```

3. Note it for later update the `developer_public_key` variable in your chosen chain's `.tfvars` file:
   ```hcl
   developer_public_key = "ssh-rsa AAAA... your.email@example.com"
   ```

### 2. Developer IP address to restric SSH access to node (optional, but recommended)

1. Identify your development IP address
2. Note it for later update the `developer_ip_for_ssh` variable in the chain-specific `.tfvars` file

### 3. Deploy a Blockchain Node

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/blockchain-node-aws.git
   cd blockchain-node-aws
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Choose your blockchain network and update the corresponding `.tfvars` file in the `chains/` directory:
   - Update the `developer_public_key` with your SSH public key
   - Update the `developer_ip_for_ssh` with your IP address
   - Adjust the `ebs_volume_size` if needed

4. Deploy the infrastructure:
   ```bash
   terraform plan -var-file="chains/[chain-name].tfvars" -out=[chain-name].tfplan
   terraform apply [chain-name].tfplan
   ```

   ⚠️ **Cost Warning:** Deploying this infrastructure will incur costs in your AWS account.

5. To destroy the infrastructure when no longer needed:
   ```bash
   terraform destroy -var-file="chains/[chain-name].tfvars" -auto-approve
   ```

   ⚠️ **Warning:** This will permanently delete all resources and data. Make sure to backup any important blockchain data before destroying.

## Architecture Components

The infrastructure utilizes several AWS services:

- **VPC**: Isolated network environment
  - Custom VPC with public subnets
  - Internet Gateway for public access

- **EC2**: Compute instances
  - Amazon Linux 2 with ECS optimization
  - Auto-configured with user data script
  - EBS volumes for blockchain data

- **ECS**: Container orchestration
  - ECS Cluster for container management
  - Task definitions for blockchain node

- **CloudWatch**: Monitoring and logging
  - Container logs
  - Metrics collection

- **Security Groups**: Network access control
  - SSH access from specified IP
  - Blockchain-specific port access
  - Outbound internet access

## Contributing

Contributions welcome! Please feel free to:

- Add support for new blockchain networks
- Improve existing configurations
- Update documentation
- Fix bugs

Please submit pull requests with clear descriptions of changes and updates to documentation.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions:
1. Check existing issues
2. Create a new issue with detailed information
3. Join our community discussions

## Additional Resources

- [Medium Article](coming-soon) - Detailed setup guide and architecture explanation
- [LinkedIn Post](coming-soon) - Project announcement and community updates

## Maintainers

- [Damian Figiel](https://github.com/DamianFigiel)
