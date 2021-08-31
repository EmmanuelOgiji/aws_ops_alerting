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
  input_transformer {
    input_paths = {
      severity     = "$.detail.severity",
      finding_type = "$.detail.type",
      region       = "$.region",
      description  = "$.detail.description",
      first_seen   = "$.detail.service.eventFirstSeen",
      last_seen    = "$.detail.service.eventLastSeen",
      id           = "$.detail.id"

    }
    input_template = <<EOF

{
    "severity": <severity>,
    "Finding_ID": <id>,
    "eventFirstSeen": <first_seen>,
    "eventLastSeen": <last_seen>,
    "Finding_Type": <finding_type>,
    "region": <region>,
    "Finding_description": <description>
}
EOF
  }
}
