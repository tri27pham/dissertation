from prioritiesEnum import Priority

class AllocatedTask:
    
    def __init__(self,taskID,name,start_datetime,end_datetime,priority,prior_tasks,location,category):
        # identifier unique to task - type: Int
        self.taskID = taskID 
        # task name
        self.name = name
        # time task begins
        self.start_datetime = start_datetime
        # time task ends
        self.end_datetime = end_datetime
        # priority level - type: Enum [ LOW, MEDIUM, HIGH ]
        self.priority = priority 
        # tasks that must be completed first - type: set of Task
        self.prior_tasks = prior_tasks 
        # <lat,long> of location of task - default = None
        self.location = location        
        # category of task - type: String - default = None
        self.category = category 

    def getID(self):
        return self.taskID
    
    def get_name(self):
        return self.name

    def get_start_time(self):
        return self.start_datetime.time()
    
    def get_end_time(self):
        return self.end_datetime.time()

    def get_start_datetime(self):
        return self.start_datetime

    def get_end_datetime(self):
        return self.end_datetime

    def get_priority(self):
        return self.priority
    
    def get_prior_tasks(self):
        return self.prior_tasks
    
    def get_location(self):
        return self.location
    
    def get_category(self):
        return self.category
