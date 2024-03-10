from userPreferences import UserPreferences
from taskAllocator import TaskAllocator
from hardTask import HardTask
from userRequirements import UserRequirements

from collections import defaultdict
from task import Task
from random import shuffle
import random
from datetime import datetime, timedelta, time

class GeneticAlgorithm:

    def __init__(self,tasks,population_size,task_allocator):

        self.tasks = tasks
        self.task_dict = {}
        for task in tasks:
            self.task_dict[task.getID()] = task
        self.population_size = population_size

        self.user_preferences = UserPreferences()
        self.task_allocator = task_allocator

    # initialise
    def create_first_generation(self):

        orders = set()
        
        # get task IDs of all tasks
        task_IDs = [task_ID for task_ID in self.task_dict.keys()]
        # get an initial topological order
        top_order = self.topological_sort(task_IDs)
        # add initial topological order to list of orders
        orders.add(tuple(top_order))

        while len(orders) <= self.population_size:
            new_order = tuple(self.shuffle(top_order))
            if new_order not in orders:
                orders.add(tuple(new_order))

        self.initial_population = orders

        for order in self.initial_population:
            tasks = []
            for task_ID in order:
                tasks.append(task_dict[task_ID])
            allocated_tasks = task_allocator.knapsack_allocator(tasks)
            points = user_preferences.get_preferences_satisfied(allocated_tasks)
            print(f"ORDER: {order}, POINTS: {points}")

    def shuffle(self,order):
        
        # create an empty array to populated with new order
        new_order = [None] * len(order)

        # get the nodes that are important in maintaining acyclic property and order them
        unordered_important_nodes = self.get_important_nodes(order)
        important_nodes = self.topological_sort(unordered_important_nodes)

        # get nodes that aren't important in maintaining acyclic property
        unimportant_nodes = list(set(order) - set(important_nodes))

        node_start = 0

        # ASSIGN IMPORTANT TASKS

        while len(important_nodes) != 0:
            # get random new index from after furthest index so far and last element
            index = random.randint(node_start,len(new_order)-1)
            # assign task at this index
            new_order[index] = important_nodes[0]
            # check that this placement maintains acyclic nature and remains enough space for remaining tasks
            if self.is_acyclic(new_order) and (len(new_order)-1-index >= len(important_nodes)-1):
                # update node_start index to next available space
                node_start = index + 1
                # remove the task that was just placed in the order
                important_nodes.remove(important_nodes[0])
            else:
                # remove allocated task is it doesn't meet requirementse
                new_order[index] = None
            
        # ASSIGN UNIMPORTANT TASKS

        random.shuffle(unimportant_nodes)
        for index in range(len(new_order)):
            if new_order[index] is None:
                new_order[index] = unimportant_nodes[0]
                unimportant_nodes.pop(0)

        return new_order

    def get_important_nodes(self,order):

        incoming_edges = set()
        outgoing_edges = set()

        for task in order:
            task_object = self.task_dict[task]
            for prior_task in task_object.get_prior_tasks():
                incoming_edges.add(task)
                outgoing_edges.add(prior_task.getID())
        
        important_nodes = incoming_edges.union(outgoing_edges)
        return list(important_nodes)

    def is_acyclic(self, order):

        seen = set()
        for task_ref in order:
            # print(f"set: {seen}")
            if task_ref is not None:
                for prior_task in self.task_dict[task_ref].get_prior_tasks():
                    if prior_task.getID() not in seen:
                        return False
                seen.add(task_ref)
        return True

    def topological_sort(self, task_IDs):
        result = []  # To store the topological order
        visited = set()  # To keep track of visited tasks during DFS
        stack = []  # To keep track of tasks in the order they are finished

        # convert list of task IDs to list of actual Task objects
        tasks = [self.task_dict[task_ID] for task_ID in task_IDs]

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

        sorted_tasks_IDs = [task.getID() for task in stack]
        return sorted_tasks_IDs

    # select
    def select(self):
        choices = []
        for order in self.initial_population:
            tasks = [self.task_dict[task_ref] for task_ref in order]
            allocated_tasks = self.task_allocator.knapsack_allocator(tasks)
            points = self.user_preferences.get_preferences_satisfied(allocated_tasks)
            choices.append([order,points])
        sorted_choices = sorted(choices, key=lambda x: x[1], reverse=True)
        return sorted_choices[:2]


    # crossover

    # mutate

    # terminate 

