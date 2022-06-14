# Define backup policy
- run snapshot at 4am daily with 7 days retention period

```
resource "google_compute_resource_policy" "policy" {
  name = "daily-policy-4am"
  region = "asia-southeast1"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time = "04:00"
      }
    }
   retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
  }
}
```
# attached to disk
```
resource "google_compute_disk_resource_policy_attachment" "attachment" {
  name = google_compute_resource_policy.policy.name
  disk = "centos8-public-1"
  zone = "asia-southeast1-b"
}
```
