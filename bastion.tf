

module "iap_bastion" {
  source = "terraform-google-modules/bastion-host/google"
  version = "6.0.0"

  project = var.project
  region =  var.region
  zone = "asia-southeast1-b"
  network = "fpg-playground-vpc"
  subnet =  "fpg-playground-vpc"

  members = [
    "group:sre@xxx.sg",
    "group:dba@xxx.sg",
  ]
}
