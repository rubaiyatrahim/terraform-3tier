/*
terraform {
  backend "s3" {
    # REPLACE with the bucket name you created in Step 2
    bucket         = "novacart-tfstate-yourname"
    key            = "foundation/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
*/