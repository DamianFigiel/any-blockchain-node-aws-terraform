# Contributing to AWS Blockchain Node Deployment

Thank you for your interest in contributing! We aim to make contributing to this project as easy and transparent as possible.

## Prerequisites

- Basic understanding of Terraform and AWS
- Terraform >= 1.2.0
- AWS CLI configured with appropriate credentials

## Code Style Guidelines

### Terraform Style
- Use 2 spaces for indentation
- Use snake_case for resource names and variables
- Include descriptions for all variables and outputs
- Group related resources in the same file
- Use meaningful names that reflect resource purpose

## Pull Request Process

1. Fork the repository
2. Create a feature branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes
4. Commit your changes with a descriptive message:
   ```bash
   git commit -m "feat: add support for new blockchain"
   ```
5. Push to your fork and create a Pull Request

### PR Requirements
- Clear description of changes
- Updated documentation if needed
- No hardcoded credentials or sensitive data
- All GitHub Actions checks must pass

## What Can I Contribute?

- Add support for new blockchain networks
- Improve existing configurations
- Update documentation
- Fix bugs
- Add new features

## Testing

Before submitting a PR, please:
1. Test the deployment with at least one blockchain network
2. Verify all outputs are correct
3. Verify node connectivity
4. Test the cleanup/destruction process

## Questions or Problems?

- Open an issue for bugs
- Use discussions for questions
- Tag maintainers for urgent issues

## License

By contributing, you agree that your contributions will be licensed under the MIT License.