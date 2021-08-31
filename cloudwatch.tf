resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "cloudtrail-logs"
}

resource "aws_cloudwatch_log_metric_filter" "console_sign_in_no_mfa" {
  name           = "ConsoleSignInWithoutMfa"
  pattern        = "{ $.eventName = ConsoleLogin && $.additionalEventData.MFAUsed = \"No\" }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_logs.name

  metric_transformation {
    name      = "ConsoleSignInWithoutMfaCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_sign_in_no_mfa" {
  alarm_name                = "ConsoleSignInWithoutMfa"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "ConsoleSignInWithoutMfaCount"
  namespace                 = "CloudTrailMetrics"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "This metric monitors console logins not protected by multi-factor authentication"
  insufficient_data_actions = []
  alarm_actions = aws_sns_topic.ops_topic.arn
}

