data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "account_trail" {
  name                          = "account_trail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_delivery.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"

}

resource "aws_iam_role" "cloudtrail_cloudwatch_delivery" {
  name               = "cloudtrail_cloudwatch_delivery_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "CloudtrailAccess"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_delivery" {
  name        = "cloudtrail_cloudwatch_delivery_role_policy"
  description = "IAM policy for role to deliver Cloudtrail logs to Cloudwatch log group"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_delivery" {
  role       = aws_iam_role.cloudtrail_cloudwatch_delivery.name
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_delivery.arn
}
