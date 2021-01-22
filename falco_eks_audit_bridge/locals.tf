locals {
  branch_suffix = var.env == "master" ? "" : "-${var.env}"
}

