import logging

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
