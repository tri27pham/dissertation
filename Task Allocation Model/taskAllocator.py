# Task Allocator
# contains the logic of the task allocation model

from prioritiesEnum import Priority
from taskCategoryEnum import TaskCategory
from weekdayEnum import Weekday
from breakTypeEnum import BreakType
from task import Task
from datetime import datetime
from userRequirements import UserRequirements
from allocatedTask import AllocatedTask
from collections import defaultdict

class TaskAllocator:

    def topologicalSort(self,tasks):
        result = []  # To store the topological order
        visited = set()  # To keep track of visited tasks during DFS
        stack = []  # To keep track of tasks in the order they are finished
        
        def dfs(task):
            nonlocal visited
            visited.add(task)

            # Recursively explore dependencies
            for prior_task in task.getPriorTasks():
                if prior_task not in visited:
                    dfs(prior_task)

            stack.append(task)

        # Iterate through all tasks in the graph
        for task in tasks:
            if task not in visited:
                dfs(task)

        return stack

    def knapsackAllocator(self,tasksToAllocate,userRequirements,breakType):

        schedule = defaultdict(lambda: (0, []))
    
        day = 1
        weekday = datetime.now().weekday() + 1
        currentTime = userRequirements.getCurrentDayStart(weekday)
        while len(tasksToAllocate) != 0:
            currentTask = tasksToAllocate[0]
            if currentTime + currentTask.duration <= userRequirements.getCurrentDayEnd(weekday):
                newAllocatedTask = AllocatedTask(currentTask.getID(),currentTask.getName(),currentTime,
                                    currentTime+currentTask.getDuration(),currentTask.getPriority(),currentTask.getPriorTasks(),
                                    currentTask.getLocation(),currentTask.getCategory())
                schedule[day] = (weekday, schedule[day][1])
                schedule[day][1].append(newAllocatedTask)
                tasksToAllocate.pop(0)
                currentTime += currentTask.getDuration()
            else:
                if weekday == 6:
                    weekday = 0
                    currentTime = userRequirements.getCurrentDayStart(weekday)
                else: 
                    weekday += 1
                    currentTime = userRequirements.getCurrentDayStart(weekday)
                day += 1
        return schedule
            
task3 = Task(3,"Task3",6,2,(),(51.513056,-0.117352),0)
task2 = Task(2,"Task2",1,2,(task3,),(51.513056,-0.117352),1)
task1 = Task(1,"Task1",4,2,(task2,task3),(51.513056,-0.117352),0)
task4 = Task(4,"Task4",2.5,2,(),(51.513056,-0.117352),2)
task5 = Task(5,"Task5",5,1,(),(51.513056,-0.117352),2)
task6 = Task(6,"Task6",3,1,(),(51.513056,-0.117352),3)
task7 = Task(7,"Task7",1.5,1,(),(51.513056,-0.117352),6)
task8 = Task(8,"Task8",3,1,(),(51.513056,-0.117352),0)
task9 = Task(9,"Task9",6,1,(),(51.513056,-0.117352),0)
task10 = Task(10,"Task10",5,0,(),(51.513056,-0.117352),1)
task11 = Task(11,"Task11",7,0,(),(51.513056,-0.117352),2)
task12 = Task(12,"Task12",3,1,(),(51.513056,-0.117352),0)
task13 = Task(13,"Task13",2,0,(),(51.513056,-0.117352),5)
task14 = Task(14,"Task14",1,0,(),(51.513056,-0.117352),6)
tasksToBeAllocated = [task1,task2,task3,task4,task5,task6,task7,task8,task9,task10,task11,task12,task13,task14]

taskAllocator = TaskAllocator()

sortedTasks = taskAllocator.topologicalSort(tasksToBeAllocated)

userRequirements = UserRequirements(9,16,9,18,9,18,9,18,9,18,9,18,9,18)

breakType = BreakType.SHORT 

schedule = taskAllocator.knapsackAllocator(sortedTasks,userRequirements,breakType)

for key, val in schedule.items():
    print("DAY: " + str(key))
    match val[0]:
        case 0:
            print("MONDAY")
        case 1:
            print("TUESDAY")
        case 2:
            print("WEDNESDAY")
        case 3:
            print("THURSDAY")
        case 4:
            print("FRIDAY")
        case 5:
            print("SATURDAY")
        case 6:
            print("SUNDAY")
    for task in val[1]:
        print(f"{task.getName()}  Start: {task.getStartTime()}, End: {task.getEndTime()}")
    

