terraform {
  backend "s3" {
  bucket = "backend_bucket_name"
  key =  "backend_bucket_key"
  region =  "region"
  dynamodb_table = "kgs-terraform-github-state"
  encrypt =  true
    }
}
