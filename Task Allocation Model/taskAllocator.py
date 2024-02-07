# Task Allocator
# contains the logic of the task allocation model

from prioritiesEnum import Priority
from taskCategoryEnum import TaskCategory
from weekdayEnum import Weekday
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

    def knapsackAllocator(self,tasksToAllocate,userRequirements):

        # print(len(tasksToAllocate))

        schedule = defaultdict(list)

        currentDay = datetime.now().weekday() + 1
        currentTime = userRequirements.getCurrentDayStart(currentDay)
        for task in tasksToAllocate:
            if currentTime + task.duration <= userRequirements.getCurrentDayEnd(currentDay):
                newAllocatedTask = AllocatedTask(task.getID(),task.getName(),currentTime,
                                    currentTime+task.getDuration(),task.getPriority(),task.getPriorTasks(),
                                    task.getLocation(),task.getCategory())
                schedule[currentDay].append(newAllocatedTask)
                currentTime += task.getDuration()
            else:
                if currentDay == 6:
                    currentDay = 0
                    currentTime = userRequirements.getCurrentDayStart(currentDay)
                else:
                    currentDay += 1
                    currentTime = userRequirements.getCurrentDayStart(currentDay)
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
task10 = Task(10,"Task10",2,0,(),(51.513056,-0.117352),1)
task11 = Task(11,"Task11",3,0,(),(51.513056,-0.117352),2)
tasksToBeAllocated = [task1,task2,task3,task4,task5,task6,task7,task8,task9,task10,task11]

taskAllocator = TaskAllocator()

sortedTasks = taskAllocator.topologicalSort(tasksToBeAllocated)

userRequirements = UserRequirements(9,16,9,18,9,18,9,18,9,18,9,18,9,18)

schedule = taskAllocator.knapsackAllocator(sortedTasks,userRequirements)

for key, val in schedule.items():
    print("DAY: " + str(key))
    for task in val:
        print(f"{task.getName()}  Start: {task.getStartTime()}, End: {task.getEndTime()}")
    

