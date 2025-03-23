# Terraform Template



## Description
This is a template project for AWS resources. You should be able to use this project as a template to start deploying various AWS resources using Terraform.

## Prerequisites


## Basic Structure
There are some file names that are meaningful convention in terraform, you'll see in this project the following files where names matter.
```
.
|____main.tf        # This is the entry point for your terraform code
|____providers.tf   # This is where you define the platforms you will interact with
|____variables.tf   # This is where you will store variables
|____app_integration_resources.tfvars    # This is where you will add all the variables for each project
|____compute_resources.tfvars    # This is where you will add all the variables for each project
|____database_resources.tfvars    # This is where you will add all the variables for each project
|____storage_resources.tfvars    # This is where you will add all the variables for each project
|____prod_project.tfvars    # This is where you will add all the variables for each project
|____backend.tf     # This is where you will optionally specify a remote state
```

## Resources Available
* API Gateway
* Lambda
* RDS Cluster
* S3 Bucket
* SQS Queue
* Step Function
* EC2
* Glue Crawler
* Lambda Layers
* Aurora
* DynamoDB

## State
Terraform has to store state somewhere or else you will get some undesirable 
behaviors. We are using the GitLab HTTP Backend for Terraform to store our state 
for this project. The configuration for this exists in two core places, `backend.tf`
and `.gitlab-ci.yml`.

## How to Use

1) Create a new project repo in GitLab 
2) Select "Create from Template"
3) Use this template
4) Clone project to local machine 
5) Make new branch 
6) Make changes to `prod.tfvars` file 
   1) This file allows certain customizations to the project
7) If you want to add resources:
   1) Remove desired resource file from `extra_resources` folder
   2) In `main.tf` uncomment desired resource 
8) If you want to remove resources:
   1) Move the files into `extra_resources` folder
   2) In `main.tf` comment out the resource information
9) If you add/remove resources you may need to rework other resources that were tied to it


## Contributors
