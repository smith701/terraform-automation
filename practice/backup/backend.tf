terraform {
  backend "gcs" {
    bucket  = "tf-state-dev1"
    prefix  = "cust1/terraform.tfstate"
  }
}
