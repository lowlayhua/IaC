# Refer https://gcloud-compute.com/images.html for OS images
resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}


resource "google_compute_disk" "default" {
  name = "adisk-1"
  size = 15
  zone = "asia-southeast1-b"
  type = "pd-ssd"
}

resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.default.id
  instance = google_compute_instance.vm_instance.id
}

resource "google_compute_instance" "vm_instance" {
  name         = var.vmname
  machine_type = var.machine_type
  zone = var.zone

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.size
    }
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  labels = var.labels


  metadata = {
    enable-oslogin = "true"
  }


  network_interface {
    access_config {
#      network_tier = "PREMIUM"
    }

    stack_type  = "IPV4_ONLY"
    subnetwork  = var.subnetwork
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }


  service_account {
#    scopes = var.scopes
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = var.metadata_startup_script

}
