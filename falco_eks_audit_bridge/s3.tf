resource "aws_s3_bucket" "audit" {
  bucket = "eks-auditlog-${var.account_id}${replace(local.branch_suffix, "_", "-")}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name      = "eks-auditlog-${var.account_id}${replace(local.branch_suffix, "_", "-")}"
    env       = var.env
    terraform = "true"
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.audit.bucket

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowIAMAccessKinesis",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_role.kinesis.arn}"
            },
            "Action": [
                "s3:List*",
                "s3:Get*",
                "s3:Put*",
                "s3:Delete*"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.audit.id}/*",
                "arn:aws:s3:::${aws_s3_bucket.audit.id}"
            ]
        }
    ]
}
EOF

}

