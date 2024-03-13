
class HardTask:
    
    def __init__(self,taskID,name,start_date_time,end_date_time,location=None):
        # identifier unique to task - type: Int
        self.taskID = taskID 
        # task name
        self.name = name
        # time task begins
        self.start_date_time = start_date_time
        # time task ends
        self.end_date_time = end_date_time
        # <lat,long> of location of task - default = None
        self.location = location        

    def getID(self):
        return self.taskID
    
    def get_name(self):
        return self.name

    def get_date(self):
        return self.start_date_time.date()

    def get_start_time(self):
        return self.start_date_time.time()
    
    def get_end_time(self):
        return self.end_date_time.time()
    
    def get_start_datetime(self):
        return self.start_date_time
    
    def get_end_datetime(self):
        return self.end_date_time

    def get_location(self):
        return self.location
    
