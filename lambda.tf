resource "aws_iam_role" "alerting_lambda_role" {
  name = "alerting_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "alerting_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/src/alerting"
  output_path = "${path.module}/alerting_lambda.zip"
}

resource "aws_lambda_function" "alerting_lambda" {
  filename      = "${path.module}/alerting_lambda.zip"
  function_name = "alerting_lambda"
  role          = aws_iam_role.alerting_lambda_role.arn
  handler       = "alerting.lambda_handler"
  runtime       = "python3.8"

  source_code_hash = data.archive_file.alerting_lambda.output_base64sha256



  environment {
    variables = {
      slack_webhook = var.slack_webhook
      teams_webhook = var.teams_webhook
    }
  }
}