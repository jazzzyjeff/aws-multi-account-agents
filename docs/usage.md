# Usage

This document walks you through deploying the **Hub-and-Spoke multi-account AWS architecture** using Terraform and Terragrunt.

## Prerequisites

1. **AWS Accounts**
   - Create two AWS accounts: **Hub** and **Spoke** using **AWS Organizations**.
   - Ensure you have IAM access to both accounts with sufficient permissions.

2. **Tools**
   - [AWS CLI](https://aws.amazon.com/cli/) installed and configured
   - [Terraform](https://www.terraform.io/downloads) installed
   - [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) installed

3. **Terraform Backend**
   - Create an **S3 bucket** to store Terraform state

4. Workloads
   - Azure DevOps: Ensure the Agents pool is created and pat token generated with `Agent Pools: Read & manage` scope.

## Configuration

1. Copy the template variables file:

    ```bash
    cp live/variables.auto.tfvars.tmpl live/variables.auto.tfvars
    ```

2. Update the variables in variables.auto.tfvars:

    | Variable           | Description                                                  | Type   |
    | ------------------ | ------------------------------------------------------------ | ------ |
    | `bucket`           | Terraform state S3 bucket                                    | String |
    | `region`           | AWS region (e.g., `eu-west-2`)                               | String |
    | `service`          | Service name / project identifier                            | String |
    | `hub_account_id`   | AWS Account ID for the Hub account                           | String |
    | `spoke_account_id` | AWS Account ID for the Spoke account                         | String |
    | `ado`              | Ado payload containing `AZP_URL`, `AZP_POOL` and `AZP_TOKEN` | Map    |

## Deployment

1. Navigate to the live environment

    `cd terraform/live`

2. Initialize Terragrunt

    `terragrunt run --all init`


3. Preview the changes

    `terragrunt run --all plan`


4. Apply the infrastructure

    `terragrunt run --all apply`

Terragrunt will deploy the hub networking, share subnets via AWS RAM, and create resources in the spoke accounts.

## Verification
- Confirm that the VPC and subnets exist in the Hub account
- Confirm that RAM shares are visible in the Spoke account
- Check that any compute workloads (ECS, EC2, etc.) are running in the shared subnets

## Notes / Tips
1. You can destroy everything by running:

    `terragrunt run --all destroy`
2. In this instance the management AWS account is used as the Hub account which allows using `OrganizationAccountAccessRole` for Spoke accounts deployments.

    This is the default IAM role AWS creates when you enable AWS Organizations. Terragrunt/Terraform assumes this role to deploy resources in the spoke accounts.

    Default `~/.aws/credentials` is set to the AWS management account.

    OR

    You may choose a different IAM role or user for either hub or spoke accounts.

    In that case, update your ` ~/.aws/credentials` file and Terragrunt provider configuration (`terragrunt.hcl`) to reference the correct profile/role.
