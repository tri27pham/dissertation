from userPreferences import UserPreferences
from taskAllocator import TaskAllocator
from hardTask import HardTask
from userRequirements import UserRequirements


from collections import defaultdict
from task import Task
from random import shuffle
import random
from datetime import datetime, timedelta, time
import copy

from allocatedTask import AllocatedTask

class GeneticAlgorithm:

    def __init__(self,tasks,user_requirements,user_preferences):

        self.generation_size = 10

        self.tasks = tasks
        self.task_dict = {}
        for task in tasks:
            self.task_dict[task.getID()] = task
        self.population_size = len(tasks)

        self.user_preferences = user_preferences
        self.task_allocator = TaskAllocator(user_requirements,tasks)
        # self.task_allocator.allocate_hard_tasks(hard_tasks)
        self.task_allocator.get_travel_times(tasks)
        print("init")

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

        initial_population = []
        for order in orders:
            tasks = [self.task_dict[task_ref] for task_ref in order]
            allocated_tasks = self.task_allocator.knapsack_allocator(tasks)
            points = self.user_preferences.get_preferences_satisfied(allocated_tasks)
            initial_population.append([order,points])

        self.initial_population = initial_population

        print("INITIAL POPULATION")
        for order in self.initial_population:
            print(f"ORDER: {order[0]}, POINTS: {order[1]}")
            for task in order[0]:
                print(self.task_dict[task].get_priority())

    def shuffle(self,order):

        valid_priorities = False
        while not valid_priorities:
        
            # create an empty array to populated with new order
            new_order = [None] * len(order)

            # get the nodes that are important in maintaining acyclic property and order them
            unordered_important_nodes = self.get_important_nodes(order)
            important_nodes = self.topological_sort(unordered_important_nodes)

            # get nodes that aren't important in maintaining acyclic property
            unimportant_nodes = list(set(order) - set(important_nodes))

            node_start = 0

            # ASSIGN IMPORTANT TASKS

            # assigns nodes randomly into an array while maintaining order

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
            
            if self.priorities_valid(new_order):
                print(new_order)
                
                valid_priorities = True

        return new_order

    def get_important_nodes(self,order):

        incoming_edges = set()
        outgoing_edges = set()

        for task in order:
            task_object = self.task_dict[task]
            for prior_task_ref in task_object.get_prior_tasks():
                prior_task = self.task_dict[prior_task_ref]
                incoming_edges.add(task)
                outgoing_edges.add(prior_task.getID())
        
        important_nodes = incoming_edges.union(outgoing_edges)
        return list(important_nodes)

    def is_acyclic(self, order):

        seen = set()
        for task_ref in order:
            # print(f"set: {seen}")
            if task_ref is not None:
                for prior_task_ref in self.task_dict[task_ref].get_prior_tasks():
                    prior_task = self.task_dict[prior_task_ref]
                    if prior_task.getID() not in seen:
                        return False
                seen.add(task_ref)
        return True

    def priorities_valid(self,order):

        seen_1 = False
        seen_0 = False

        for task_ref in order:
            if task_ref is None:
                continue
            priority = self.task_dict[task_ref].get_priority()
            if priority == 2:
                if seen_1 or seen_0:
                    return False
            elif priority == 1:
                if seen_0:
                    return False
                seen_1 = True
            elif priority == 0:
                if not seen_1:
                    return False
                seen_0 = True
            else:
                return False          

        return True

    def order(self, tasks):
        # all tasks
        sorted_tasks = self.topological_sort(tasks)
        tasks_in_order = []
        for task in sorted_tasks:
            if task in tasks:
                tasks_in_order.append(task)
        return tasks_in_order


    def topological_sort(self, task_IDs):
        result = []  # To store the topological order
        visited = set()  # To keep track of visited tasks during DFS
        stack = []  # To keep track of tasks in the order they are finished

        # convert list of task IDs to list of actual Task objects
        tasks = [self.task_dict[task_ID] for task_ID in task_IDs]

        def dfs(task):

            nonlocal visited
            visited.add(task)

            for prior_task_ref in task.get_prior_tasks():
            # for prior_task in task.get_prior_tasks():
                prior_task = self.task_dict[prior_task_ref]
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
    def select_best_from_initial(self):
        
        # sort the initial orders based on their points
        sorted_orders = sorted(self.initial_population, key=lambda x: x[1], reverse=True)
        # get the 2 highest scoring orders
        best = sorted_orders[:2]

        return [order[0] for order in best]

    def evolve(self):

        outcomes = {}

        optimal = ((),(),0)
        same = 0

        parents = self.select_best_from_initial()

        mother = parents[0]
        father = parents[1]

        generation = 1

        while same < 20:
            # print(f"SAME: {same}")

            new_generation = set() 

            while len(new_generation) <= self.generation_size:
                # print("make new child")
                new_child = tuple(self.create_child(mother,father))
                if new_child not in new_generation:
                    tasks = [self.task_dict[task_ref] for task_ref in new_child]
                    # print("valid kid")
                    allocated_tasks = self.task_allocator.knapsack_allocator(tasks)
                    points = self.user_preferences.get_preferences_satisfied(allocated_tasks)
                    new_generation.add((tuple(allocated_tasks),new_child,points))

            sorted_orders = sorted(new_generation, key=lambda x: x[1], reverse=True)
            # get best performing children / new parents
            best = sorted_orders[:2]
            mother_score = best[0]
            father_score = best[1]

            # get the order of tasks - by TaskID
            mother = mother_score[1]

            print("===================================")
            print(f"GENERATION {generation}: {mother_score[1]}, POINTS: {mother_score[2]}")
            print("===================================")
            generation += 1

            # print(f"{previous_optimal}, {optimal[1]}")
            if mother_score[2] > optimal[2]:
                same = 0
            else:
                same += 1

            optimal = max((optimal, mother_score), key=lambda x: x[2])

        print("===================================")
        print(f"OPTIMAL ORDER: {optimal[0]}, POINTS: {optimal[2]}")
        print("===================================")

        # for task in optimal[0]:
        #     print(f"ID: {task.getID()}")
        #     print(f"NAME: {task.get_name()}")
        #     print(f"START: {task.get_start_datetime()}")
        #     print(f"FINISH: {task.get_end_datetime()}")
        #     print(f"PRIORITY: {task.get_priority()}")
        #     print(f"PRIOR TASKS: {task.get_prior_tasks()}")
        #     print(f"LOCATION NAME: {task.get_location_name()}")
        #     print(f"LOCATION COORDS: {task.get_location_coords()}")
        #     print(f"CATEGORY: {task.get_category()}")

        # best_order = max(outcomes, key=lambda k: outcomes[k])
        # best_points = outcomes[best_order]

        # print("===================================")
        # print(f"OPTIMAL ORDER: {best_order}, POINTS: {best_points}")
        # print("===================================")

        return optimal[0]

    # create new generations
    def create_child(self,mother,father):

        valid_important_nodes = False
        valid_priorities = False
        while not valid_important_nodes:

            # crossover
            index = random.randint(0,len(mother)-2)
            len_segment = random.randint(1,len(mother)-1-index)

            # get important nodes
            important_nodes = self.topological_sort(self.get_important_nodes(mother))

            # create an empty array to represent child
            child = [None] * len(mother)
            
            # get segment from mother
            segment = mother[index:index+len_segment]

            # copy segment from mother to child
            for idx in range(len_segment):
                child[index+idx] = segment[idx]

            # check to see if segment contains any important nodes 
            important_segment_nodes = list(set(important_nodes) & set(segment))

            # check to see if important nodes can assigned correctly
            if len(important_segment_nodes) == 0:
                valid_important_nodes = True
            else:

                start_segment = child[:index]
                end_segment = child[index+len_segment:]

                prior_index = float('inf')
                post_index = float('-inf')

                for segment_node in important_segment_nodes:
                    prior_index = min(prior_index, important_nodes.index(segment_node))
                    post_index = max(post_index, len(important_nodes) - important_nodes[::-1].index(segment_node) - 1)

                prior = important_nodes[:prior_index]
                post = important_nodes[post_index + 1:]

                if len(prior) <= len(start_segment) and len(post) <= len(end_segment):
                    valid_important_nodes = True

            # check to see if nodes of different priorities can be assigned correctly
            # get priority of first and last node of segment  
            start_node_priority = self.task_dict[child[index]].get_priority()
            end_node_priority = self.task_dict[child[index+len_segment-1]].get_priority()
            print(child)
            print(f"start {start_node_priority}")
            print(f"end {end_node_priority}")

            raise Exception
            

        # get important nodes that must be placed before / after segment
        if len(important_segment_nodes) > 0 and len(important_segment_nodes) < len(important_nodes):

            prior_index = float('inf')
            post_index = float('-inf')

            for segment_node in important_segment_nodes:
                prior_index = min(prior_index, important_nodes.index(segment_node))
                post_index = max(post_index, len(important_nodes) - important_nodes[::-1].index(segment_node) - 1)

            prior = important_nodes[:prior_index]
            post = important_nodes[post_index + 1:]
            

            node_start = 0
            while len(prior) != 0: 
                # get random new index from after furthest index so far and last element
                new_index = random.randint(node_start,index-1)
                # assign task at this index
                child[new_index] = prior[0]
                # print(f"PRE-CHECK: {child}")
                # check that this placement maintains acyclic nature and remains enough space for remaining tasks
                # print(child)
                if (index - 1 - new_index >= len(prior)-1):
                    # update node_start index to next available space
                    node_start = new_index + 1
                    # remove the task that was just placed in the order
                    prior.remove(prior[0])
                else:
                    # remove allocated task is it doesn't meet requirements
                    child[new_index] = None
                # print(child)
                # print(f"POST-CHECK: {child}")

            node_start = index + len_segment
            while len(post) != 0:
                # print(f"{node_start}, {len(child)-1}")
                # get random new index from after furthest index so far and last element
                new_index = random.randint(node_start,len(child)-1)
                # assign task at this index
                child[new_index] = post[0]
                # check that this placement maintains acyclic nature and remains enough space for remaining tasks
                if (len(child) - 1 - new_index >= len(post)-1):
                    # update node_start index to next available space
                    node_start = new_index + 1
                    # remove the task that was just placed in the order
                    post.remove(post[0])
                else:
                    # remove allocated task is it doesn't meet requirementse
                    child[new_index] = None
                # print(f"CHILD: {child}")
                # break

        # print("=====================================================================")
        # print(f"IMPORTANT NODES: {child}")


        # in the case that all the important nodes are not in the segment
        # need to randomly assign while still maintaining order

        # print(f"child: {child}")

        remaining_nodes = list(set(father)-set(child))
        # print(f"remaining nodes: {remaining_nodes}")

        remaining_nodes_arr = [None] * len(remaining_nodes)
        # print(f"ARR: {remaining_nodes_arr}")

        # inter = set(remaining_nodes).intersection(  set(important_nodes)    )
        # print(f"remaining_important_nodes: {inter}")
        remaining_important_nodes = self.order(list( set(remaining_nodes).intersection(  set(important_nodes)    )   ))
        # print(f"base case: {remaining_important_nodes}")

        remaining_unimportant_nodes = list(set(remaining_nodes)-set(important_nodes))
        # print(f"remaining_unimportant_nodes: {remaining_unimportant_nodes}")

        if len(remaining_important_nodes) != 0:

            # random_indexes = [random.sample(0, len(remaining_nodes)-1) for _ in range(len(remaining_important_nodes))]

            random_indexes_set = set()
            # generate random indexes in which to place the remaining important nodes
            while len(random_indexes_set) <= len(remaining_important_nodes)-1:
                # print("1")
                # print(f"imp: {remaining_important_nodes}")
                # print(f"set: {random_indexes_set}")
                new_index = random.randint(0,len(remaining_nodes)-1)
                # print(f"new idx: {new_index}")
                # print(f"remaining: {len(remaining_nodes)}")
                if new_index not in random_indexes_set:
                    random_indexes_set.add(new_index)
            
            random_indexes = sorted(list(random_indexes_set))

            for idx in random_indexes:
                # print("2")
                # print(f"len: {remaining_important_nodes}")
                remaining_nodes_arr[idx] = remaining_important_nodes[0]
                remaining_important_nodes.pop(0)


        for index in range(len(remaining_nodes_arr)):
            # print("3")
            if remaining_nodes_arr[index] is None:
                remaining_nodes_arr[index] = remaining_unimportant_nodes[0]
                remaining_unimportant_nodes.pop(0)

        for index in range(len(child)):
            # print("4")
            if child[index] is None:
                child[index] = remaining_nodes_arr[0]
                remaining_nodes_arr.pop(0)

        # mutate
        
        for i in range(len(child)-1):
            # print("5")
            new_child = copy.copy(child)
            probability = random.random()
            if probability <= 0.2:
                current_node = child[i]
                swap_index = random.randint(0,len(child)-1)
                swap_node = child[swap_index]
                new_child[swap_index] = current_node
                new_child[i] = swap_node
                if self.is_acyclic(new_child):
                    child = new_child
        
        # print(f"CHILD: {child}")

        return child


