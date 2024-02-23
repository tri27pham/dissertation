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
                self.schedule[date][current_time] = task
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
        task_dict = {}

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

            # print(f"date: {date}")
            # print(f"time: {current_time}")
            # print(f"task: {schedule[date][current_time]}")
            
            # if there is no task allocated in this timeslot, travel time is 0
            if schedule[date][current_time] == None:
                travel_time = timedelta()
            # there is a task allocated at this time slot, so travel time to be calculated
            else:
                previousTask = schedule[date][current_time]
                travel_time = self.get_travel_time_free(task_dict[previousTask].get_location(),current_task.get_location())
                while schedule[date][current_time] != None:
                    current_time = self.incrementTime(current_time)
            
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

        # print("schedule")
        # print(schedule)

    # def knapsack_allocator(self,tasks_to_allocate,user_requirements,break_type):

    #     schedule = defaultdict(lambda: (0, []))
    
    #     current_day = datetime.now().date()
    #     weekday = datetime.now().weekday()
        
    #     # get the next closest hour
    #     current_time = datetime.now().time()
    #     minutes_until_next_hour = (60 - current_time.minute) % 60
    #     current_time = time((current_time.hour + 1) % 24, 0)

    #     while len(tasks_to_allocate) != 0:

    #         current_task = tasks_to_allocate[0]
    #         if len(schedule[current_day][-1]) != 0:                
    #             travel_time = self.get_travel_time_free(current_time,schedule[current_day][1][-1].get_location(),current_task.get_location())
    #         else:
    #             travel_time = timedelta(0,0)
    #         TD_current_time = timedelta(hours=current_time.hour,minutes=current_time.minute)
    #         TD_end_of_day = timedelta(hours=user_requirements.get_current_day_end(weekday).hour,minutes=user_requirements.get_current_day_end(weekday).minute)
    #         # print(travelTime + TDcurrentTime + current_task.getDuration())
    #         if travel_time + TD_current_time + current_task.get_duration() <= TD_end_of_day:

    #             total_duration = TD_current_time + travel_time
    #             total_hours = total_duration.seconds // 3600
    #             total_minutes = (total_duration.seconds % 3600) // 60
    #             start_time = time(hour=total_hours,minute=total_minutes)

    #             total_duration = TD_current_time + travel_time + current_task.get_duration()
    #             total_hours = total_duration.seconds // 3600
    #             total_minutes = (total_duration.seconds % 3600) // 60
    #             end_time = time(hour=total_hours,minute=total_minutes)


    #             new_allocated_task = AllocatedTask(current_task.getID(),current_task.get_name(),start_time,
    #                                 end_time,current_task.get_priority(),current_task.get_prior_tasks(),
    #                                 current_task.get_location(),current_task.get_category())

    #             schedule[current_day] = (weekday, schedule[current_day][1])
    #             schedule[current_day][1].append(new_allocated_task)

    #             tasks_to_allocate.pop(0)
    #             elapsed_time = travel_time + current_task.get_duration()
    #             total_hours = elapsed_time.seconds // 3600
    #             total_minutes = (elapsed_time.seconds % 3600) // 60
    #             new_time = TD_current_time + timedelta(hours=total_hours,minutes=total_minutes)
    #             hours = int(new_time.total_seconds()) // 3600
    #             mins = (int(new_time.total_seconds()) % 3600) // 60
    #             current_time = time(hour=hours,minute=mins)
                
    #         else:
    #             if weekday == 6:
    #                 weekday = 0
    #                 current_time = user_requirements.get_current_day_start(weekday)
    #             else: 
    #                 weekday += 1
    #                 current_time = user_requirements.get_current_day_start(weekday)
    #             current_day = current_day + timedelta(days=1)
    #     return schedule

    def get_travel_time_free(self,source,destination):
        random_num = random.randint(0, 6)
        random_mult_5 = random_num * 5
        return timedelta(minutes=random_mult_5)

    def get_travel_time_paid(self,source,destination):

        # print(type(time))

        url = 'https://routes.googleapis.com/directions/v2:computeRoutes'
        headers = {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': 'AIzaSyBaLZBGSMsZppfhtF8lu0IGvJ7Wpfg5294',
            'X-Goog-FieldMask': 'routes.duration'
        }
        data = {
            "origin": {
                "location": {
                    "latLng": {
                        "latitude": source[0],
                        "longitude": source[1]
                    }
                }
            },
            "destination": {
                "location": {
                    "latLng": {
                        "latitude": destination[0],
                        "longitude": destination[1]
                    }
                }
            },
            "travelMode": "TRANSIT",
            "languageCode": "en-US",
            "units": "IMPERIAL"
        }

        response = requests.post(url, json=data, headers=headers)

        if response.status_code == 200 and response.json():
            print("Request successful.")
            print("Response:", response.json())
            response_data = response.json()
            time_seconds_string = response_data['routes'][0]['duration']
            time_seconds_int = int(time_seconds_string[:-1])
            minutes = time_seconds_int / 60
            rounded_minutes =  math.ceil(minutes / 5) * 5
            return timedelta(minutes=rounded_minutes)
        else:
            # print("Request failed with status code:", response.status_code)
            return timedelta()

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

