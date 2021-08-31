import json
import logging
from io import StringIO

from handlers.handler import EventHandler

logger = logging.getLogger()
logging.basicConfig(level="INFO")
logger.setLevel("INFO")


class CloudWatchAlarmHandler(EventHandler):
    def is_event_as_expected(self, event):
        try:
            message = event['Records'][0]['Sns']['Message']
        except KeyError as e:
            logger.error(e)
            return False
        return "AlarmName" in message

    def build_message_string(self, event):
        message = StringIO()
        sns_message = json.loads(event['Records'][0]['Sns']['Message'])

        account = sns_message.get("AWSAccountId")
        region = sns_message.get("Region")
        message.write(
            f"There has been a change in state of an Alarm in AWS Account: {account} in the region {region}\n\n"
        )
        message.write(f"Details of the Alarm are as follows:\n\n")

        alarm_name = sns_message.get("AlarmName")
        message.write(f"Alarm Name: {alarm_name}\n\n")

        alarm_description = sns_message.get("AlarmDescription")
        message.write(f"Alarm Description: {alarm_description}\n\n")

        alarm_new_state = sns_message.get("NewStateValue")
        message.write(f"New State Value: {alarm_new_state}\n\n")

        new_state_reason = sns_message.get("NewStateReason")
        message.write(f"New State Reason: {new_state_reason}\n\n")

        state_change_time = sns_message.get("StateChangeTime")
        message.write(f"State change time: {state_change_time}")

        logger.info(f"Output: {message.getvalue()}")
        return message.getvalue()