# # tasks to allocate
# task3 = Task("3","Push session",timedelta(hours=2,minutes=0),3,(),"BUSH HOUSE",(51.503162, -0.086852),2)
# task2 = Task("2","OME Content",timedelta(hours=2,minutes=0),3,("3",),"GUY'S CAMPUS",(51.513056,-0.117352),0)
# task1 = Task("1","NSE Content",timedelta(hours=1,minutes=0),3,("2",),"BUSH HOUSE",(51.503162, -0.086852),1)
# task0 = Task("0","ML1 Content",timedelta(hours=1,minutes=0),3,("1",),"GUY'S CAMPUS",(51.513056,-0.117352),0)
# task4 = Task("4","Work",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
# task5 = Task("5","Pull session",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.503162, -0.086852),3)
# task6 = Task("6","10k",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
# task7 = Task("7","Dissertation",timedelta(hours=2,minutes=0),2,("3",),"GUY'S CAMPUS",(51.513056,-0.117352),0)
# task8 = Task("8","Work",timedelta(hours=2,minutes=0),2,(),"BUSH HOUSE",(51.503162,-0.086852),0)
# task9 = Task("9","Push session",timedelta(hours=2,minutes=0),1,("7","0",),"GUY'S CAMPUS",(51.513056,-0.117352),1)
# task10 = Task("10","Coursework",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
# task11 = Task("11","Legs session",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
# task12 = Task("12","Dissertation",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),5)
# task13 = Task("13","5k",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
# tasks_to_be_allocated = [task3,task4,task5,task6,task7,task8,task9,task11,task12,task13,task0,task1,task2,task10]


# nine_am = time(hour=9, minute=0, second=0)
# five_pm = time(hour=17, minute=0, second=0)

# user_requirements = UserRequirements(nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm)
# user_preferences = UserPreferences(False, True, True, False, False, True, False, True, True, False, True, False, True, False, True, True, False, False, True, True, False, True, False, False, False, True, True, False)

# ga = GeneticAlgorithm(tasks_to_be_allocated,user_requirements,user_preferences)
# ga.create_first_generation()
# data = ga.evolve()