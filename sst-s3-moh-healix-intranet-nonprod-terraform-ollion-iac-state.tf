# /Users/jco/ollion/s3
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
provider "aws" {
  region = "ap-southeast-1"
}
# aws_s3_bucket.example:
resource "aws_s3_bucket" "example" {
#    bucket                      = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state"
     bucket = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state"
    object_lock_enabled         = false
    policy                      = jsonencode(
        {
            Id        = "EnforceSSLONLY"
            Statement = [
                {
                    Action    = "s3:*"
                    Condition = {
                        Bool = {
                            "aws:SecureTransport" = "false"
                        }
                    }
                    Effect    = "Deny"
                    Principal = "*"
                    Resource  = [
                        "arn:aws:s3:::sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state",
                        "arn:aws:s3:::sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state/*",
                    ]
                    Sid       = "AllowSSLRequestsOnly"
                },
                {
                    Action    = "s3:*"
                    Condition = {
                        NumericLessThan = {
                            "s3:TlsVersion" = "1.2"
                        }
                    }
                    Effect    = "Deny"
                    Principal = "*"
                    Resource  = [
                        "arn:aws:s3:::sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state",
                        "arn:aws:s3:::sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state/*",
                    ]
                    Sid       = "AllowTLS1.2RequestsOnly"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    request_payer               = "BucketOwner"
    tags                        = {
        "Agency-code"         = "moh"
        "Create-method"       = "manual"
        "Data-Classification" = "Restricted"
        "Data-Sensitivity"    = "Sensitive High"
        "Name"                = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state"
        "Project-code"        = "healix"
        "Purpose"             = "To store the Terraform state for Ollion-created resources"
        "Zone"                = "iz"
        "awsbackup"           = "s3"
    }
    tags_all                    = {
        "Agency-code"         = "moh"
        "Create-method"       = "manual"
        "Data-Classification" = "Restricted"
        "Data-Sensitivity"    = "Sensitive High"
        "Name"                = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state"
        "Project-code"        = "healix"
        "Purpose"             = "To store the Terraform state for Ollion-created resources"
        "Zone"                = "iz"
        "awsbackup"           = "s3"
    }
#    logging {
#        target_bucket = "sst-s3-moh-healix-iz-uat-s3accesslogs"
#        target_prefix = "sst-s3-moh-healix-uat-terraform-ollion-iac-state/"
#    }
    server_side_encryption_configuration {
        rule {
            bucket_key_enabled = true
            apply_server_side_encryption_by_default {
                kms_master_key_id = null
                sse_algorithm     = "AES256"
            }
        }
    }
    versioning {
        enabled    = true
        mfa_delete = false
    }
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.example.id

  target_bucket = "sst-s3-moh-healix-iz-uat-s3accesslogs"
  target_prefix = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state/log/"
}
jco@Mac s3 % git branch
fatal: not a git repository (or any of the parent directories): .git
jco@Mac s3 % pwd
/Users/jco/ollion/s3
jco@Mac s3 % ls
intranet-s3-state.txt							terraform.tfstate
sst-s3-moh-healix-intranet-nonprod-terraform-ollion-iac-state.tf	terraform.tfstate.backup
jco@Mac s3 % more sst-s3-moh-healix-intranet-nonprod-terraform-ollion-iac-state.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
provider "aws" {
  region = "ap-southeast-1"
}
# aws_s3_bucket.example:
resource "aws_s3_bucket" "example" {
#    bucket                      = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state"
     bucket = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state"
    object_lock_enabled         = false
    policy                      = jsonencode(
        {
            Id        = "EnforceSSLONLY"
            Statement = [
                {
                    Action    = "s3:*"
                    Condition = {
                        Bool = {
                            "aws:SecureTransport" = "false"
                        }
                    }
                    Effect    = "Deny"
                    Principal = "*"
                    Resource  = [
                        "arn:aws:s3:::sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state",
                        "arn:aws:s3:::sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state/*",
                    ]
                    Sid       = "AllowSSLRequestsOnly"
                },
                {
                    Action    = "s3:*"
                    Condition = {
                        NumericLessThan = {
                            "s3:TlsVersion" = "1.2"
                        }
                    }
                    Effect    = "Deny"
                    Principal = "*"
                    Resource  = [
                        "arn:aws:s3:::sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state",
                        "arn:aws:s3:::sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state/*",
                    ]
                    Sid       = "AllowTLS1.2RequestsOnly"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    request_payer               = "BucketOwner"
    tags                        = {
        "Agency-code"         = "moh"
        "Create-method"       = "manual"
        "Data-Classification" = "Restricted"
        "Data-Sensitivity"    = "Sensitive High"
        "Name"                = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state"
        "Project-code"        = "healix"
        "Purpose"             = "To store the Terraform state for Ollion-created resources"
        "Zone"                = "iz"
        "awsbackup"           = "s3"
    }
    tags_all                    = {
        "Agency-code"         = "moh"
        "Create-method"       = "manual"
        "Data-Classification" = "Restricted"
        "Data-Sensitivity"    = "Sensitive High"
        "Name"                = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state"
        "Project-code"        = "healix"
        "Purpose"             = "To store the Terraform state for Ollion-created resources"
        "Zone"                = "iz"
        "awsbackup"           = "s3"
    }
#    logging {
#        target_bucket = "sst-s3-moh-healix-iz-uat-s3accesslogs"
#        target_prefix = "sst-s3-moh-healix-uat-terraform-ollion-iac-state/"
#    }
    server_side_encryption_configuration {
        rule {
            bucket_key_enabled = true
            apply_server_side_encryption_by_default {
                kms_master_key_id = null
                sse_algorithm     = "AES256"
            }
        }
    }
    versioning {
        enabled    = true
        mfa_delete = false
    }
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.example.id

  target_bucket = "sst-s3-moh-healix-iz-uat-s3accesslogs"
  target_prefix = "sst-s3-moh-iz-healix-nonprod-terraform-ollion-iac-state/log/"
}
