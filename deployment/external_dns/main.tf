terraform {
  backend "s3" {
    bucket = "queue-terraform-state"
    key    = "externaldns/terraform.tfstate"
    region = "us-east-1"
  }
}
