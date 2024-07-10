# https://cloud.google.com/docs/terraform/best-practices/general-style-structure

# AI Notebook Lifecycle
- https://bitbucket.org/ntuclink/terraform-google-ai-notebooks/pull-requests/2/diff
```
lifecycle {
    ignore_changes = [
      data_disk_type,
      boot_disk_type,
      disk_encryption
      disk_encryption,
      service_account_scopes,
      tags
    ]
  }
```

# GCE lifecycle
 https://gcloud-compute.com/images.html
```
lifecycle {
    ignore_changes = [attached_disk,  metadata ]
    
  }
deletion_protection = true
```

```
lifecycle {
    prevent_destroy = true  # Prevent accidental deletion
    ignore_changes = [
      "disks",               # Ignore changes in disks configuration
      "labels",              # Ignore changes in labels
    ]
  }
```

# SQL
```
resource "google_sql_database_instance" "main" {
  name = "primary-instance"
  settings {
    tier = "D0"
  }

  lifecycle {
    prevent_destroy = true
  }
}
```
