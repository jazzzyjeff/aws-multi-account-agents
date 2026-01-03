<h1 align="center">aws-multi-account-agents 👋</h1>

## Overview

This repository demonstrates a **hub-and-spoke AWS multi-account architecture** where **networking is centrally managed** and shared across workload accounts using **AWS Resource Access Manager (RAM)**.

A central *hub account* owns the VPC, subnets, and network services, while *spoke accounts* deploy isolated compute workloads (such as CI/CD agents) into **RAM-shared subnets**, reducing duplication, cost, and operational overhead.

## Architecture

![architecture diagram](/docs/architecture-diagram.png)

- **Hub Account**
  - Owns VPC, subnets, routing, NAT, and network security.
  - Shares private subnets with workload accounts using AWS RAM.

- **Spoke Accounts**
  - Deploy compute (EC2 / ECS / EKS).
  - Maintain isolated IAM roles and workload ownership.
  - Consume centrally managed networking.

**Please note**
- Currently only ECS is available, future scope will be implementing EC2 and EKS workloads.

## Features

- Hub-and-spoke AWS multi-account design.
- Centralised VPC and subnet management.
- AWS RAM-based subnet sharing.
- ECS-based CI/CD agent deployment (example workload).
- Clear separation of networking and workload concerns.
- Infrastructure-as-Code using Terraform and Terragrunt.

## Repository Structure

```text
terraform/
  ├── hub/         # Central networking account (VPC, RAM)
  ├── spoke/       # Workload accounts (compute, IAM)
workloads/
  └── ado-agent/   # Example ECS-based CI/CD agent
docs/              # Architecture diagrams and additional documentation
```

## Design Goals

- Minimise duplicated networking infrastructure across AWS accounts.
- Improve operational consistency and cost efficiency.
- Keep IAM and workloads isolated per account.
- Provide a reusable reference architecture for platform teams.

## Usage

See the documentation under /docs for deployment guidance.

## Author

👤 Jazz
