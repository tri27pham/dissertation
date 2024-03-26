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
# from geneticAlgorithm import GeneticAlgorithm


import math
import random
import copy

import requests

import googlemaps

class TaskAllocator:

    def __init__(self,user_requirements,tasks):
        self.user_requirements = user_requirements
        self.schedule = {}
        self.task_dict = {}
        for task in tasks:
            self.task_dict[task.getID()] = task

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

        schedule = copy.copy(self.schedule)

        date = datetime.now().date()
        weekday = datetime.now().weekday()

        current_time = datetime.now().time()
        minutes_until_next_hour = (60 - current_time.minute) % 60
        next_hour_delta = timedelta(minutes=minutes_until_next_hour)
        dt_current_time = (datetime.combine(datetime.today(), current_time) + next_hour_delta).time()
        current_time = dt_current_time.replace(second=0, microsecond=0)

        while len(tasks_to_allocate) != 0:

            # print(tasks_to_allocate[0].getID())

            if date not in schedule:
                
                schedule[date] = self.create_new_daily_schedule()

            current_task = tasks_to_allocate[0]
            
            # if there is no task allocated in this timeslot, travel time is 0
            if schedule[date][current_time] == None:
                travel_time = timedelta()
            # there is a task allocated at this time slot, so travel time to be calculated
            else:
                previous_task = schedule[date][current_time]
                if previous_task in self.travel_times_matrix:
                    travel_time = self.travel_times_matrix[previous_task][current_task.getID()]
                else:
                    travel_time = timedelta()

            needed_time = travel_time + current_task.get_duration()

            available_time_slot = self.get_available_time_slot(schedule,date,weekday,self.increment_time(current_time))

            if travel_time + current_task.get_duration() <= available_time_slot:
                # current time and travel time to get start time of task
                # current time and travel time and duration to get end time of task
                # update current time to end time
                task_start_time = datetime.combine(date, datetime.min.time()) + self.dt_to_td(current_time) + travel_time
                task_end_time = datetime.combine(date, datetime.min.time()) + self.dt_to_td(current_time) + travel_time + current_task.get_duration()

                new_allocated_task = AllocatedTask(current_task.getID(),current_task.get_name(),task_start_time,
                                        task_end_time,current_task.get_priority(),current_task.get_prior_tasks(),
                                        current_task.get_location_name(),current_task.get_location_coords(),current_task.get_category())

                self.task_dict[new_allocated_task.getID()] = new_allocated_task
                
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

        allocated_tasks = self.get_allocated_tasks(schedule)

        # sorted_tasks = sorted(allocated_tasks, key=lambda task: task.get_start_datetime())
        # sorted_tasks_IDs = [task.getID() for task in sorted_tasks]
        # print(f"allocated: {sorted_tasks_IDs}")

        # all_task_IDs = []
        # for daily_schedule in schedule.values():
        #     for time_slot in daily_schedule.values():
        #         if time_slot is not None and time_slot not in all_task_IDs and time_slot != "travel":
        #             all_task_IDs.append(time_slot)
        # all_tasks = [self.task_dict[task_ID] for task_ID in all_task_IDs]
        # sorted_tasks = sorted(all_tasks, key=lambda task: task.get_start_datetime())
        # sorted_task_IDs = [task.getID() for task in sorted_tasks]
        # print(f"allocated: {sorted_task_IDs}")

        return allocated_tasks


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

        print(locations)

        # call request and store response
        # response = requests.post(url, json=data, headers=headers)
            
        # response_data = response.json()

        response_data = [{'originIndex': 19, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 19, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 10, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 8, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 19, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 9, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 18, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 6, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 9, 'destinationIndex': 1, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 15, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 19, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 14, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 11, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 5, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 17, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 5, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 4, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 14, 'destinationIndex': 11, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 4, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 5, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 5, 'duration': '925s'}, {'originIndex': 4, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 18, 'duration': '925s'}, {'originIndex': 3, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 4, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 4, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 12, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 14, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 17, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 3, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 15, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 13, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 3, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 4, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 15, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 18, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 17, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 3, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 3, 'duration': '925s'}, {'originIndex': 2, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 13, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 16, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 16, 'duration': '925s'}, {'originIndex': 5, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 2, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 14, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 1, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 14, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 17, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 17, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 15, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 18, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 2, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 2, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 18, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 15, 'duration': '925s'}, {'originIndex': 12, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 0, 'duration': '0s'}, {'originIndex': 15, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 1, 'destinationIndex': 1, 'duration': '0s'}, {'originIndex': 14, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 19, 'duration': '0s'}, {'originIndex': 6, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 15, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 18, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 16, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 13, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 3, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 17, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 12, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 8, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 14, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 6, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 17, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 4, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 18, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 11, 'destinationIndex': 19, 'duration': '925s'}, {'originIndex': 13, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 10, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 16, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 1, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 15, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 1, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 0, 'destinationIndex': 5, 'duration': '0s'}, {'originIndex': 10, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 19, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 5, 'duration': '925s'}, {'originIndex': 0, 'destinationIndex': 4, 'duration': '0s'}, {'originIndex': 0, 'destinationIndex': 3, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 0, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 19, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 11, 'destinationIndex': 15, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 3, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 5, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 7, 'duration': '0s'}, {'originIndex': 9, 'destinationIndex': 18, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 10, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 9, 'duration': '0s'}, {'originIndex': 7, 'destinationIndex': 2, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 6, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 14, 'duration': '863s'}, {'originIndex': 12, 'destinationIndex': 7, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 8, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 4, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 16, 'duration': '925s'}, {'originIndex': 11, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 9, 'destinationIndex': 16, 'duration': '925s'}, {'originIndex': 7, 'destinationIndex': 1, 'duration': '925s'}, {'originIndex': 1, 'destinationIndex': 11, 'duration': '863s'}, {'originIndex': 8, 'destinationIndex': 9, 'duration': '863s'}, {'originIndex': 7, 'destinationIndex': 13, 'duration': '925s'}, {'originIndex': 14, 'destinationIndex': 12, 'duration': '925s'}, {'originIndex': 17, 'destinationIndex': 7, 'duration': '863s'}]

        print(response_data)

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

    def get_available_time_slot(self,schedule,date,weekday,time):

        total_time_available = timedelta()

        daily_schedule = schedule[date]
        end_of_day = self.user_requirements.get_current_day_end(weekday)

        while daily_schedule[time] == None and time <= end_of_day:
            total_time_available += timedelta(minutes=1)
            time = self.increment_time(time)

        return total_time_available

    def get_allocated_tasks(self,schedule):
        
        all_tasks = set()
        for daily_schedule in schedule.values():
            for time_slot in daily_schedule.values():
                if time_slot is not None:
                    all_tasks.add(time_slot)

        # allocated_tasks_refs = [task for task in all_tasks if task.startswith('s')]
        allocated_tasks_refs = [task for task in all_tasks if task != "travel"]
        allocated_tasks = []

        for task_ref in allocated_tasks_refs:
            task = self.get_task_dict(task_ref)
            allocated_tasks.append(task)
            
        return allocated_tasks

    # def display_all_tasks(self):

    #     all_tasks = set()
    #     for daily_schedule in self.schedule.values():
    #         for time_slot in daily_schedule.values():
    #             if time_slot is not None:
    #                 all_tasks.add(time_slot)

    #     allocated_tasks_refs = [task for task in all_tasks if task != "travel"]
        
    #     for task_ref in allocated_tasks_refs:
    #         task = self.task_dict[task_ref]
    #         print(f"NAME: {task.get_name()}, TIME: {task.get_start_datetime()} - {task.get_end_datetime()}")

    def get_task_ordering(self):
        all_tasks = []
        for daily_schedule in self.schedule.values():
            for time_slot in daily_schedule.values():
                if time_slot is not None and time_slot not in all_tasks and time_slot != "travel":
                    all_tasks.append(time_slot)
        print(all_tasks)

