data "template_file" "kinesis-trust" {
  template = file("${path.module}/policies/kinesis-trust.json.tmpl")

  vars = {
    account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "kinesis" {
  template = file("${path.module}/policies/kinesis.json.tmpl")

  vars = {
    bucketname = aws_s3_bucket.audit.id
  }
}

#eks-cluster-role
resource "aws_iam_role" "kinesis" {
  name                 = "kinesis${local.branch_suffix}"
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/awt-role-boundary"
  assume_role_policy   = data.template_file.kinesis-trust.rendered
}

resource "aws_iam_policy" "kinesis" {
  name   = "kinesis${local.branch_suffix}"
  policy = data.template_file.kinesis.rendered
}

# Attach to role
resource "aws_iam_role_policy_attachment" "attach-kinesis" {
  role       = aws_iam_role.kinesis.name
  policy_arn = aws_iam_policy.kinesis.arn
}

