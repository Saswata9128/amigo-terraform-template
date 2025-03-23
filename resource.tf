//region Project
  project = "kgs-o365cloudservices-terraform"

  project_name= "template_tf"

  tags = {
    itemid= "O365OpExATemplate",
    blc= 1539,
    costcenter= 54108,
    owner= "KGSOpEx@kbslp.com"
  }

  backend_bucket_name = "kgs-terraform-github-state-${var.account}"
  backend_bucket_key = "${project_name}/terraform/state.tfstate"
//endregion
