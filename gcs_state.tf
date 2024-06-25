provider "google" {
  project     = "qwiklabs-gcp-02-08ecb13d5dd5"
  region      = "us-west1"
}
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "qwiklabs-gcp-02-08ecb13d5dd5xxx"
  location    = "SG" # Replace with EU for Europe region
  uniform_bucket_level_access = true
}

terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}
