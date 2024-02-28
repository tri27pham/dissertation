# Task Allocator
# contains the logic of the task allocation model

from prioritiesEnum import Priority
from taskCategoryEnum import TaskCategory
from weekdayEnum import Weekday
from breakTypeEnum import BreakType
from task import Task
from datetime import datetime, timedelta, time
from userRequirements import UserRequirements
from allocatedTask import AllocatedTask
from collections import defaultdict
from hardTask import HardTask


import math
import random

import requests

import googlemaps

class TaskAllocator:

    def __init__(self):
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
        for i in range(1439):
            daily_schedule[current_time] = None
            dt_current_time = datetime.combine(datetime.today(),current_time)
            updated_time = dt_current_time + interval
            current_time = updated_time.time()

        return daily_schedule

    def knapsack_allocator(self,tasks_to_allocate,user_requirements):

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
                # print(current_task.getID())
                # travel_time = self.get_travel_time_free(task_dict[previous_task].get_location(),current_task.get_location())
                travel_time = self.travel_times_matrix[previous_task][current_task.getID()]

                # make a for loop that iterate for the time of travel time and set schedule[date][current_time]

                int_travel_time = int(travel_time.total_seconds() / 60)
                for i in range(int_travel_time):
                    schedule[date][current_time] = "travel"
                    current_time = self.incrementTime(current_time)

                # while schedule[date][current_time] != None:
                #     schedule[date][current_time] = "travel"
                #     current_time = self.incrementTime(current_time)
            
            if self.dt_to_td(current_time) + travel_time + current_task.get_duration() \
                <= self.dt_to_td(user_requirements.get_current_day_end(weekday)):
                # current time and travel time to get start time of task
                # current time and travel time and duration to get end time of task
                # update current time to end time
                
                task_start_time = datetime.combine(date, datetime.min.time()) + self.dt_to_td(current_time) + travel_time
                task_end_time = datetime.combine(date, datetime.min.time()) + self.dt_to_td(current_time) + travel_time + current_task.get_duration()

                new_allocated_task = AllocatedTask(current_task.getID(),current_task.get_name(),task_start_time,
                                        task_end_time,current_task.get_priority(),current_task.get_prior_tasks(),
                                        current_task.get_location(),current_task.get_category())

                task_dict[new_allocated_task.getID()] = new_allocated_task
                
                time = task_start_time.time()
                
                while time <= task_end_time.time():
                    # print(f"{time} : {task_end_time}")
                    schedule[date][time] = new_allocated_task.getID()
                    time = self.incrementTime(time)
                
                # print("exited")
                current_time = task_end_time.time()
            
                tasks_to_allocate.pop(0)

            else:
                if weekday == 6:
                    weekday = 0
                    current_time = user_requirements.get_current_day_start(weekday)
                else: 
                    weekday += 1
                    current_time = user_requirements.get_current_day_start(weekday)
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


        # # create HTTP request to Google Routes API
        # url = 'https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix'
        # headers = {
        #     'Content-Type': 'application/json',
        #     'X-Goog-Api-Key': 'AIzaSyBaLZBGSMsZppfhtF8lu0IGvJ7Wpfg5294',
        #     'X-Goog-FieldMask': 'originIndex,destinationIndex,duration'
        # }
        # data = {
        #     "origins": locations,
        #     "destinations": locations,
        #     "languageCode": "en-US",
        #     "units": "IMPERIAL"
        # }

        # # call request and store response
        # response = requests.post(url, json=data, headers=headers)
            
        # response_data = response.json()

        # print(response_data)

        response_data = [{'originIndex': 10, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 13, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 10, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 10, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 12, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 11, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 13, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 13, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 12, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 9, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 11, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 11, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 12, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 9, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 6, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 7, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 4, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 9, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 8, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 11, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 11, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 7, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 6, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 7, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 11, 'duration': '925s'}, {'originIndex': 4, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 6, 'destinationIndex': 1, 'duration': '863s'}, {'originIndex': 10, 'destinationIndex': 3, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 5, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 9, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 9, 'duration': '925s'}]

        # create a 2D array that has dimensions n x n, where n is the number of tasks
        len_sides = len(locations)
        travel_times_matrix = [[None] * len_sides for _ in range(len_sides)]
        
        # fetch the taskID from the index
        # assign the duration to the [x][y] of the matrix
        for i in range(len(response_data)):
            originTask = task_to_location[response_data[i]['originIndex']]
            destinationTask = task_to_location[response_data[i]['destinationIndex']]
            duration = int(response_data[i]['duration'][:-1])
            rounded_duration = math.ceil(duration / 300) * 5
            travel_times_matrix[int(originTask)][int(destinationTask)] = timedelta(minutes=rounded_duration)
        
        self.travel_times_matrix = travel_times_matrix

        # for row in travel_times_matrix:
        #     print(row[1:])
                

        # if response.status_code == 200 and response.json():
        #     print("Request successful.")
        #     print("Response:", response.json())
        #     # response_data = response.json()
        #     # time_seconds_string = response_data['routes'][0]['duration']
        #     # time_seconds_int = int(time_seconds_string[:-1])
        #     # minutes = time_seconds_int / 60
        #     # rounded_minutes =  math.ceil(minutes / 5) * 5
        #     # return timedelta(minutes=rounded_minutes)
        # else:
        #     print("Request failed with status code:", response.status_code)
        #     # return timedelta()


    # def get_travel_time_paid(self,source,destination):

    #     # print(type(time))

    #     if source == None or destination == None:
    #         return timedelta()

    #     url = 'https://routes.googleapis.com/directions/v2:computeRoutes'
    #     headers = {
    #         'Content-Type': 'application/json',
    #         'X-Goog-Api-Key': 'AIzaSyBaLZBGSMsZppfhtF8lu0IGvJ7Wpfg5294',
    #         'X-Goog-FieldMask': 'routes.duration'
    #     }
    #     data = {
    #         "origin": {
    #             "location": {
    #                 "latLng": {
    #                     "latitude": source[0],
    #                     "longitude": source[1]
    #                 }
    #             }
    #         },
    #         "destination": {
    #             "location": {
    #                 "latLng": {
    #                     "latitude": destination[0],
    #                     "longitude": destination[1]
    #                 }
    #             }
    #         },
    #         "travelMode": "TRANSIT",
    #         "languageCode": "en-US",
    #         "units": "IMPERIAL"
    #     }

    #     response = requests.post(url, json=data, headers=headers)

    #     if response.status_code == 200 and response.json():
    #         print("Request successful.")
    #         print("Response:", response.json())
    #         response_data = response.json()
    #         time_seconds_string = response_data['routes'][0]['duration']
    #         time_seconds_int = int(time_seconds_string[:-1])
    #         minutes = time_seconds_int / 60
    #         rounded_minutes =  math.ceil(minutes / 5) * 5
    #         return timedelta(minutes=rounded_minutes)
    #     else:
    #         # print("Request failed with status code:", response.status_code)
    #         return timedelta()

    def mins_to_datetime(self,mins):
        hours, minutes = divmod(mins, 60)
        return datetime(datetime.today().year, datetime.today().month, datetime.today().day, hours, minutes)

    def mins_to_string(self,mins):
        hours, minutes = divmod(mins, 60)
        return "{:02d}:{:02d}".format(hours, minutes)

    def incrementTime(self,time):
        new_time = datetime.combine(datetime.today(),time) + timedelta(minutes=1)
        return new_time.time()

    def dt_to_td(self,time):
        return timedelta(hours=time.hour,minutes=time.minute)

    def get_task_dict(self,taskId):
        return self.task_dict[taskId]

