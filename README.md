# AWS Infrastructure with Elastic Beanstalk, Lambda, Route 53 and, S3. 

## Overview

This repository contains Terraform configurations to provision an AWS infrastructure consisting of an Elastic Beanstalk environment, a Lambda function for automatic deployments, Route 53 for DNS management and an S3 bucket for object storage.

## To run this infrustracture locally configure the prerequisit:

### Prerequisites

- [Terraform](https://www.terraform.io/) installed locally
- AWS credentials configured with the necessary permissions

### Getting Started

1. Clone this repository:

   ```bash
   git clone <repository_url>
   cd <src/infrastracture>
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review and customize the `terraform.tfvars` files inside the **src/infrastracture/env** with your specific configuration details.

4. Apply the Terraform configuration:

   ```bash
   terraform apply
   ```

   Follow the prompts to confirm the changes.

## Infrastructure Components

### Elastic Beanstalk Environment

- The Elastic Beanstalk environment is deployed in an existing VPC and subnets.
- Configuration details can be found in the `elastic_beanstalk.tf` file.

### Lambda Function

- The Lambda function automatically deploys applications to Elastic Beanstalk from an S3 bucket.
- Configuration details can be found in the `lambda_function.tf` file.

### Route 53

- Route 53 is used for DNS management.
- Configuration details can be found in the `route53.tf` file.

## Usage

- Access your Elastic Beanstalk application using the provided environment URL or custom domain (if configured).
- Monitor Lambda function execution and deployment logs in AWS CloudWatch.

## Cleanup

To destroy the provisioned infrastructure, run:

```bash
terraform destroy
```

Follow the prompts to confirm the destruction.

## Notes

- Make sure to review and update AWS credentials, region, and other sensitive information before committing to version control.

## Contributing

Feel free to contribute to this project by opening issues or creating pull requests.

---

This README template provides a basic structure. Be sure to customize it based on the specifics of your project, including more detailed information about each component, setup steps, and any other relevant details.