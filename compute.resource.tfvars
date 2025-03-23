
//region Lambda
  runtime ="python3.12"

  mem_size = 200 #max is 10240

  timeout = 90 #max is 900 (seconds)
//endregion


//region EC2
  ec2_instance_type = "t2.micro"

  ec2_image = "ami-052efd3df9dad4825"

  ec2_count = "1"

  ec2_keypair = "ec2_map"

  ec2_SecurityGroup= "MAP3_SecurityGroup"

  SG_Description = "This is security group for MAP3 project"
//endregion
