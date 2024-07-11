# Testing VM with multi disk
- https://github.com/terraform-google-modules/terraform-google-vm/blob/master/examples/compute_instance/disk_snapshot/main.tf

# Set this
allow_stopping_for_update = true

# How to increase disk size after you create VM

- cannot work
  ```
  lifecycle {
    ignore_changes = [attached_disk]
  }
  ```
  change size from "10" to "15"
  ```
   - resource_manager_tags       = {} -> null
              ~ size                        = 10 -> 30 # forces replacement
  ```
# My method

1. `gcloud compute disks resize utility --size 15 --zone us-central1-c`
2. terraform refresh
3. update main.tf 
size ="15"
Ensure there is no destroy
5. terraform plan
6. terraform apply
```
2. ssh into the VM
3. `sudo resize2fs /dev/sda1`
