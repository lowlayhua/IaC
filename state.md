# migrate from local to GCS
-`terraform init -migrate-state`

# GCS
```
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "qwiklabs-gcp-03-c26136e27648"
  location    = "US"
  uniform_bucket_level_access = true
  force_destroy = true
}
```

# 
terraform show -no-color > docker.tf
