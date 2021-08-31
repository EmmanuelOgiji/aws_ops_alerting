import json
import logging
import os
import boto3
from botocore.exceptions import ClientError


import urllib3

logger = logging.getLogger()
logging.basicConfig(level="INFO")
logger.setLevel("INFO")


def publish_output(message):
    publish_to_chime(message)
    publish_to_slack(message)
    publish_to_teams(message)
    publish_to_ses(message)


def publish_to_teams(message):
    if os.environ.get("enable_teams_output") is True:
        http = urllib3.PoolManager()
        url = os.environ.get("teams_webhook")
        payload = {
            "text": message
        }
        encoded_msg = json.dumps(payload).encode('utf-8')
        response = http.request('POST', url, body=encoded_msg)
        logger.info({
            "message": message,
            "status_code": response.status,
            "response": response.data
        })
    else:
        logger.info("Teams publishing not enabled")


def publish_to_chime(message):
    if os.environ.get("enable_chime_output") is True:
        http = urllib3.PoolManager()
        url = os.environ.get("chime_webhook")
        payload = {
            "Content": message
        }
        encoded_msg = json.dumps(payload).encode('utf-8')
        response = http.request('POST', url, body=encoded_msg)
        logger.info({
            "message": message,
            "status_code": response.status,
            "response": response.data
        })
    else:
        logger.info("Chime publishing not enabled")


def publish_to_slack(message):
    if os.environ.get("enable_slack_output") is True:
        http = urllib3.PoolManager()
        url = os.environ.get("slack_webhook")
        channel_name = os.environ.get("slack_channel_name")
        username = os.environ.get("slack_webhook_username")
        payload = {
            "channel": f"#{channel_name}",
            "username": username,
            "text": message,
            "icon_emoji": ""
        }
        encoded_msg = json.dumps(payload).encode('utf-8')
        response = http.request('POST', url, body=encoded_msg)
        logger.info({
            "message": message,
            "status_code": response.status,
            "response": response.data
        })
    else:
        logger.info("Slack publishing not enabled")


def publish_to_ses(message):
    if os.environ.get("enable_ses_email_output") is True:
        sender = os.environ.get("ses_sender_email")
        recipients_str = os.environ.get("email_recipients")
        recipients = [entry.strip() for entry in recipients_str.split(',')]

        subject = "Amazon SES Test (SDK for Python)"

        client = boto3.client('ses')

        for recipient in recipients:
            try:
                # Provide the contents of the email.
                response = client.send_email(
                    Destination={
                        'ToAddresses': [
                            recipient,
                        ],
                    },
                    Message={
                        'Body': {
                            'Text': {
                                'Charset': 'UTF-8',
                                'Data': message,
                            },
                        },
                        'Subject': {
                            'Charset': 'UTF-8',
                            'Data': subject,
                        },
                    },
                    Source=sender,
                )
            except ClientError as e:
                logger.error(e.response['Error']['Message'])
            else:
                logger.info("Email sent! Message ID:"),
                logger.info(response['MessageId'])
    else:
        logger.info("SES email not enabled")

