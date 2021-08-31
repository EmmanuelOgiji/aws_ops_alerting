resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "cloudtrail-logs"
}

resource "aws_cloudwatch_event_rule" "guarduty_findings" {
  name        = "guardduty-events"
  description = "GuardDutyEvent"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.guardduty"
  ],
  "detail-type": [
    "GuardDuty Finding"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "guarduty_findings" {
  rule      = aws_cloudwatch_event_rule.guarduty_findings.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.ops_topic.arn
}