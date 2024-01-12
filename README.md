# AWS Infrastructure with Elastic Beanstalk, Lambda, Route 53 and, S3. 

## Overview

This repository contains Terraform configurations to provision an AWS infrastructure consisting of an Elastic Beanstalk environment, a Lambda function for automatic deployments, Route 53 for DNS management and an S3 bucket for object storage.

It also contains 2 cicd pielines, one for code deployemnts in various stages such as dev, staging and prod, and the other for automatic s3 update and deletion.

## To run this infrustracture locally configure the prerequisit:

### Prerequisites

- [Terraform](https://www.terraform.io/) installed locally
- AWS credentials configured with the necessary permissions

### Getting Started

1. Create a new working Directory and change into it:

   ```bash
   mkdir <working_dir> && cd <working_dir>
   ```

2. Clone this repository:

   ```bash
   git clone <https://github.com/michaelkedey/aws_cloudfront_beanstalk_lambda_s3_config.git>
   ```

3. Change into the project repo:

   ```bash
   cd <aws_cloudfront_beanstalk_lambda_s3_config/src/infrastracture>
   ```

4. Run the format script to format all teraform files:

   ```bash
   ./format_validate_all.sh
   ```

3. Review and customize the `terraform.tfvars` files inside the `**src/infrastracture/env**/` with your specific configuration details. Also review and custumize the `backend.tf` file inside `**src/infrastracture/env**/`

5. Initialize Terraform:

   ```bash
   terraform init -var-file=<"./env/**/.terraform.tfvars"> -backend-config=<"./env/**/.backend.tfvars"
   ```

2. Plan Terraform:

   ```bash
   terraform plan -var-file=<"./env/**/.terraform.tfvars">

   ```



4. Apply the Terraform configuration:

   ```bash
   terraform apply -var-file=<"./env/**/.terraform.tfvars"> --auto-approve
   ```

   Follow the prompts to confirm the changes.

## Infrastructure Components

### Elastic Beanstalk Environment

- The Elastic Beanstalk environment is deployed in an existing VPC and private subnets.
- Configuration details can be found in the `prod_env.tf` file under `src/infrastracture/beanstalk/prod/`

### Lambda Function

- The Lambda function has an s3 even trigger which runs on s3 object creation,  automatically deploying application updates to Elastic Beanstalk from the S3 bucket.
Lambda is configured 
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

## Contributors
- [Doreen Dela Agbedoe](https://github.com/DelaDoreen)
- [Konadu Owusu-Ansah](https://github.com/konaydu)
- [Kwasi Attafua](https://github.com/Kattafuah)
- [Seyram Gabriel](https://github.com/seyramgabriel)
- [Michael Kedey](https://github.com/michaelkedey)


## Contributing

Feel free to contribute to this project by opening issues or creating pull requests.

---

This README template provides a basic structure. Be sure to customize it based on the specifics of your project, including more detailed information about each component, setup steps, and any other relevant details.