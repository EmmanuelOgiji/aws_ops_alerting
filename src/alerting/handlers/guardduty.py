from handlers.handler import EventHandler


class GuarddutyFindingHandler(EventHandler):
    def is_event_as_expected(self, event):
        return "Finding_Type" in event
