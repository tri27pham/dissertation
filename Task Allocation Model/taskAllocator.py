# Task Allocator
# contains the logic of the task allocation model

from prioritiesEnum import Priority
from taskCategoryEnum import TaskCategory
from weekdayEnum import Weekday
from breakTypeEnum import BreakType
from task import Task
from datetime import datetime, timedelta, time
from userRequirements import UserRequirements
from userPreferences import UserPreferences
from allocatedTask import AllocatedTask
from collections import defaultdict
from hardTask import HardTask
from geneticAlgorithm import GeneticAlgorithm


import math
import random

import requests

import googlemaps

class TaskAllocator:

    def __init__(self,user_requirements):
        self.user_requirements = user_requirements
        self.schedule = {}
        self.task_dict = {}

    def topological_sort(self, tasks):
        result = []  # To store the topological order
        visited = set()  # To keep track of visited tasks during DFS
        stack = []  # To keep track of tasks in the order they are finished
        
        def dfs(task):
            nonlocal visited
            visited.add(task)

            for prior_task in task.get_prior_tasks():
                if prior_task not in visited:
                    dfs(prior_task)

            stack.append(task)

        # Sort tasks by priority: HIGH, MEDIUM, LOW
        tasks.sort(key=lambda x: x.get_priority(), reverse=True)

        for task in tasks:
            if task not in visited:
                dfs(task)

        return stack

    def populate_schedule(self,tasks,interval):

        dates = [task.get_date() for task in tasks]
        first_date = min(dates)
        last_date = max(dates)

        current_date = first_date
       
        while current_date <= last_date:
            self.schedule[current_date] = self.create_new_daily_schedule(interval)
            current_date += timedelta(days=1)

    def allocate_hard_tasks(self,tasks):

        interval = timedelta(minutes=1)

        self.populate_schedule(tasks,interval)

        for task in tasks:
            date = task.get_date()
            start_time = task.get_start_time()
            end_time = task.get_end_time()
            # assign task to the time slots that it occupies
            current_time = start_time
            while current_time <= end_time:
                self.task_dict[task.getID()] = task
                self.schedule[date][current_time] = task.getID()
                dt_current_time = datetime.combine(datetime.today(),current_time)
                updated_time = dt_current_time + interval
                current_time = updated_time.time()

    def create_new_daily_schedule(self,interval=timedelta(minutes=1)):

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

        schedule = self.schedule
        task_dict = self.task_dict

        date = datetime.now().date()
        weekday = datetime.now().weekday()

        current_time = datetime.now().time()
        minutes_until_next_hour = (60 - current_time.minute) % 60
        next_hour_delta = timedelta(minutes=minutes_until_next_hour)
        dt_current_time = (datetime.combine(datetime.today(), current_time) + next_hour_delta).time()
        current_time = dt_current_time.replace(second=0, microsecond=0)

        while len(tasks_to_allocate) != 0:

            if date not in schedule:
                
                schedule[date] = self.create_new_daily_schedule()

            current_task = tasks_to_allocate[0]
            
            # if there is no task allocated in this timeslot, travel time is 0
            if schedule[date][current_time] == None:
                travel_time = timedelta()
            # there is a task allocated at this time slot, so travel time to be calculated
            else:
                previous_task = schedule[date][current_time]
                travel_time = self.travel_times_matrix[previous_task][current_task.getID()]

            needed_time = travel_time + current_task.get_duration()

            available_time_slot = self.get_available_time_slot(date,weekday,self.increment_time(current_time))

            if travel_time + current_task.get_duration() <= available_time_slot:

            # if self.dt_to_td(current_time) + travel_time + current_task.get_duration() \
            #     <= self.dt_to_td(self.user_requirements.get_current_day_end(weekday)):
                # current time and travel time to get start time of task
                # current time and travel time and duration to get end time of task
                # update current time to end time
                task_start_time = datetime.combine(date, datetime.min.time()) + self.dt_to_td(current_time) + travel_time
                task_end_time = datetime.combine(date, datetime.min.time()) + self.dt_to_td(current_time) + travel_time + current_task.get_duration()

                new_allocated_task = AllocatedTask(current_task.getID(),current_task.get_name(),task_start_time,
                                        task_end_time,current_task.get_priority(),current_task.get_prior_tasks(),
                                        current_task.get_location(),current_task.get_category())

                task_dict[new_allocated_task.getID()] = new_allocated_task
                
                # make a for loop that iterate for the time of travel time and set schedule[date][current_time]
                current_time = self.increment_time(current_time)
                int_travel_time = int(travel_time.total_seconds() / 60)
                for i in range(int_travel_time):
                    schedule[date][current_time] = "travel"
                    current_time = self.increment_time(current_time)

                time = task_start_time.time()

                while time <= task_end_time.time():
                    schedule[date][time] = new_allocated_task.getID()
                    time = self.increment_time(time)

                current_time = task_end_time.time()
            
                tasks_to_allocate.pop(0)

            else:
                if weekday == 6:
                    weekday = 0
                    current_time = self.user_requirements.get_current_day_start(weekday)
                else: 
                    weekday += 1
                    current_time = self.user_requirements.get_current_day_start(weekday)
                date = date + timedelta(days=1)

        self.schedule = schedule
        self.task_dict = task_dict

    def get_travel_time_free(self,source,destination):
        random_num = random.randint(0, 6)
        random_mult_5 = random_num * 5
        return timedelta(minutes=random_mult_5)

    def get_travel_times(self,tasks):


        # list of all locations of tasks
        locations = []

        # maps index of task in locations array to taskID
        task_to_location = defaultdict(int)

        idx = 0

        # create location waypoint for each location and add into locations array
        for task in tasks:

            if task.get_location() is not None:

                location = {
                    "waypoint": {
                        "location": {
                            "latLng": {
                                "latitude": task.get_location()[0],
                                "longitude": task.get_location()[1]
                            }
                        }
                    }
                }

                task_to_location[idx] = task.getID()
                locations.append(location)
                idx += 1
        
        # create HTTP request to Google Routes API
        url = 'https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix'
        headers = {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': 'AIzaSyBaLZBGSMsZppfhtF8lu0IGvJ7Wpfg5294',
            'X-Goog-FieldMask': 'originIndex,destinationIndex,duration'
        }
        data = {
            "origins": locations,
            "destinations": locations,
            "languageCode": "en-US",
            "units": "IMPERIAL"
        }

        # call request and store response
        # response = requests.post(url, json=data, headers=headers)
            
        # response_data = response.json()

        response_data = [{'originIndex': 19, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 19, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 10, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 9, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 9, 'destinationIndex': 1, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 15, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 19, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 14, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 11, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 4, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 14, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 4, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 5, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 5, 'duration': '925s'}, {'originIndex': 4, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 18, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 4, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 14, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 17, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 15, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 13, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 4, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 15, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 18, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 17, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 3, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 3, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 16, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 14, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 1, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 14, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 17, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 17, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 15, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 18, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 18, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 15, 'duration': '925s'}, {'originIndex': 12, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 3, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 14, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 17, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 4, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 18, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 11, 'destinationIndex': 19, 'duration': '925s'}, {'originIndex': 13, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 16, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 1, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 15, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 19, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 5, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 19, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 15, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 3, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 5, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 18, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 12, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 16, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 16, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 1, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 17, 'destinationIndex': 7, 'duration': '863s'}]

        # print(response_data)

        # create a 2D array that has dimensions n x n, where n is the number of tasks
        len_sides = len(locations)
        travel_times_matrix = [[None] * len_sides for _ in range(len_sides)]

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

    def mins_to_datetime(self,mins):
        hours, minutes = divmod(mins, 60)
        return datetime(datetime.today().year, datetime.today().month, datetime.today().day, hours, minutes)

    def mins_to_string(self,mins):
        hours, minutes = divmod(mins, 60)
        return "{:02d}:{:02d}".format(hours, minutes)

    def increment_time(self,time):
        new_time = datetime.combine(datetime.today(),time) + timedelta(minutes=1)
        return new_time.time()

    def decrement_time(self,time):
        new_time = datetime.combine(datetime.today(),time) - timedelta(minutes=1)
        return new_time.time()

    def dt_to_td(self,time):
        return timedelta(hours=time.hour,minutes=time.minute)

    def get_task_dict(self,taskId):
        return self.task_dict[taskId]

    def get_available_time_slot(self,date,weekday,time):

        total_time_available = timedelta()

        daily_schedule = self.schedule[date]
        end_of_day = self.user_requirements.get_current_day_end(weekday)

        while daily_schedule[time] == None and time <= end_of_day:
            total_time_available += timedelta(minutes=1)
            time = self.increment_time(time)

        return total_time_available

    def get_allocated_tasks(self):
        
        all_tasks = set()
        for daily_schedule in self.schedule.values():
            for time_slot in daily_schedule.values():
                if time_slot is not None:
                    all_tasks.add(time_slot)

        allocated_tasks_refs = [task for task in all_tasks if task.startswith('s')]
        allocated_tasks = []

        for task_ref in allocated_tasks_refs:
            task = self.get_task_dict(task_ref)
            allocated_tasks.append(task)
            
        return allocated_tasks

    def display_all_tasks(self):

        all_tasks = set()
        for daily_schedule in self.schedule.values():
            for time_slot in daily_schedule.values():
                if time_slot is not None:
                    all_tasks.add(time_slot)

        allocated_tasks_refs = [task for task in all_tasks if task != "travel"]
        
        for task_ref in allocated_tasks_refs:
            task = self.task_dict[task_ref]
            print(f"NAME: {task.get_name()}, TIME: {task.get_start_datetime()} - {task.get_end_datetime()}")
              

