# https://cloud.google.com/docs/terraform/best-practices/general-style-structure

# AI Notebook Lifecycle
- https://bitbucket.org/ntuclink/terraform-google-ai-notebooks/pull-requests/2/diff

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


# GCE lifecycle
lifecycle {
    ignore_changes = [attached_disk, tags]

  }



# SQL

resource "google_sql_database_instance" "main" {
  name = "primary-instance"
  settings {
    tier = "D0"
  }

  lifecycle {
    prevent_destroy = true
  }
}
