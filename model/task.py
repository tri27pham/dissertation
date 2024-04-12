"""
This file contains the class definition for the Task object. 
This object is used to represent a task that needs to be allocated.
"""
from taskCategoryEnum import TaskCategory

class Task:

    def __init__(self,taskID,name,duration,priority,prior_tasks,location_name,location_coords,category):
        """
        Constructor for the Task object.
        Parameters:
        taskID: int - the unique ID of the task
        name: str - the name of the task
        duration: timedelta - the duration of the task
        priority: int - the priority of the task
        prior_tasks: list - the list of tasks that this task is dependent on
        location_name: str - the name of the location of the task
        location_coords: tuple - the coordinates of the location of the task
        category: int - the category of the task
        """
        self.taskID = taskID 
        self.name = name
        self.duration = duration 
        self.priority = priority
        self.prior_tasks = prior_tasks 
        self.location_name = location_name
        self.location_coords = location_coords      
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