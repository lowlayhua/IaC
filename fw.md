# firewall.tf
```
/******************************************
  Firewall rules
 *****************************************/

resource "google_compute_firewall" "fw" {
  for_each = { for x in var.firewall_rules : x.name => x }

  name    = each.key
  network = var.network
  project = var.project_id

  allow {
    protocol = each.value.protocol
    ports    = lookup(each.value, "ports", null)
  }

  target_tags   = lookup(each.value, "target_tags", null)
  source_ranges = each.value.source_ranges
}

# env.auto.tfvars
project_id                = "ne-xxxx"
network                   = "gaxxxx"
firewall_rules = [
  {
    name        = "allow-rdp"
    protocol    = "tcp"
    ports       = [3389]
    target_tags = ["allow-rdp"]

    source_ranges = [
      "10.30.0.0/22"
    ]
  },
  {
    name        = "allow-http"
    protocol    = "tcp"
    ports       = [80, 443]
    target_tags = ["http"]

    source_ranges = [
      "172.30.0.0/16",
      "192.168.8.0/21"
    ]
  }
}

labels = {
  env                    = "prod",
  "cost-center"          = "infra",
  "bitbucket-repo-owner" = "ntuclink",
  "bitbucket-repo-slug"  = "infra-gcp-core",
  "terraform"            = "true"
  "owner"                = "ne_techinfra_sre_all_ntucenterprise_sg"
}
