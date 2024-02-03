# Task Allocator
# contains the logic of the task allocation model

from prioritiesEnum import Priority
from indoorOutdoorEnum import InOut
from taskTypeEnum import TaskType
from weekdayEnum import Weekday
from task import Task
from datetime import datetime
from userRequirements import UserRequirements

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

    # def knapsackAllocator():

    def getCurrentDay():
        return datetime.now().weekday()

# get input of tasks
task3 = Task(3,"Task3",0.5,Priority.HIGH,(),(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.IN)
task2 = Task(2,"Task2",1,Priority.HIGH,(task3,),(51.513056,-0.117352),TaskType.WORK,InOut.OUT)
task1 = Task(1,"Task1",2,Priority.HIGH,(task2,task3),(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.IN)


task4 = Task(4,"Task4",2.5,Priority.HIGH,(),(51.513056,-0.117352),TaskType.FITNESS,InOut.OUT)
task5 = Task(5,"Task5",2,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.COOKING,InOut.IN)
task6 = Task(6,"Task6",1,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.SOCIAL,InOut.OUT)
task7 = Task(7,"Task7",1.5,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.MISCELLANEOUS,InOut.OUT)
task8 = Task(8,"Task8",1,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.IN)
task9 = Task(9,"Task9",1,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.OUT)
task10 = Task(10,"Task10",2,Priority.LOW,(),(51.513056,-0.117352),TaskType.WORK,InOut.IN)
task11 = Task(11,"Task11",3,Priority.LOW,(),(51.513056,-0.117352),TaskType.COOKING,InOut.IN)

tasksToBeAllocated = [task1,task2,task3,task4,task5,task6,task7,task8,task9,task10,task11]

# taskAllocator = TaskAllocator()
# sortedTasks = taskAllocator.topologicalSort(tasksToBeAllocated)
# userRequirements = UserRequirements(9,18,9,18,9,18,9,18)
# # for task in sortedTasks:
# #     print(task.getName())

userRequirements = UserRequirements(9,18,9,18,9,18,9,18,9,18,9,18,9,18)
userRequirements.getDailyAvailability(datetime.now().weekday())
