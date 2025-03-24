//region Project
  project = "amigo"

  project_name= "template_tf"

  tags = {
    itemid= "amigotemplate",
    blc= 1234,
    costcenter= 1234,
    owner= "amigo.com"
  }

  backend_bucket_name = "amigo-terraform-github-state-${var.account}"
  backend_bucket_key = "${project_name}/terraform/state.tfstate"
//endregion
