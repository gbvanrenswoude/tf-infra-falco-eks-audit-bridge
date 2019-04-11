resource "aws_kinesis_firehose_delivery_stream" "eks-audit-log-stream" {
  name        = "eks-audit-log-stream${local.branch_suffix}"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = "${aws_iam_role.kinesis.arn}"
    bucket_arn = "${aws_s3_bucket.audit.arn}"
  }
}
