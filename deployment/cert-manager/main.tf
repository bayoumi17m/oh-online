terraform {
  backend "s3" {
    bucket = "queue-terraform-state"
    key    = "certmanager/terraform.tfstate"
    region = "us-east-1"
  }
}
