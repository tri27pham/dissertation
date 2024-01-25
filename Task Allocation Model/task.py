# Task Class
# contains the information regarding each task to be allocated

from prioritiesEnum import Priority

class Task:

    def __init__(self,taskID,name,duration,priority,priorTasks=None,location=None,taskType=None,inOutDoor=None):
        self.taskID = taskID # identifier unique to task
        self.name = name
        self.duration = duration # duration in hours
        self.priority = priority # priority level [ LOW, MEDIUM, HIGH ]
        self.priorTasks = priorTasks # list<Task> of tasks that must be completed first
        self.location = location # <lat,long> of location of task, can be locationless(None)       
        self.taskType = taskType # category of task, eg. uni, work, fitness, etc.
        self.inOutDoor = inOutDoor # whether a task is situated indoors/outdoors

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
    

