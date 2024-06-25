provider "google" {
  project     = var.project
  region      = "us-west1"
}
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = var.project
  location    = "ASIA" # Replace with EU for Europe region
  uniform_bucket_level_access = true
}
terraform {
  backend "gcs" {
    bucket  = var.project
    prefix  = "terraform/state"
  }
}

# terraform init -migrate-state
