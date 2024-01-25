# Task Allocator
# contains the logic of the task allocation model

from prioritiesEnum import Priority
from indoorOutdoorEnum import InOut
from taskTypeEnum import TaskType

from task import Task

class TaskAllocator:

    def __init__(self):        
        self.highPriorityTasks = []
        self.mediumPriorityTasks = []
        self.lowPriorityTasks = []

        # get input of tasks
        task1 = Task(1,"Task1",2,Priority.HIGH,0,(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.IN)
        task2 = Task(2,"Task2",1,Priority.MEDIUM,0,(51.513056,-0.117352),TaskType.WORK,InOut.OUT)
        task3 = Task(3,"Task3",0.5,Priority.HIGH,0,(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.IN)
        task4 = Task(4,"Task4",2.5,Priority.HIGH,0,(51.513056,-0.117352),TaskType.FITNESS,InOut.OUT)
        task5 = Task(5,"Task5",2,Priority.MEDIUM,0,(51.513056,-0.117352),TaskType.COOKING,InOut.IN)
        task6 = Task(6,"Task6",1,Priority.HIGH,0,(51.513056,-0.117352),TaskType.SOCIAL,InOut.OUT)
        task7 = Task(7,"Task7",1.5,Priority.MEDIUM,0,(51.513056,-0.117352),TaskType.MISCELLANEOUS,InOut.OUT)
        task8 = Task(8,"Task8",1,Priority.MEDIUM,0,(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.IN)
        task9 = Task(9,"Task9",1,Priority.MEDIUM,0,(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.OUT)
        task10 = Task(10,"Task10",10,Priority.LOW,0,(51.513056,-0.117352),TaskType.WORK,InOut.IN)
        task11 = Task(11,"Task11",3,Priority.LOW,0,(51.513056,-0.117352),TaskType.COOKING,InOut.IN)

        taskList = [task1,task2,task3,task4,task5,task6,task7,task8,task9,task10,task11]

        self.sortTasks(taskList)

    def sortTasks(self,taskList):
        for task in taskList:
            if task.getPriority() == Priority.HIGH:
                self.highPriorityTasks.append(task)
            elif task.getPriority() == Priority.MEDIUM:
                self.mediumPriorityTasks.append(task)
            elif task.getPriority() == Priority.LOW:
                self.lowPriorityTasks.append(task)
            else:
                print("ERROR: INVALID PRIORITY")

    def getAverageTaskTimePerDay(taskList):
        total = 0
        for task in taskList:
            total += task.getDuration()
        return total / 7

    def viewTasks(self,taskList):
        for task in taskList:
            print("TaskID: " + str(task.getID()))
            print("Duration: " + str(task.getDuration()) + " hours")
            print("Priority: " + str(task.getPriority()))
            print("Prior Tasks: " + str(task.getPriorTasks()))
            print("Location: " + str(task.getLocation()))
            print("Task Type: " + str(task.getTaskType()))
            print("Indoor/Outdoor: " + str(task.getInOutDoor()))
            print()         

    
taskAllocator = TaskAllocator()
taskAllocator.viewTasks(taskAllocator.highPriorityTasks)

    # infoFromUser
    # generate task IDs
    # get task types