terraform {
  backend "s3" {
    bucket               = "yourstatebackend"
    key                  = "terraform.tfstate"
    region               = "eu-west-1"
    workspace_key_prefix = "falco_eks_audit_bridge"
    encrypt              = true
    kms_key_id           = "arn:aws:kms:eu-west-1:111111111111:alias/yourstatekmskeyalias"
    dynamodb_table       = "YourTerraformLockTable"
  }
}