# hard tasks
dt1_startx = datetime.now() + timedelta(hours=1)
dt1_start = dt1_startx.replace(second=0, microsecond=0)
dt1_endx = datetime.now() + timedelta(hours=2)
dt1_end = dt1_endx.replace(second=0, microsecond=0)

dt2_startx = datetime.now() + timedelta(hours=18)
dt2_start = dt2_startx.replace(second=0, microsecond=0)
dt2_endx = datetime.now() + timedelta(hours=20)
dt2_end = dt2_endx.replace(second=0, microsecond=0)

dt3_startx = datetime.now() + timedelta(hours=24)
dt3_start = dt3_startx.replace(second=0, microsecond=0)
dt3_endx = datetime.now() + timedelta(hours=25)
dt3_end = dt3_endx.replace(second=0, microsecond=0)

dt4_startx = datetime.now() + timedelta(days=2)
dt4_start = dt4_startx.replace(second=0, microsecond=0)
dt4_endx = datetime.now() + timedelta(days=2,hours=1)
dt4_end = dt4_endx.replace(second=0, microsecond=0)

dt5_startx = datetime.now() + timedelta(days=2, hours=2)
dt5_start = dt5_startx.replace(second=0, microsecond=0)
dt5_endx = datetime.now() + timedelta(days=2, hours=4)
dt5_end = dt5_endx.replace(second=0, microsecond=0)

