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

import googlemaps
import math

class TaskAllocator:

    def topologicalSort(self, tasks):
        result = []  # To store the topological order
        visited = set()  # To keep track of visited tasks during DFS
        stack = []  # To keep track of tasks in the order they are finished
        
        def dfs(task):
            nonlocal visited
            visited.add(task)

            for prior_task in task.getPriorTasks():
                if prior_task not in visited:
                    dfs(prior_task)

            stack.append(task)

        # Sort tasks by priority: HIGH, MEDIUM, LOW
        tasks.sort(key=lambda x: x.getPriority(), reverse=True)

        for task in tasks:
            if task not in visited:
                dfs(task)

        return stack


    def knapsackAllocator(self,tasksToAllocate,userRequirements,breakType):

        schedule = defaultdict(lambda: (0, []))
    
        currentDay = datetime.now().date()
        weekday = datetime.now().weekday()
        
        current_time = datetime.now().time()
        minutes_until_next_hour = (60 - current_time.minute) % 60
        currentTime = time((current_time.hour + 1) % 24, 0)

        while len(tasksToAllocate) != 0:

            currentTask = tasksToAllocate[0]
            if len(schedule[currentDay][-1]) != 0:                
                travelTime = self.getTravelTime(currentTime,schedule[currentDay][1][-1].getLocation(),currentTask.getLocation())
            else:
                travelTime = timedelta(0,0)
            TDcurrentTime = timedelta(hours=currentTime.hour,minutes=currentTime.minute)
            TDendOfDay = timedelta(hours=userRequirements.getCurrentDayEnd(weekday).hour,minutes=userRequirements.getCurrentDayEnd(weekday).minute)
            # print(travelTime + TDcurrentTime + currentTask.getDuration())
            if travelTime + TDcurrentTime + currentTask.getDuration() <= TDendOfDay:

                total_duration = TDcurrentTime + travelTime
                total_hours = total_duration.seconds // 3600
                total_minutes = (total_duration.seconds % 3600) // 60
                startTime = time(hour=total_hours,minute=total_minutes)

                total_duration = TDcurrentTime + travelTime + currentTask.getDuration()
                total_hours = total_duration.seconds // 3600
                total_minutes = (total_duration.seconds % 3600) // 60
                endTime = time(hour=total_hours,minute=total_minutes)


                newAllocatedTask = AllocatedTask(currentTask.getID(),currentTask.getName(),startTime,
                                    endTime,currentTask.getPriority(),currentTask.getPriorTasks(),
                                    currentTask.getLocation(),currentTask.getCategory())

                schedule[currentDay] = (weekday, schedule[currentDay][1])
                schedule[currentDay][1].append(newAllocatedTask)

                tasksToAllocate.pop(0)
                elapsedTime = travelTime + currentTask.getDuration()
                total_hours = elapsedTime.seconds // 3600
                total_minutes = (elapsedTime.seconds % 3600) // 60
                newTime = TDcurrentTime + timedelta(hours=total_hours,minutes=total_minutes)
                hours = int(newTime.total_seconds()) // 3600
                mins = (int(newTime.total_seconds()) % 3600) // 60
                currentTime = time(hour=hours,minute=mins)
                
            else:
                if weekday == 6:
                    weekday = 0
                    currentTime = userRequirements.getCurrentDayStart(weekday)
                else: 
                    weekday += 1
                    currentTime = userRequirements.getCurrentDayStart(weekday)
                currentDay = currentDay + timedelta(days=1)
        return schedule

    def getTravelTime(self,time,source,destination):

        gmaps_client = googlemaps.Client(key = "AIzaSyBaLZBGSMsZppfhtF8lu0IGvJ7Wpfg5294")

        result = gmaps_client.directions(source,destination, mode='transit',departure_time=datetime.now())

        if result:
            duration_in_seconds = result[0]['legs'][0]['duration']['value']
            duration_in_minutes = duration_in_seconds // 60  
            rounded_duration_in_minutes = int(math.ceil(duration_in_minutes / 5)) * 5
            hours, mins = divmod(rounded_duration_in_minutes,60)
            return timedelta(hours=hours,minutes=mins)
        else:
            return timedelta(0)

    def mins_to_datetime(self,mins):
        hours, minutes = divmod(mins, 60)
        return datetime(datetime.today().year, datetime.today().month, datetime.today().day, hours, minutes)

    def mins_to_string(self,mins):
        hours, minutes = divmod(mins, 60)
        return "{:02d}:{:02d}".format(hours, minutes)


task3 = Task(3,"OME Content",timedelta(hours=2,minutes=0),3,(),(51.513056,-0.117352),0)
task2 = Task(2,"NSE Content",timedelta(hours=2,minutes=0),3,(task3,),(51.503162, -0.086852),1)
task1 = Task(1,"ML1 Content",timedelta(hours=1,minutes=0),3,(task2,task3),(51.513056,-0.117352),0)
task4 = Task(4,"Task4",timedelta(hours=2,minutes=0),3,(),(51.503162, -0.086852),2)
task5 = Task(5,"Task5",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),2)
task6 = Task(6,"Task6",timedelta(hours=2,minutes=0),2,(),(51.503162, -0.086852),3)
task7 = Task(7,"Task7",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),6)
task8 = Task(8,"Task8",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task9 = Task(9,"Task9",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task10 = Task(10,"Task10",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),1)
task11 = Task(11,"Task11",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),2)
task12 = Task(12,"Task12",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task13 = Task(13,"Task13",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),5)
task14 = Task(14,"Task14",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),6)
tasksToBeAllocated = [task1,task2,task3,task4,task5,task6,task7,task8,task9,task10,task11,task12,task13,task14]

taskAllocator = TaskAllocator()

sortedTasks = taskAllocator.topologicalSort(tasksToBeAllocated)

nine_am = time(hour=9, minute=0, second=0)
five_pm = time(hour=18, minute=0, second=0)

userRequirements = UserRequirements(nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm)

breakType = BreakType.SHORT 

schedule = taskAllocator.knapsackAllocator(sortedTasks,userRequirements,breakType)

for key, val in schedule.items():
    match val[0]:
        case 0:
            print("MONDAY "+ str(key))
        case 1:
            print("TUESDAY "+ str(key))
        case 2:
            print("WEDNESDAY "+ str(key))
        case 3:
            print("THURSDAY "+ str(key))
        case 4:
            print("FRIDAY "+ str(key))
        case 5:
            print("SATURDAY "+ str(key))
        case 6:
            print("SUNDAY "+ str(key))
    for task in val[1]:
        print(f"{task.getName()}  Start: {task.getStartTime()}, End: {task.getEndTime()}, Priority: {task.getPriority()}")
    


