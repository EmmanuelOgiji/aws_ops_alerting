import logging

from handlers.cloudwatch_alarms import CloudWatchAlarmHandler
from handlers.guardduty import GuarddutyFindingHandler

logger = logging.getLogger()
logging.basicConfig(level="INFO")
logger.setLevel("INFO")

HANDLERS = [
    CloudWatchAlarmHandler(),
    GuarddutyFindingHandler()
]


def lambda_handler(event, context):
    for handler in HANDLERS:
        if handler.is_event_as_expected(event):
            message = handler.build_message_string(event)


