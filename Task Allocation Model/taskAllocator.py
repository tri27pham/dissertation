# Task Allocator
# contains the logic of the task allocation model

from enums import Priority
from enums import InOut
from enums import TaskType

class TaskAllocator:

    # get input of tasks
    task1 = Task(1,"Task1",2,Priority.HIGH,(),(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.IN)
    task2 = Task(2,"Task2",1,Priority.HIGH,(),(51.513056,-0.117352),TaskType.WORK,InOut.OUT)
    task3 = Task(3,"Task3",0.5,Priority.HIGH,(),(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.IN)
    task4 = Task(4,"Task4",2.5,Priority.HIGH,(),(51.513056,-0.117352),TaskType.FITNESS,InOut.OUT)
    task5 = Task(5,"Task5",2,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.COOKING,InOut.IN)
    task6 = Task(6,"Task6",1,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.SOCIAL,InOut.OUT)
    task7 = Task(7,"Task7",1.5,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.MISCELLANEOUS,InOut.OUT)
    task8 = Task(8,"Task8",1,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.IN)
    task9 = Task(9,"Task9",1,Priority.MEDIUM,(),(51.513056,-0.117352),TaskType.UNIVERSITY,InOut.OUT)
    task10 = Task(10,"Task10",2,Priority.LOW,(),(51.513056,-0.117352),TaskType.WORK,InOut.IN)
    task11 = Task(11,"Task11",3,Priority.LOW,(),(51.513056,-0.117352),TaskType.COOKING,InOut.IN)

    # infoFromUser
    # generate task IDs
    # get task types
    # get user preferences
    tasksToBeAllocated = 