# hard tasks
dt1_startx = datetime.now() + timedelta(hours=1)
dt1_start = dt1_startx.replace(second=0, microsecond=0)
dt1_endx = datetime.now() + timedelta(hours=2)
dt1_end = dt1_endx.replace(second=0, microsecond=0)

dt2_startx = datetime.now() + timedelta(hours=18)
dt2_start = dt2_startx.replace(second=0, microsecond=0)
dt2_endx = datetime.now() + timedelta(hours=20)
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

hardTask1 = HardTask("h1","HardTask1",dt1_start,dt1_end,(51.513056,-0.117352))
hardTask2 = HardTask("h2","HardTask2",dt2_start,dt2_end,(51.513056,-0.117352))
hardTask3 = HardTask("h3","HardTask3",dt3_start,dt3_end,(51.513056,-0.117352))
hardTask4 = HardTask("h4","HardTask4",dt4_start,dt4_end,(51.513056,-0.117352))
hardTask5 = HardTask("h5","HardTask5",dt5_start,dt5_end,(51.513056,-0.117352))

hard_tasks = [hardTask1,hardTask2,hardTask3,hardTask4,hardTask4,hardTask5]

# tasks to allocate
task2 = Task("s2","OME Content",timedelta(hours=2,minutes=0),3,(),(51.513056,-0.117352),0)
task1 = Task("s1","NSE Content",timedelta(hours=1,minutes=0),3,(task2,),(51.503162, -0.086852),1)
task0 = Task("s0","ML1 Content",timedelta(hours=1,minutes=0),3,(task1,task2),(51.513056,-0.117352),0)
task3 = Task("s3","Push session",timedelta(hours=2,minutes=0),3,(),(51.503162, -0.086852),2)
task4 = Task("s4","Work",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),2)
task5 = Task("s5","Pull session",timedelta(hours=2,minutes=0),2,(),(51.503162, -0.086852),3)
task6 = Task("s6","10k",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),6)
task7 = Task("s7","Dissertation",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task8 = Task("s8","Work",timedelta(hours=2,minutes=0),2,(),(51.503162,-0.086852),0)
task9 = Task("s9","Push session",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),1)
task10 = Task("s10","Coursework",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),2)
task11 = Task("s11","Legs session",timedelta(hours=2,minutes=0),2,(),(51.513056,-0.117352),0)
task12 = Task("s12","Dissertation",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),5)
task13 = Task("s13","5k",timedelta(hours=2,minutes=0),1,(),(51.513056,-0.117352),6)
tasks_to_be_allocated = [task3,task4,task5,task6,task7,task8,task9,task10,task11,task12,task13,task0,task1,task2]

task_dict = {}

for task in tasks_to_be_allocated:
    task_dict[task.getID()] = task

nine_am = time(hour=9, minute=0, second=0)
five_pm = time(hour=18, minute=0, second=0)

user_requirements = UserRequirements(nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm)

all_tasks = hard_tasks + tasks_to_be_allocated

task_allocator = TaskAllocator(user_requirements,all_tasks)
task_allocator.allocate_hard_tasks(hard_tasks)
task_allocator.get_travel_times(all_tasks)

user_preferences = UserPreferences()

ga = GeneticAlgorithm(tasks_to_be_allocated,10,task_allocator)
ga.create_first_generation()


print("===================================BEST===================================")

best = ga.select()
for order in best:
    print(f"ORDER: {order[0]}, POINTS: {order[1]}")

