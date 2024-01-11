# AWS Infrastructure with Elastic Beanstalk, Lambda, Route 53 and, S3. 

## Overview

This repository contains Terraform configurations to provision an AWS infrastructure consisting of an Elastic Beanstalk environment, a Lambda function for automatic deployments, Route 53 for DNS management and an S3 bucket for object storage.

## To run this infrustracture locally configure the prerequisit:

### Prerequisites

- [Terraform](https://www.terraform.io/) installed locally
- [AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)configured with the necessary permissions

### Getting Started

1. Create a new working Directory and change into it:

   ```bash
   mkdir <working_dir> && cd <working_dir>
   ```

2. Clone this repository:

   ```bash
   git clone <https://github.com/michaelkedey/aws_cloudfront_beanstalk_lambda_s3_config.git>
   cd <src/infrastracture>
   ```

3. Change into the project repo:

   ```bash
   cd <aws_cloudfront_beanstalk_lambda_s3_config/src/infrastracture>
   ```

4. Run the format script to format all teraform files:

   ```bash
   ./format_validate_all.sh
   ```
5. Review and customize the variables in `terraform.tfvars` file inside the `**src/infrastracture/env**/` with your specific configuration details.

5. Review and customize the backend in `backend.tfvars` file inside the `**src/infrastracture/env**/` with your specific configuration details.

6. Initialize Terraform:

   ```bash
   terraform init -var-file=<./env/**/.terraform.tfvars> -backend-config=<./env/**/.backend.tfvars>
   ```

7. Plan Terraform:

   ```bash
   terraform plan -var-file=<"./env/**/.terraform.tfvars">

   ```

8. Apply the Terraform configuration:

   ```bash
   terraform apply -var-file=<"./env/**/.terraform.tfvars"> --auto-approve
   ```

   Follow the prompts to confirm the changes.

## Infrastructure Components

### Elastic Beanstalk Environment

- The Elastic Beanstalk environment is deployed in an existing VPC and private subnets.
- Configuration details can be found in the `prod_env.tf` file under `src/infrastracture/modules/beanstalk/prod/prod_env.tf`

### Lambda Function

- The Lambda function has an s3 event trigger which runs on s3 object creation,  automatically deploying application updates to Elastic Beanstalk from the S3 bucket.
Lambda is configured to only create application versions form s3 uploads which meet a deffined criteria, enduring only relevant application code get deployed.
- Configuration details can be found in the `lambda_function.tf` file under `src/infrastracture/modules/lambda/lambda.tf`

### S3 Bucket

- An S3 bucket which serves as the storage for application codes is created in the environment. 
- Configuration details can be found in the `s3.tf` file under `src/infrastracture/modules/s3/s3.tf`

### VPC

- The vpc serves as the base container in which all other services and resources operate. The networking for this infrasytracture include
- 1 vpc with
- 2 private subnets 
- 2 public subnets
- 1 nat gateway 
- private and public route tables with route rules
- 1 security groups 
- Configuration details can be found in the `vpc.tf` file under `src/infrastracture/modules/vpc/vpc.tf`


### Elastic Load Balancer

We also have an elastic load balancer, security group, target groups and listeners for the various services and ports.
The elastic load balancer distributes incoming traffic across multiple instances of your web server, such as ec2 instances as defiind in the beanstalk environment.
Depending on your use case, you can associate this load balancer with the beanstalk, or allow benatslk create it's own load balancer, as configured.
- Configuration details can be found in the `lb.tf` file under `src/infrastracture/modules/loadbalancer/lb.tf`

### Route 53

- Route 53 is used for DNS management.
- Configuration details can be found in the `route53.tf` file.

## Usage

On succesful deployment, acces the environment cname via outputs on the terminal, or inside the AWS console.
To trigger lambda, upload an application file to s3, which meet specifications as deffined in variables `prefix` and `suffix` inside

- Access your Elastic Beanstalk application using the provided environment URL or custom domain (if configured).
- Monitor Lambda function execution and deployment logs in AWS CloudWatch.

## Cleanup

To destroy the provisioned infrastructure, run:

```bash
terraform destroy -var-file="./env/**/backend.tf"
```

Follow the prompts to confirm the destruction.

## Notes

- Make sure to review and update AWS credentials, region, and other sensitive information before committing to version control.

## Contributing

Feel free to contribute to this project by opening issues or creating pull requests.

