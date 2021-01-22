data "template_file" "cw-trust" {
  template = file("${path.module}/policies/cw-trust.json.tmpl")

  vars = {
    region = var.region
  }
}

data "template_file" "cw" {
  template = file("${path.module}/policies/cw.json.tmpl")

  vars = {
    account_id  = data.aws_caller_identity.current.account_id
    region      = var.region
    cw_role_arn = aws_iam_role.cw.arn
  }
}

#eks-cluster-role
resource "aws_iam_role" "cw" {
  name = "cw${local.branch_suffix}"
  # permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/awt-role-boundary"
  assume_role_policy = data.template_file.cw-trust.rendered
}

resource "aws_iam_policy" "cw" {
  name   = "cw${local.branch_suffix}"
  policy = data.template_file.cw.rendered
}

# Attach to role
resource "aws_iam_role_policy_attachment" "attach-cw" {
  role       = aws_iam_role.cw.name
  policy_arn = aws_iam_policy.cw.arn
}

