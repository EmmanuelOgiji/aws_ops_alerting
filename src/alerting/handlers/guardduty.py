import logging
from io import StringIO

from handlers.handler import EventHandler

logger = logging.getLogger()
logging.basicConfig(level="INFO")
logger.setLevel("INFO")


class GuarddutyFindingHandler(EventHandler):
    def is_event_as_expected(self, event):
        return "Finding_Type" in event

    def build_message_string(self, event):
        message = StringIO()
        account_id = event.get("Account_Id")
        region = event.get("region")
        finding_type = event.get("Finding_Type")
        finding_description = event.get("Finding_description")
        finding_id = event.get("Finding_ID")
        first_seen = event.get("eventFirstSeen")
        last_seen = event.get("eventLastSeen")

        message.write(
            f"There has been a Guardduty finding in AWS Account: {account_id} in the {region} region\n\n"
        )
        message.write(f"Details of the Finding are as follows:\n\n")
        message.write(f"Finding Type: {finding_type}\n\n")
        message.write(f"Finding Description: {finding_description}\n\n")
        message.write(f"Finding Id: {finding_id}\n\n")
        message.write(f"Event First Seen: {first_seen}\n\n")
        message.write(f"Event Last Seen: {last_seen}")

        logger.info(f"Output: {message.getvalue()}")
        return message.getvalue()
