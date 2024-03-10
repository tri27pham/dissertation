from collections import defaultdict
from task import Task
from random import shuffle
import random

class GeneticAlgorithm:

    def __init__(self,tasks,population_size):

        self.tasks = tasks
        self.task_ref = {}
        for task in tasks:
            self.task_ref[task.getID()] = task

        self.population_size = population_size

    # initialise
    def create_first_generation(self):

        orders = []
        
        # get task IDs of all tasks
        task_IDs = [task_ID for task_ID in self.task_ref.keys()]
        # get an initial topological order
        top_order = self.topological_sort(task_IDs)
        # add initial topological order to list of orders
        orders.append(top_order)

        self.shuffle(top_order)
        
        # Repeat to generate n-1 additional random orderings
        for _ in range(self.population_size-1):
            break
            shuffled_order = top_order[:]  # Copy the initial topological ordering
            shuffle(shuffled_order)  # Shuffle the vertices randomly
            # break
            # Check if the shuffled order remains acyclic
            if self.is_acyclic(shuffled_order):
                orders.append(shuffled_order)
            else:
                # If the shuffled order is cyclic, discard it and try shuffling again
                while not self.is_acyclic(shuffled_order):
                    shuffle(shuffled_order)
                orders.append(shuffled_order)
    
        # return orders


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


    def get_important_nodes(self,order):

        incoming_edges = set()
        outgoing_edges = set()

        for task in order:
            task_object = self.task_ref[task]
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
                for prior_task in self.task_ref[task_ref].get_prior_tasks():
                    if prior_task.getID() not in seen:
                        return False
                seen.add(task_ref)
        return True

    def topological_sort(self, task_IDs):
        result = []  # To store the topological order
        visited = set()  # To keep track of visited tasks during DFS
        stack = []  # To keep track of tasks in the order they are finished

        # convert list of task IDs to list of actual Task objects
        tasks = [self.task_ref[task_ID] for task_ID in task_IDs]

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

    # crossover

    # mutate

    # terminate 