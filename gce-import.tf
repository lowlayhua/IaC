import {
  id = "6266392309118355149"
  to = google_compute_instance.default
}


resource "google_compute_instance" "default" {
  name         = "layhua-disk-snapshot-001"
  machine_type = ""
  zone         = "asia-southeast1-a"


  boot_disk {
    initialize_params {
      image = ""
    }
  }
  network_interface {
    network = ""

  }
  metadata_startup_script = ""

}
