resource "aws_cloudwatch_log_subscription_filter" "eks_audit_bridge" {
  name            = "eks_audit_bridge${local.branch_suffix}"
  role_arn        = "${aws_iam_role.cw.arn}"
  log_group_name  = "${local.log_group_name}"
  filter_pattern  = "{$.userIdentity.type = Root}"
  destination_arn = "${aws_kinesis_firehose_delivery_stream.eks-audit-log-stream.arn}"
}
