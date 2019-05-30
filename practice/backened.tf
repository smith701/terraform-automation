terraform {
  backend "gcs" {
    bucket  = "tf-state-dev1"
    prefix  = "john/terraforam.tfstate"
  }
}
