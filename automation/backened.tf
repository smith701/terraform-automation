terraform {
  backend "gcs" {
    bucket  = "tf-state-dev1"
    prefix  = "cust97/terraforam.tfstate"
  }
}
