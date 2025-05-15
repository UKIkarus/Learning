<a name="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<br />
<div align="center">
  <h1 align="center">Terraform Learning Journey</h1>

  <p align="center">
    A structured learning path for mastering Terraform with Azure, focusing on best practices and secure state management.
    <br />
    <br />
    <a href="#about">About</a>
    ·
    <a href="#structure">Structure</a>
    ·
    <a href="#prerequisites">Prerequisites</a>
  </p>
</div>

## About The Project

This repository documents my journey learning Terraform with Azure, implementing infrastructure as code (IaC) best practices. The project is structured in weekly modules, each building upon the previous week's knowledge, with a central focus on secure state management.

### Built With

- Terraform
- Azure CLI
- Visual Studio Code
- WSL (Windows Subsystem for Linux)
- Git

## Structure

The repository is organized into the following sections:

- **State-Storage/**: Centralized state management infrastructure
  - Secure storage account configuration
  - Network access controls
  - State versioning and encryption
  - Resource locking

- **Week1/**: Introduction to Terraform
  - Basic resource creation
  - Variable management
  - Output handling
  - Local state management

- **Week2/**: Advanced Terraform Concepts
  - Modular architecture
  - Remote state configuration
  - Data sources
  - Resource dependencies

## Prerequisites

- Azure Subscription
- Azure CLI installed and configured
- Terraform installed (v1.x or later)
- Git for version control
- VS Code with Terraform extension
- WSL for Windows users

## Getting Started

1. Clone the repository
```bash
git clone <repository-url>
```

2. Navigate to the State-Storage directory first:
```bash
cd terraform-learning/State-Storage
terraform init
terraform apply
```

3. Configure backend for each week's project using the created state storage

## Best Practices Implemented

- Centralized state management
- Secure access controls
- Infrastructure encryption
- Resource locking
- Modular design
- Consistent naming conventions
- Proper variable scoping

## Contributing

While this is a personal learning repository, suggestions for improvements are welcome through issues or pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/UKIkarus/learning.svg?style=for-the-badge
[contributors-url]: https://github.com/UKIkarus/learning/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/UKIkarus/learning.svg?style=for-the-badge
[forks-url]: https://github.com/UKIkarus/learning/network/members
[stars-shield]: https://img.shields.io/github/stars/UKIkarus/learning.svg?style=for-the-badge
[stars-url]: https://github.com/UKIkarus/learning/stargazers
[issues-shield]: https://img.shields.io/github/issues/UKIkarus/learning.svg?style=for-the-badge
[issues-url]: https://github.com/UKIkarus/learning/issues
[license-shield]: https://img.shields.io/github/license/UKIkarus/learning.svg?style=for-the-badge
[license-url]: https://github.com/UKIkarus/learning/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/daryl-howard

<!-- Technology Shields -->
[terraform-shield]: https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white
[azure-shield]: https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white
[vscode-shield]: https://img.shields.io/badge/VSCode-0078D4?style=for-the-badge&logo=visualstudiocode&logoColor=white
[git-shield]: https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white