hardTask1 = HardTask("h1","HardTask1",dt1_start,dt1_end,(51.513056,-0.117352))
hardTask2 = HardTask("h2","HardTask2",dt2_start,dt2_end,(51.513056,-0.117352))
hardTask3 = HardTask("h3","HardTask3",dt3_start,dt3_end,(51.513056,-0.117352))
hardTask4 = HardTask("h4","HardTask4",dt4_start,dt4_end,(51.513056,-0.117352))
hardTask5 = HardTask("h5","HardTask5",dt5_start,dt5_end,(51.513056,-0.117352))

hard_tasks = [hardTask1,hardTask2,hardTask3,hardTask4,hardTask4,hardTask5]

# tasks to allocate
task2 = Task("s2","OME Content",timedelta(hours=2,minutes=0),3,(),(51.513056,-0.117352),0)
task1 = Task("s1","NSE Content",timedelta(hours=1,minutes=0),3,(task2,),(51.503162, -0.086852),1)
task0 = Task("s0","ML1 Content",timedelta(hours=1,minutes=0),3,(task1,task2),(51.513056,-0.117352),0)
task3 = Task("s3","Push session",timedelta(hours=2,minutes=0),3,(),(51.503162, -0.086852),2)
task4 = Task("s4","Work",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),2)
task5 = Task("s5","Pull session",timedelta(hours=2,minutes=0),2,(),(51.503162, -0.086852),3)
task6 = Task("s6","10k",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),6)
task7 = Task("s7","Dissertation",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task8 = Task("s8","Work",timedelta(hours=2,minutes=0),2,(),(51.503162,-0.086852),0)
task9 = Task("s9","Push session",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),1)
task10 = Task("s10","Coursework",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),2)
task11 = Task("s11","Legs session",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task12 = Task("s12","Dissertation",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),5)
task13 = Task("s13","5k",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),6)
tasks_to_be_allocated = [task3,task4,task5,task6,task7,task8,task9,task10,task11,task12,task13,task0,task1,task2]


nine_am = time(hour=9, minute=0, second=0)
five_pm = time(hour=18, minute=0, second=0)

user_requirements = UserRequirements(nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm)

task_allocator = TaskAllocator(user_requirements)

breakType = BreakType.SHORT 

all_tasks = hard_tasks + tasks_to_be_allocated
task_allocator.get_travel_times(all_tasks)

task_allocator.allocate_hard_tasks(hard_tasks)
sorted_tasks = task_allocator.topological_sort(tasks_to_be_allocated)

task_allocator.knapsack_allocator(sorted_tasks)
allocated_tasks = task_allocator.get_allocated_tasks()

# task_allocator.display_all_tasks()

user_preferences = UserPreferences()
# print(f"POINTS: {user_preferences.get_preferences_satisfied(allocated_tasks)}")

ga = GeneticAlgorithm(tasks_to_be_allocated,10)
ga.create_first_generation()


# for k, v in task_allocator.schedule.items():
#     for time, task in v.items():
#         if task != None:
#             if type(task) == HardTask:
#                 name = task.get_name()
#             elif isinstance(task, str):
#                 name = task
#             else:
#                 name = task_allocator.get_task_dict(task).get_name()
#             print(f"{k} {time}: {name}")
#         else:
#              print(f"{k} {time}: empty")
        