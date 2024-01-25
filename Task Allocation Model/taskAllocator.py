# Task Allocator
# contains the logic of the task allocation model

from enums import Priority
from enums import InOut
from enums import TaskType

class TaskAllocator:

    # get input of tasks
    task1 = Task(1,2,priority.HIGH,priorTasks,(51.513056,-0.117352),"Task1",TaskType.UNIVERSITY,InOut.IN)
    task2 = Task(2,1,priority.HIGH,priorTasks,(51.513056,-0.117352),"Task2",TaskType.WORK,InOut.OUT)
    task3 = Task(3,0.5,priority.HIGH,priorTasks,(51.513056,-0.117352),"Task3",TaskType.UNIVERSITY,InOut.IN)
    task4 = Task(4,2.5,priority.HIGH,priorTasks,(51.513056,-0.117352),"Task4",TaskType.FITNESS,InOut.OUT)
    task5 = Task(5,2,priority.MEDIUM,priorTasks,(51.513056,-0.117352),"Task5",TaskType.COOKING,InOut.IN)
    task6 = Task(6,1,priority.MEDIUM,priorTasks,(51.513056,-0.117352),"Task6",TaskType.SOCIAL,InOut.OUT)
    task7 = Task(7,1.5,priority.MEDIUM,priorTasks,(51.513056,-0.117352),"Task7",TaskType.MISCELLANEOUS,InOut.OUT)
    task8 = Task(8,1,priority.MEDIUM,priorTasks,(51.513056,-0.117352),"Task8",TaskType.UNIVERSITY,InOut.IN)
    task9 = Task(9,1,priority.MEDIUM,priorTasks,(51.513056,-0.117352),"Task9",TaskType.UNIVERSITY,InOut.OUT)
    task10 = Task(10,2,priority.LOW,priorTasks,(51.513056,-0.117352),"Task10",TaskType.WORK,InOut.IN)
    task11 = Task(11,3,priority.LOW,priorTasks,(51.513056,-0.117352),"Task11",TaskType.COOKING,InOut.IN)

    # infoFromUser
    # generate task IDs
    # get task types
    # get user preferences
    tasksToBeAllocated = 