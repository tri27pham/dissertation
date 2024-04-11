# Task Class
# contains the information regarding each task to be allocated


from model.taskCategoryEnum import TaskCategory

class Task:

    def __init__(self,taskID,name,duration,priority,prior_tasks,location_name,location_coords,category):
        # identifier unique to task - type: Int
        self.taskID = taskID 
        # task name
        self.name = name
        # duration in hours - type: timedelta 
        self.duration = duration 
        # priority level - type: Enum [ LOW, MEDIUM, HIGH ]
        self.priority = priority
        # tasks that must be completed first - type: set of Task
        self.prior_tasks = prior_tasks 
        # <lat,long> of location of task - default = None
        self.location_name = location_name
        self.location_coords = location_coords     
        # category of task   
        match category:
            case 0:
                self.category = TaskCategory.UNIVERSITY
            case 1:
                self.category = TaskCategory.WORK
            case 2:
                self.category = TaskCategory.HEALTH
            case 3:
                self.category = TaskCategory.SOCIAL
            case 4:
                self.category = TaskCategory.FAMILY
            case 5:
                self.category = TaskCategory.HOBBIES
            case 6:
                self.category = TaskCategory.MISCELLANEOUS

    def getID(self):
        return self.taskID

    def get_duration(self):
        return self.duration

    def get_priority(self):
        return self.priority
    
    def get_prior_tasks(self):
        return self.prior_tasks

    def get_location_name(self):
        return self.location_name
    
    def get_location_coords(self):
        return self.location_coords
    
    def get_name(self):
        return self.name
    
    def get_category(self):
        return self.category