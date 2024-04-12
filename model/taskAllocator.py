"""
This module contains the TaskAllocator class, which is responsible for allocating tasks to time slots in the user's schedule.
"""

from datetime import datetime, timedelta, time
from allocatedTask import AllocatedTask
from collections import defaultdict

import math
import copy
import requests

class TaskAllocator:

    def __init__(self,user_requirements,tasks):
        """
        The constructor for the TaskAllocator class.
        Parameters:
        user_requirements: UserRequirements - the user requirements object
        tasks: list - the list of tasks to be allocated
        """
        self.user_requirements = user_requirements
        self.schedule = {}
        self.task_dict = {}
        for task in tasks:
            self.task_dict[task.getID()] = task
        self.get_travel_times(tasks)

    def populate_schedule(self,tasks,interval):
        """
        This method is used to populate the schedule dictionary with daily schedules 
        for each day between the first and last task dates.
        Parameters:
        tasks: list - the list of tasks to be allocated
        interval: timedelta - the time interval to use for the daily schedule
        """

        dates = [task.get_date() for task in tasks]
        first_date = min(dates)
        last_date = max(dates)

        current_date = first_date
       
        while current_date <= last_date:
            self.schedule[current_date] = self.create_new_daily_schedule(interval)
            current_date += timedelta(days=1)

    def create_new_daily_schedule(self,interval=timedelta(minutes=1)):
        """
        This method is used to create a new daily schedule with time slots for each minute of the day.
        Parameters:
        interval: timedelta - the time interval to use for the daily schedule
        Returns:
        dict - the new daily schedule
        """

        start_time = time(0, 0)  
        end_time = time(23, 59)  

        daily_schedule = {}

        current_time = start_time
        for i in range(1440):
            daily_schedule[current_time] = None
            dt_current_time = datetime.combine(datetime.today(),current_time)
            updated_time = dt_current_time + interval
            current_time = updated_time.time()

        return daily_schedule

    def knapsack_allocator(self,tasks_to_allocate):
        """
        This method is used to allocate tasks to time slots in the user's schedule using a knapsack algorithm.
        Parameters:
        tasks_to_allocate: list - the list of tasks to be allocated
        Returns:
        list - the list of allocated tasks
        """
        # Create a copy of the schedule dictionary
        schedule = copy.copy(self.schedule)

        date = datetime.now().date()
        weekday = datetime.now().weekday()
        
        # Get the current time and round it up to the next hour
        current_time = datetime.now().time()
        minutes_until_next_hour = (60 - current_time.minute) % 60
        next_hour_delta = timedelta(minutes=minutes_until_next_hour)
        dt_current_time = (datetime.combine(datetime.today(), current_time) + next_hour_delta).time()
        current_time = dt_current_time.replace(second=0, microsecond=0)

        # iterate through the tasks to allocate
        while len(tasks_to_allocate) != 0:

            # create a new daily schedule if the current date is not in the schedule
            if date not in schedule:
                
                schedule[date] = self.create_new_daily_schedule()

            current_task = tasks_to_allocate[0]

            # if the current time is before the start of the current day, set the current time to 
                # the start of the current day
            if current_time < self.user_requirements.get_current_day_start(weekday):
                current_time = self.user_requirements.get_current_day_start(weekday)
            
            # if there is no task allocated in this timeslot, travel time is 0
            if schedule[date][current_time] == None:
                travel_time = timedelta()
            # if there is a task allocated at this time slot, travel time needs to be calculated
            else:
                previous_task = schedule[date][current_time]
                # if the previous task is in the travel times matrix, get the travel time
                if previous_task in self.travel_times_matrix:
                    travel_time = self.travel_times_matrix[previous_task][current_task.getID()]
                else:
                    travel_time = timedelta()

            # get the available time slot for the current task
            available_time_slot = self.get_available_time_slot(schedule,date,weekday,self.increment_time(current_time))
            
            # if the travel time plus the duration of the current task fits in the available time slot
            if travel_time + current_task.get_duration() <= available_time_slot:
                # get the start and end time of the current task
                task_start_time = datetime.combine(date, datetime.min.time()) + self.dt_to_td(current_time) + travel_time
                task_end_time = datetime.combine(date, datetime.min.time()) + self.dt_to_td(current_time) + travel_time + current_task.get_duration()

                # create a new allocated task object and add it to the task dictionary
                new_allocated_task = AllocatedTask(current_task.getID(),current_task.get_name(),task_start_time,
                                        task_end_time,current_task.get_priority(),current_task.get_prior_tasks(),
                                        current_task.get_location_name(),current_task.get_location_coords(),current_task.get_category())

                self.task_dict[new_allocated_task.getID()] = new_allocated_task
                
                # update the schedule with the allocated task and travel time
                current_time = self.increment_time(current_time)
                int_travel_time = int(travel_time.total_seconds() / 60)
                for i in range(int_travel_time):
                    schedule[date][current_time] = "travel"
                    current_time = self.increment_time(current_time)

                # updte time
                time = task_start_time.time()
                while time <= task_end_time.time():
                    schedule[date][time] = new_allocated_task.getID()
                    time = self.increment_time(time)

                current_time = task_end_time.time()

                # remove task that was just allocated from tasks_to_allocate
                tasks_to_allocate.pop(0)
            # if the travel time plus the duration of the current task does not fit in the available time slot
            else:
                # if the current day is Sunday, move to the Monday 
                if weekday == 6:
                    weekday = 0
                    current_time = self.user_requirements.get_current_day_start(weekday)
                # else move to the next day
                else: 
                    weekday += 1
                    current_time = self.user_requirements.get_current_day_start(weekday)
                # increment the date
                date = date + timedelta(days=1)

        allocated_tasks = self.get_allocated_tasks(schedule)

        return allocated_tasks

    def get_travel_times(self,tasks):
        """
        This method is used to get the travel times between locations of tasks using the Google Routes API.
        Parameters:
        tasks: list - the list of tasks to be allocated
        """

        # list of all locations of tasks
        locations = []

        # maps index of task in locations array to taskID
        task_to_location = defaultdict(int)

        idx = 0

        # create location waypoint for each location and add into locations array
        for task in tasks:

            if task.get_location_coords() is not None:

                location = {
                    "waypoint": {
                        "location": {
                            "latLng": {
                                "latitude": task.get_location_coords()[0],
                                "longitude": task.get_location_coords()[1]
                            }
                        }
                    }
                }

                task_to_location[idx] = task.getID()
                locations.append(location)
                idx += 1


        # try to make HTTP request to Google Routes API
        try:
            url = 'https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix'
            headers = {
                'Content-Type': 'application/json',
                'X-Goog-Api-Key': 'API-KEY',
                'X-Goog-FieldMask': 'originIndex,destinationIndex,duration'
            }
            data = {
                "origins": locations,
                "destinations": locations,
                "languageCode": "en-US",
                "units": "IMPERIAL"
            }


            # call request and store response
            response = requests.post(url, json=data, headers=headers)
            
            # get response data
            response_data = response.json()

            travel_time_dict = {}
            for i in range(len(response_data)):
                origin = task_to_location[response_data[i]['originIndex']]
                destination = task_to_location[response_data[i]['destinationIndex']]
                duration = int(response_data[i]['duration'][:-1])
                rounded_duration = math.ceil(duration / 300) * 5
                if origin not in travel_time_dict:
                    travel_time_dict[origin] = {}
                
                # Initialize destination key if it doesn't exist
                if destination not in travel_time_dict[origin]:
                    travel_time_dict[origin][destination] = timedelta(minutes=rounded_duration)
                else:
                    travel_time_dict[origin][destination] += timedelta(minutes=rounded_duration)
            
                self.travel_times_matrix = travel_time_dict
        # if there is an exception, set all travel times to 0
        except Exception as e:
            self.travel_times_matrix = self.generate_index_combinations(len(locations))

        
    def generate_index_combinations(self,max_value):
        """
        Generates a list of dictionaries with every possible combination of index pairs from 1 to max_value,
        and assigns a default duration to each.
        Parameters:
        max_value: int - the maximum value for the index pairs
        Returns:
        list - the list of dictionaries with index pairs and default duration of 0
        """
        response_data = []

        # Generate every combination of index pairs
        for origin in range(1, max_value + 1):
            for destination in range(1, max_value + 1):
                response_data.append({
                    'originIndex': origin,
                    'destinationIndex': destination,
                    'duration': '0'
                })

        return response_data

    def mins_to_datetime(self,mins):
        """
        Converts minutes to a datetime object.
        Returns:
        datetime - the datetime object
        """
        hours, minutes = divmod(mins, 60)
        return datetime(datetime.today().year, datetime.today().month, datetime.today().day, hours, minutes)

    def mins_to_string(self,mins):
        """
        Converts minutes to a string in the format HH:MM.
        Returns:
        str - the string representation of the time
        """
        hours, minutes = divmod(mins, 60)
        return "{:02d}:{:02d}".format(hours, minutes)

    def increment_time(self,time):
        """
        Increments the time by one minute.
        Parameters:
        time: time - the time to increment
        Returns:
        time - the incremented time
        """
        new_time = datetime.combine(datetime.today(),time) + timedelta(minutes=1)
        return new_time.time()

    def decrement_time(self,time):
        """
        Decrements the time by one minute.
        Parameters:
        time: time - the time to decrement
        Returns:
        time - the decremented time
        """
        new_time = datetime.combine(datetime.today(),time) - timedelta(minutes=1)
        return new_time.time()

    def dt_to_td(self,time):
        """
        Converts a datetime object to a timedelta object.
        Parameters:
        time: datetime - the datetime object to convert        
        Returns:
        timedelta - the timedelta object
        """
        return timedelta(hours=time.hour,minutes=time.minute)

    def get_task_dict(self,taskId):
        """
        Returns the task object from the task dictionary.
        Parameters:
        taskId: int - the ID of the task
        Returns:
        Task - the task object
        """
        return self.task_dict[taskId]

    def get_available_time_slot(self,schedule,date,weekday,time):
        """
        This method is used to get the total time available in a day starting from a given time.
        Parameters:
        schedule: dict - the schedule dictionary
        date: datetime - the date of the schedule
        weekday: int - the weekday of the schedule
        time: time - the time to start from
        Returns:
        timedelta - the total time available
        """
        total_time_available = timedelta()

        daily_schedule = schedule[date]
        end_of_day = self.user_requirements.get_current_day_end(weekday)

        while daily_schedule[time] == None and time <= end_of_day:
            total_time_available += timedelta(minutes=1)
            time = self.increment_time(time)


        return total_time_available

    def get_allocated_tasks(self,schedule):
        """	
        This method is used to get the allocated tasks from the schedule dictionary.
        Parameters:
        schedule: dict - the schedule dictionary
        Returns:
        list - the list of allocated tasks
        """
        all_tasks = []
        for daily_schedule in schedule.values():
            for time_slot in daily_schedule.values():
                if time_slot is not None and time_slot not in all_tasks:
                    all_tasks.append(time_slot)

        allocated_tasks_refs = [task for task in all_tasks if task != "travel"]
        allocated_tasks = []

        for task_ref in allocated_tasks_refs:
            task = self.get_task_dict(task_ref)
            allocated_tasks.append(task)
            
        return allocated_tasks

