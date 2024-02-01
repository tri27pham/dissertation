# Task Class
# contains the information regarding each task to be allocated

from prioritiesEnum import Priority

class Task:

    def __init__(self,taskID,name,duration,priority,priorTasks=None,location=None,taskType=None,inOutDoor=0):
        # identifier unique to task - tyoe: Int
        self.taskID = taskID 
        # task name
        self.name = name
        # duration in hours - type: String 
        self.duration = duration 
        # priority level - type: Enum [ LOW, MEDIUM, HIGH ]
        self.priority = priority 
        # tasks that must be completed first - type: set of Task
        self.priorTasks = set() 
        # <lat,long> of location of task - default = None
        self.location = location        
        # category of task - type: String - default = None
        self.taskType = taskType 
        # whether a task is situated indoors/outdoors - type: Enum [ IN, OUT]
        self.inOutDoor = inOutDoor 

    def getID(self):
        return self.taskID

    def getDuration(self):
        return self.duration

    def getPriority(self):
        return self.priority
    
    def getPriorTasks(self):
        return self.priorTasks
    
    def getLocation(self):
        return self.location
    
    def getName(self):
        return self.name
    
    def getTaskType(self):
        return self.taskType
    
    def getInOutDoor(self):
        return self.inOutDoor
    

