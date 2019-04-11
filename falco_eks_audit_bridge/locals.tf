locals {
  branch_suffix  = "${var.env == "master" ? "" : "-${var.env}"}"
  log_group_name = "/aws/eks/clustername${var.env == "master" ? "" : "-${var.env}"}/cluster"
}
