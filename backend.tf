terraform {
  backend "s3" {
    bucket = "sudha-migration-bucket"
    key    = "terraform.tfsate"
    region = "eu-west-1"
  }
}