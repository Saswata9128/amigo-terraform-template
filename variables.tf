//region AWS Specific

  variable "region" {
    default = "us-east-1"
  }

  variable "project" {
    type = string
  }

  variable "account" {
    type = string
    description = "account to deploy to through pipeline"
  }

  variable "env" {
    type = string 
    description = "environment label for resources"
  }
//endregion

//region Project Specific
  variable "tags" {
    type = map(string)
    description = "Tags to add to each resource"
  }

  variable "project_name" {
    type = string
    description = "Name of project in AWS"
  }

  variable "dev" {
      type = string
      description = "environement Dev"
  }

  variable "prod" {
      type = string
      description = "environement Dev"
  }

//endregion


//region Compute 
  //region EC2 Specific

    variable "ec2_instance_type" {
      type = string
      description = "Instance type for your EC2"
    }

    variable "ec2_image" {
      type = string
      description = "image type for ec2"
    }

    variable "ec2_keypair" {
      type = string
      description = "Name of the Keypair to use for ec2"
    }

    variable "ec2_count" {
      type = string
      description = "number of ec2 instances to spin up"
    }

    variable "ec2_SecurityGroup" {
      type = string
    }

    variable "SG_Description" {
      type = string
    }

  //endregion

  //region Lambda Specific
    variable "runtime" {
      type = string
      description = "Map of Runtime for the Lambda Functions"
    }

    variable "timeout" {
      type = string
      description = "Timeout for the Lambda Function, maximum of 900 seconds"
    }

    variable "mem_size" {
      type = string
      description = "Memory for the Lambda, maximum of 10240"
    }
  //endregion
//endregion

//region App Integration
  //region API Specific
    variable "api_description" {
        type = string
      description = "description for the api"
    }

    variable "api_path" {
      type = string
      description = "path part for the api"
    }

    variable "request_params" {
      type = list(string)
      description = "list of request parameters for the api"
    }
  //endregion
  //region SQS Specific
    variable "Sqs_Name" {
      type        = string
      description = "SQS Queue name"
    }
    variable "Sqs_Delay_Seconds" {
      type = number
    }
    variable "Sqs_Visibility_Timeout_Seconds" {
      type = number
    }
    variable "Sqs_Message_Size" {
      type = number
    }
    variable "Sqs_MessageRetension_Seconds" {
      type = number
    }
    variable "Sqs_ReceiveWait_Seconds" {
      type = number
    }
    variable "Sqs_DeadLetterQueue" {
      type        = string
      description = "DeadLetterQueue name"
    }
  //endregion
  //region Step Function

  //endregion
//endregion

//region Database
  //region DynamoDB Specific
    variable "billing_mode" {
      type = string
      description = "type of billing mode for dynamo table (ex: PAY_PER_REQUEST)"
    }

    variable "dynamo_db_name" {
      type = string
      description = "Name for the Dynamo table"
    }

    variable "dynamo_db_attributes" {
      type = map(string)
      description = "Attributes for the dynamo table"
    }
  //endregion

  //region RDS DB Specific
    variable "rds_cluster_identifier" {
      type = string
      description = "name of cluster"
    }
    variable "rds_engine" {
      type = string
      description = "type of db engine ex: aurora-mySQL"
    }
    variable "rds_engine_version" {
      type = string
      description = "version for the engine"
    }
    variable "rds_engine_mode" {
      type = string
      description = "type of engine to use ex: serverless"
    }

    variable "rds_secret" {
      type = string
      description = "Secret arn used for RDS credentials"
    }

    variable "rds_http_endpoint" {
      type = bool
      description = "boolean to represent if you have access with http endpoint"
    }

    variable "backend_bucket_name"{
        type = string
        description = "used to define backend bucket name"
        }

    variable "backend_bucket_key"{
        type = string
        description = "used to define the bucket key and dynamo key"
        }
  //endregion
//endregion

//region Storage
//endregion
