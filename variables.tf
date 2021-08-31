variable "region" {
  type        = string
  description = "The region for deployment"
  default     = "eu-west-1"
}

variable "access_key" {
  type        = string
  description = "The AWS access key to access the AWS account"
  default     = ""
}

variable "secret_key" {
  type        = string
  description = "The AWS secret key to access the AWS account"
  default     = ""
}

variable "slack_webhook" {
  type        = string
  description = "The webhook to pass alerts to slack"
  default     = ""
}

variable "teams_webhook" {
  type        = string
  description = "The webhook to pass alerts to Microsoft Teams"
  default     = "https://outlook.office.com/webhook/xxxxxxx"
}

variable "chime_webhook" {
  type        = string
  description = "The webhook to pass alerts to Amazon Chime"
  default     = "https://hooks.chime.aws/incomingwebhooks/xxxxxxx"
}

variable "email_recipients" {
  type        = string
  description = "String comma separated list of emails to receive SES mails"
  default     = ""
}

variable "ses_sender_email" {
  type        = string
  description = "Verified email to serve as sender of SES emails"
  default     = ""
}

variable "enable_teams_output" {
  type        = bool
  description = "Boolean variable to tell whether to publish output from SNS to Microsoft teams"
  default     = true
}

variable "enable_chime_output" {
  type        = bool
  description = "Boolean variable to tell whether to publish output from SNS to Amazon Chime"
  default     = true
}

variable "enable_slack_output" {
  type        = bool
  description = "Boolean variable to tell whether to publish output from SNS to Amazon Chime"
  default     = true
}

variable "slack_webhook_username" {
  type        = string
  description = "The username attached to the slack webhook link"
  default     = ""
}

variable "slack_channel_name" {
  type        = string
  description = "The name of the channel for the slack webhook"
  default     = ""
}

variable "enable_ses_email_output" {
  type        = bool
  description = "Boolean variable to tell whether to publish output from SNS to emails via SES"
  default     = true
}
