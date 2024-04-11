# Task Allocator
# contains the logic of the task allocation model

from datetime import datetime, timedelta, time
from model.allocatedTask import AllocatedTask
from collections import defaultdict

import math
import random
import copy
import requests

class TaskAllocator:

    def __init__(self,user_requirements,tasks):
        self.user_requirements = user_requirements
        self.schedule = {}
        self.task_dict = {}
        for task in tasks:
            self.task_dict[task.getID()] = task
        self.get_travel_times(tasks)

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

            if current_time < self.user_requirements.get_current_day_start(weekday):
                current_time = self.user_requirements.get_current_day_start(weekday)
            
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
            
            # print(f"CURRENT: {current_time}")
            # print(f"TRAVEL: {travel_time}")
            # print(f"DURATION:  {current_task.get_duration()}")
            # print(f"AVAILABLE: {available_time_slot}")

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
        # print(locations)
        # raise Exception
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

        # print(locations)

        # call request and store response
        response = requests.post(url, json=data, headers=headers)
            
        response_data = response.json()

        travel_time_dict = {}
        try:
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

        except Exception as e:
            self.travel_times_matrix = self.generate_index_combinations(len(locations))

        

    def generate_index_combinations(self,max_value):
        """
        Generates a list of dictionaries with every possible combination of index pairs from 1 to max_value,
        and assigns a default duration to each.

        :param max_value: The maximum value for the index range (inclusive).
        :param default_duration: The default duration to assign to each index pair.
        :return: A list of dictionaries with 'originIndex', 'destinationIndex', and 'duration'.
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
        
        # all_tasks = set()
        # for daily_schedule in schedule.values():
        #     for time_slot in daily_schedule.values():
        #         if time_slot is not None:
        #             all_tasks.add(time_slot)

        all_tasks = []
        for daily_schedule in schedule.values():
            for time_slot in daily_schedule.values():
                if time_slot is not None and time_slot not in all_tasks:
                    all_tasks.append(time_slot)

        # allocated_tasks_refs = [task for task in all_tasks if task.startswith('s')]
        allocated_tasks_refs = [task for task in all_tasks if task != "travel"]
        allocated_tasks = []

        for task_ref in allocated_tasks_refs:
            task = self.get_task_dict(task_ref)
            allocated_tasks.append(task)
            
        return allocated_tasks

    def get_task_ordering(self):
        all_tasks = []
        for daily_schedule in self.schedule.values():
            for time_slot in daily_schedule.values():
                if time_slot is not None and time_slot not in all_tasks and time_slot != "travel":
                    all_tasks.append(time_slot)
        print(all_tasks)

