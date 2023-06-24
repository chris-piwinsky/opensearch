# Elastic Container Service Project Setup with Terraform

This repository provides the necessary files and instructions to set up an Elastic Container Service (ECS) project using Terraform.


## Prerequisites
Before you begin, make sure you have the following prerequisites:

* [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed on your local machine
* An AWS account.
* AWS access key and secret key with sufficient permissions to create resources
* [AWS CLI V2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [AWS network setup](https://github.com/chris-piwinsky/aws_networking) project I created to stand up vpc, subnets, internet and nat gateway
* [Registered Route53 domain](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html)

## Application Setup

* Follow the [README](./src/README.MD) for instructions on how to docker the app included with this project

## Infrastructure Setup

* Clone the repository to your local machine.
* Navigate to the project directory.
* Create a `terraform.tfvars` adding your AWS_ACCESS_KEY, AWS_SECRET_KEY, and REGION.
* Run `terraform init` to download the necessary provider plugins.
* Run `terraform plan` to preview the changes that Terraform will make to your infrastructure.
* Run `terraform apply` to create the infrastructure on AWS.
* When you are finished using the infrastructure, run `terraform destroy` to delete all the resources that Terraform created.

## References

* [Postman for opensearch](https://christinavhastenrath.medium.com/how-to-test-aws-opensearch-serverless-auth-in-postman-1a288b628ac5)
* [Python code for OS](https://dylancastillo.co/opensearch-python/#connect-to-your-cluster)
* [Bulk load example](https://www.swarmee.net/blog/2019-04-02-Loading-Data-Into-ElasticSearch-With-Python/)
* [Opensearch queries](https://medium.com/@aiven-io/write-search-queries-with-python-and-opensearch-to-find-delicious-recipes-2514679b450c)

## Load data into Opensearch

I created a simple script that will load recipes into the opensearch container you created with the terraform.

Navigate to the src folder and simply run the opensearch.py file.  this will load 21k recipes into opensearch.