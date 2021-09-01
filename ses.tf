resource "null_resource" "ses_verify_email" {
  count = length(local.ses_emails)
  triggers = {
    sender           = var.ses_sender_email
    email_recipients = var.email_recipients
  }

  provisioner "local-exec" {
    environment = {
      AWS_DEFAULT_REGION = var.region
    }
    command = "echo $(aws ses verify-email-identity --email-address ${local.ses_emails[count.index]})"
  }
}

locals {
  ses_emails = concat([var.ses_sender_email], compact(split(",", var.email_recipients)))
}
