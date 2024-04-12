"""
This file contains the class definition for the AllocatedTask object. 
This object is used to represent a task that has been allocated to a user. 
"""
class AllocatedTask:
    
    def __init__(self,taskID,name,start_datetime,end_datetime,priority,prior_tasks,location_name,location_coords,category):

        """
        Constructor for the AllocatedTask object.

        Parameters:
        taskID: int - the unique ID of the task
        name: str - the name of the task
        start_datetime: datetime - the start time of the task
        end_datetime: datetime - the end time of the task
        priority: int - the priority of the task
        prior_tasks: list - the list of tasks that this task is dependent on
        location_name: str - the name of the location of the task
        location_coords: tuple - the coordinates of the location of the task
        category: Category - the category of the task        
        """
    
        self.taskID = taskID 
        self.name = name
        self.start_datetime = start_datetime
        self.end_datetime = end_datetime
        self.priority = priority 
        self.prior_tasks = prior_tasks 
        self.location_name = location_name
        self.location_coords = location_coords       
        self.category = category 

    def getID(self):
        """"
        Returns the ID of the task.
        """
        return self.taskID
    
    def get_name(self):
        """
        Returns the name of the task.
        """
        return self.name

    def get_start_time(self):
        """
        Returns the start time of the task.
        """
        return self.start_datetime.time()
    
    def get_end_time(self):
        """
        Returns the end time of the task.
        """
        return self.end_datetime.time()

    def get_start_datetime(self):
        """
        Returns the start datetime of the task.
        """
        return self.start_datetime

    def get_end_datetime(self):
        """
        Returns the end datetime of the task.
        """
        return self.end_datetime
    
    def get_start_datetime_as_weekday(self):
        """
        Returns the weekday of the start datetime of the task.
        """
        return self.start_datetime.weekday()
    
    def get_end_datetime_as_weekday(self):
        """
        Returns the weekday of the end datetime of the task.
        """
        return self.end_datetime.weekday()

    def get_priority(self):
        """
        Returns the priority of the task.   
        """
        return self.priority
    
    def get_prior_tasks(self):
        """
        Returns the list of tasks that this task is dependent on.
        """
        return self.prior_tasks
    
    def get_location_name(self):
        """
        Returns the name of the location of the task.
        """
        return self.location_name
    
    def get_location_coords(self):
        """
        Returns the coordinates of the location of the task.
        """
        return self.location_coords
    
    def get_category(self):
        """
        Returns the category of the task.
        """
        return self.category
    
    def get_category_val(self):
        """
        Returns the value of the category of the task.
        """
        return self.category.value
