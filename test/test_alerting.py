from unittest import TestCase

from handlers.cloudwatch_alarms import CloudWatchAlarmHandler
from handlers.guardduty import GuarddutyFindingHandler


class TestAlerting(TestCase):
    def test_alerting_cloudwatch_event_validation_true(self):
        event = {
            "Records": [
                {
                    "EventSource": "aws:sns",
                    "EventVersion": "1.0",
                    "EventSubscriptionArn": "arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "Sns": {
                        "Type": "Notification",
                        "MessageId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                        "TopicArn": "arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms",
                        "Subject": "ALARM: \"Example alarm name\" in EU - Ireland",
                        "Message": "{\"AlarmName\":\"Example alarm name\",\"AlarmDescription\":\"Example alarm description.\",\"AWSAccountId\":\"000000000000\",\"NewStateValue\":\"ALARM\",\"NewStateReason\":\"Threshold Crossed: 1 datapoint (10.0) was greater than or equal to the threshold (1.0).\",\"StateChangeTime\":\"2017-01-12T16:30:42.236+0000\",\"Region\":\"EU - Ireland\",\"OldStateValue\":\"OK\",\"Trigger\":{\"MetricName\":\"DeliveryErrors\",\"Namespace\":\"ExampleNamespace\",\"Statistic\":\"SUM\",\"Unit\":null,\"Dimensions\":[],\"Period\":300,\"EvaluationPeriods\":1,\"ComparisonOperator\":\"GreaterThanOrEqualToThreshold\",\"Threshold\":1.0}}",
                        "Timestamp": "2017-01-12T16:30:42.318Z",
                        "SignatureVersion": "1",
                        "Signature": "Cg==",
                        "SigningCertUrl": "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.pem",
                        "UnsubscribeUrl": "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                        "MessageAttributes": {}
                    }
                }
            ]
        }

        cwa_handler = CloudWatchAlarmHandler()

        self.assertTrue(cwa_handler.is_event_as_expected(event))

    def test_alerting_cloudwatch_event_validation_false(self):
        event = {
            "severity": 3,
            "Finding_ID": "testId",
            "eventFirstSeen": "",
            "eventLastSeen": "",
            "Finding_Type": "UnauthorizedAccess:EC2/TorIPCaller",
            "region": "eu-west-1",
            "Finding_description": "This finding informs you that an EC2 instance in your AWS environment is receiving inbound connections from a Tor exit node."
        }

        cwa_handler = CloudWatchAlarmHandler()

        self.assertFalse(cwa_handler.is_event_as_expected(event))

    def test_alerting_guardduty_event_validation_true(self):
        event = {
            "severity": 3,
            "Finding_ID": "testId",
            "eventFirstSeen": "",
            "eventLastSeen": "",
            "Finding_Type": "UnauthorizedAccess:EC2/TorIPCaller",
            "region": "eu-west-1",
            "Finding_description": "This finding informs you that an EC2 instance in your AWS environment is receiving inbound connections from a Tor exit node."
        }

        gd_handler = GuarddutyFindingHandler()

        self.assertTrue(gd_handler.is_event_as_expected(event))

    def test_alerting_guardduty_event_validation_false(self):
        event = {
            "Records": [
                {
                    "EventSource": "aws:sns",
                    "EventVersion": "1.0",
                    "EventSubscriptionArn": "arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "Sns": {
                        "Type": "Notification",
                        "MessageId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                        "TopicArn": "arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms",
                        "Subject": "ALARM: \"Example alarm name\" in EU - Ireland",
                        "Message": "{\"AlarmName\":\"Example alarm name\",\"AlarmDescription\":\"Example alarm description.\",\"AWSAccountId\":\"000000000000\",\"NewStateValue\":\"ALARM\",\"NewStateReason\":\"Threshold Crossed: 1 datapoint (10.0) was greater than or equal to the threshold (1.0).\",\"StateChangeTime\":\"2017-01-12T16:30:42.236+0000\",\"Region\":\"EU - Ireland\",\"OldStateValue\":\"OK\",\"Trigger\":{\"MetricName\":\"DeliveryErrors\",\"Namespace\":\"ExampleNamespace\",\"Statistic\":\"SUM\",\"Unit\":null,\"Dimensions\":[],\"Period\":300,\"EvaluationPeriods\":1,\"ComparisonOperator\":\"GreaterThanOrEqualToThreshold\",\"Threshold\":1.0}}",
                        "Timestamp": "2017-01-12T16:30:42.318Z",
                        "SignatureVersion": "1",
                        "Signature": "Cg==",
                        "SigningCertUrl": "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.pem",
                        "UnsubscribeUrl": "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                        "MessageAttributes": {}
                    }
                }
            ]
        }

        gd_handler = GuarddutyFindingHandler()

        self.assertFalse(gd_handler.is_event_as_expected(event))
