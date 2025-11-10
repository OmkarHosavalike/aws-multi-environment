# AWS Multi-Environment Deployment

This repo demonstrates deploying **dev** and **prod** environments on AWS using **Terraform** and **Ansible**, with **GitHub Actions** automation.

---

## Features

- EC2 instances behind an **ALB**
- Security group allowing HTTP from anywhere and SSH from your IP
- Multi-AZ setup with public subnets
- **Environment-specific deployment**:
  - Terraform selects **instance type** based on `dev` or `prod`
  - Ansible deploys **blue/green styling** (index page background color)
- Dynamic inventory for Ansible
- GitHub OIDC for secure AWS access

---

## GitHub Secrets & Variables

| Name | Type | Description |
|------|------|-------------|
| `BACKEND_S3_BUCKET` | Secret | S3 bucket for Terraform state |
| `OIDC_IAM_ROLE` | Secret | IAM role for GitHub OIDC (EC2, S3, ELB full access) |
| `ENVIRONMENT` | Variable | `dev` or `prod` to select deployment environment |

---