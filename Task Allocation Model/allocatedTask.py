class AllocatedTask:
    
    def __init__(self,taskID,name,startTime,endTime,priority,priorTasks,location,category):
        # identifier unique to task - type: Int
        self.taskID = taskID 
        # task name
        self.name = name
        # time task begins
        self.startTime = startTime
        # time task ends
        self.endTime = endTime
        # priority level - type: Enum [ LOW, MEDIUM, HIGH ]
        self.priority = priority 
        # tasks that must be completed first - type: set of Task
        self.priorTasks = priorTasks 
        # <lat,long> of location of task - default = None
        self.location = location        
        # category of task - type: String - default = None
        self.category = category 

    def getID(self):
        return self.taskID
    
    def getName(self):
        return self.name

    def getStartTime(self):
        return self.startTime

    def getEndTime(self):
        return self.endTime

    def getPriority(self):
        return self.priority
    
    def getPriorTasks(self):
        return self.priorTasks
    
    def getLocation(self):
        return self.location
    
    def getCategory(self):
        return self.taskType