hardTask1 = HardTask(1,"HardTask1",dt1_start,dt1_end)
hardTask2 = HardTask(2,"HardTask2",dt2_start,dt2_end)
hardTask3 = HardTask(3,"HardTask3",dt3_start,dt3_end)
hardTask4 = HardTask(4,"HardTask4",dt4_start,dt4_end)
hardTask5 = HardTask(5,"HardTask5",dt5_start,dt5_end)

hard_tasks = [hardTask1,hardTask2,hardTask3,hardTask4,hardTask4,hardTask5]

# tasks to allocate
task3 = Task(3,"OME Content",timedelta(hours=2,minutes=0),3,(),(51.513056,-0.117352),0)
task2 = Task(2,"NSE Content",timedelta(hours=2,minutes=0),3,(task3,),(51.503162, -0.086852),1)
task1 = Task(1,"ML1 Content",timedelta(hours=1,minutes=0),3,(task2,task3),(51.513056,-0.117352),0)
task4 = Task(4,"Push session",timedelta(hours=2,minutes=0),3,(),(51.503162, -0.086852),2)
task5 = Task(5,"Work",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),2)
task6 = Task(6,"Pull session",timedelta(hours=2,minutes=0),2,(),(51.503162, -0.086852),3)
task7 = Task(7,"10k",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),6)
task8 = Task(8,"Dissertation",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task9 = Task(9,"Work",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task10 = Task(10,"Push session",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),1)
task11 = Task(11,"Coursework",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),2)
task12 = Task(12,"Legs session",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task13 = Task(13,"Dissertation",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),5)
task14 = Task(14,"5k",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),6)
tasks_to_be_allocated = [task1,task2,task3,task4,task5,task6,task7,task8,task9,task10,task11,task12,task13,task14]

task_allocator = TaskAllocator()

sorted_tasks = task_allocator.topological_sort(tasks_to_be_allocated)

nine_am = time(hour=9, minute=0, second=0)
five_pm = time(hour=18, minute=0, second=0)

user_requirements = UserRequirements(nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm)

breakType = BreakType.SHORT 

task_allocator.allocate_hard_tasks(hard_tasks)
task_allocator.knapsack_allocator(sorted_tasks,user_requirements)

for k, v in task_allocator.schedule.items():
    for time, task in v.items():
        if task != None:
            name = task
            print(f"{k} {time}: {name}")
        

# for key, val in schedule.items():
#     match val[0]:
#         case 0:
#             print("MONDAY "+ str(key))
#         case 1:
#             print("TUESDAY "+ str(key))
#         case 2:
#             print("WEDNESDAY "+ str(key))
#         case 3:
#             print("THURSDAY "+ str(key))
#         case 4:
#             print("FRIDAY "+ str(key))
#         case 5:
#             print("SATURDAY "+ str(key))
#         case 6:
#             print("SUNDAY "+ str(key))
#     for task in val[1]:
#         print(f"{task.get_name()}  Start: {task.get_start_time()}, End: {task.get_end_time()}, Priority: {task.get_priority()}")
    


