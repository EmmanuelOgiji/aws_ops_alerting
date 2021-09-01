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

resource "aws_iam_policy" "alerting_lambda_role" {
  name        = "alerting_lambda_role_policy"
  description = "IAM policy for logging from a lambda and sending SES email"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "ses:SendEmail"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "alerting_lambda_role" {
  role       = aws_iam_role.alerting_lambda_role.name
  policy_arn = aws_iam_policy.alerting_lambda_role.arn
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

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alerting_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.ops_topic.arn
}