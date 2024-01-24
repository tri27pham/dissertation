# Task Class
# contains the information regarding each task to be allocated

from enums import Priority

class Task:

    def __init__(self,taskID,duration,priority,priorTasks=None,location=None,name,taskType=None,inOutDoor=None):
        self.taskID = taskID # identifier unique to task
        self.duration = duration # duration in hours
        self.priority = priority # priority level [ LOW, MEDIUM, HIGH ]
        self.priorTasks = priorTasks # list<Task> of tasks that must be completed first
        self.location = location # <lat,long> of location of task, can be locationless(None)
        self.name = name
        self.taskType = taskType # category of task, eg. uni, work, fitness, etc.
        self.inOutDoor = inOutDoor # whether a task is situated indoors/outdoors

    def getDuration:
        return self.duration

    def getPriority:
        return self.priority
    
    def getPriorTasks:
        return self.priorTasks
    
    def getLocation:
        return self.location
    
    def getName:
        return self.name
    
    def getTaskType:
        return self.taskType
    
    def getInOutDoor:
        return self.inOutDoor
    

