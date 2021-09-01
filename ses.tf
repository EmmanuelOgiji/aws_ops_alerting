resource "null_resource" "ses_verify_email" {
  triggers = {
    sender_email = var.ses_sender_email
  }
  provisioner "local-exec" {
    environment = {
      AWS_DEFAULT_REGION   = var.region
      AWS_ACCESS_KEY_ID    = var.access_key
      AWS_SECRET_ACESS_KEY = var.secret_key
    }
    command = "aws ses verify-email-identity --email-address ${self.triggers.sender_email}"
  }
}