# hard tasks

dt1_startx = datetime.now() + timedelta(hours=2)
dt1_start = dt1_startx.replace(second=0, microsecond=0)
dt1_endx = datetime.now() + timedelta(hours=3)
dt1_end = dt1_endx.replace(second=0, microsecond=0)

dt2_startx = datetime.now() + timedelta(hours=20)
dt2_start = dt2_startx.replace(second=0, microsecond=0)
dt2_endx = datetime.now() + timedelta(hours=22)
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

hardTask1 = HardTask("h1","HardTask1",dt1_start,dt1_end)
hardTask2 = HardTask("h2","HardTask2",dt2_start,dt2_end)
hardTask3 = HardTask("h3","HardTask3",dt3_start,dt3_end)
hardTask4 = HardTask("h4","HardTask4",dt4_start,dt4_end)
hardTask5 = HardTask("h5","HardTask5",dt5_start,dt5_end)

hard_tasks = [hardTask1,hardTask2,hardTask3,hardTask4,hardTask4,hardTask5]

# tasks to allocate
task2 = Task(2,"OME Content",timedelta(hours=2,minutes=0),3,(),(51.513056,-0.117352),0)
task1 = Task(1,"NSE Content",timedelta(hours=2,minutes=0),3,(task2,),(51.503162, -0.086852),1)
task0 = Task(0,"ML1 Content",timedelta(hours=1,minutes=0),3,(task1,task2),(51.513056,-0.117352),0)
task3 = Task(3,"Push session",timedelta(hours=2,minutes=0),3,(),(51.503162, -0.086852),2)
task4 = Task(4,"Work",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),2)
task5 = Task(5,"Pull session",timedelta(hours=2,minutes=0),2,(),(51.503162, -0.086852),3)
task6 = Task(6,"10k",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),6)
task7 = Task(7,"Dissertation",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task8 = Task(8,"Work",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task9 = Task(9,"Push session",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),1)
task10 = Task(10,"Coursework",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),2)
task11 = Task(11,"Legs session",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task12 = Task(12,"Dissertation",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),5)
task13 = Task(13,"5k",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),6)
tasks_to_be_allocated = [task0,task1,task2,task3,task4,task5,task6,task7,task8,task9,task10,task11,task12,task13]

task_allocator = TaskAllocator()



nine_am = time(hour=9, minute=0, second=0)
five_pm = time(hour=18, minute=0, second=0)

user_requirements = UserRequirements(nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm)

breakType = BreakType.SHORT 

task_allocator.allocate_hard_tasks(hard_tasks)
sorted_tasks = task_allocator.topological_sort(tasks_to_be_allocated)
task_allocator.get_travel_times(sorted_tasks)
task_allocator.knapsack_allocator(sorted_tasks,user_requirements)

for k, v in task_allocator.schedule.items():
    for time, task in v.items():
        if task != None:
            if type(task) == HardTask:
                name = task.get_name()
            elif isinstance(task, str):
                name = task
            else:
                name = task_allocator.get_task_dict(task).get_name()
            print(f"{k} {time}: {name}")
        

