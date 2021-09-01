resource "aws_sns_topic" "ops_topic" {
  name = "alerts-topic"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.ops_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.alerting_lambda.arn
}
