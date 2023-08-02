# Terraform Validator 
- to detect policy violations and provide warnings or halt deployments before they reach production.
- 1gcloud beta terraform vet` is different from the `terraform validate` command.

# Questions

- Explain the Terraform workflow. In which phase of the Terraform workflow do you write configuration files based on the scope defined by your organization? `Author`
- Create, update, and destroy Google Cloud resources using Terraform. In which phase of the Terraform workflow can you run pre-deployment checks against the policy library? `Validate`
- Explain the purpose of Terraform commands Which command creates infrastructure resources? `terraform apply`
- Can a variable be assigned values in multiple ways? '`yes`
- How many resource types can be represented in a single resource block? `one`
- How can output values be used? `Print resource attributes`
- Which dependency can be automatically detected by Terraform? `Implicit dependency`
- 

# Create GCE
```
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}
provider "google" {
  region  = "us-central1"
  zone    = "us-central1-c"
}
resource "google_compute_instance" "terraform" {
  name         = "terraform"
  machine_type = "e2-medium"
  tags         = ["web", "dev"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
network_interface {
    network = "default"
    access_config {
    }
}
allow_stopping_for_update = true
}
```

# To view resource dependency graph of the resource created,
- `terraform graph | dot -Tsvg`
