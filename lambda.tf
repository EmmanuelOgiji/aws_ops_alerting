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
      slack_webhook           = var.slack_webhook
      teams_webhook           = var.teams_webhook
      chime_webhook           = var.chime_webhook
      enable_teams_output     = var.enable_teams_output
      enable_chime_output     = var.enable_chime_output
      enable_slack_output     = var.enable_chime_output
      slack_channel_name      = var.slack_channel_name
      slack_webhook_username  = var.slack_webhook_username
      enable_ses_email_output = var.enable_ses_email_output
      email_recipients        = var.email_recipients
      ses_sender_email        = var.ses_sender_email
    }
  }
}