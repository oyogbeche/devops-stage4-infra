# DevOps Stage 4 Infrastructure

This repository contains the Terraform configuration to provision a server and trigger an Ansible playbook that installs dependencies, clones a repository, and starts the application with Docker Compose.

## Prerequisites

- Terraform
- Ansible

## Setup

1. **Clone the repository:**

    ```sh
    git clone https://github.com/oyogbeche/DevOps-Stage-4-infra.git
    cd DevOps-Stage-4-infra
    ```

3. **Initialize Terraform:**

    ```sh
    terraform init
    ```

4. **Apply Terraform configuration:**

    ```sh
    terraform apply -auto-approve
    ```

5. **Run Ansible playbook:**

    ```sh
    ansible-playbook -i inventory.ini playbook.yml
    ```

    This will install dependencies, clone the repository, and start the application using Docker Compose.

## Files

- `main.tf`: Terraform configuration file
- `inventory.ini`: Ansible inventory file
- `playbook.yml`: Ansible playbook file

## Cleaning Up

To destroy the infrastructure, run:

```sh
terraform destroy
```

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Contact

For any questions or support, please contact [your email].

