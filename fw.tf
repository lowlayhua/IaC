resource "google_compute_firewall" "default" {
  name    = "minecraft-rule"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags             = [
        "minecraft-server",
    ]
}
