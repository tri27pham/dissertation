from taskAllocator import TaskAllocator
from random import shuffle
import random
import copy
from datetime import time, timedelta
from task import Task
from userRequirements import UserRequirements
from userPreferences import UserPreferences

class GeneticAlgorithm:

    def __init__(self,tasks,user_requirements,user_preferences):

        """
        Initializes the instance with the provided tasks, user requirements, and user preferences.

        Parameters:
        - tasks (List<Task>): A list of Task objects to be optimised
        - user_requirements (List<Datetime.time>): A list of user-defined start and end times for 
            use in task allocation
        - user_preferences (List<Bool>): A list of user-defined booleans representing presence or
            absence of preferences
        Returns:
        None
        """

        # set the desired number of individuals per generation
        self.generation_size = 10

        self.tasks = tasks

        for task in tasks:
            print(task.get_name())

        # create dictionary for conversion between taskId and Task object
        self.task_dict = {}
        for task in tasks:
            self.task_dict[task.getID()] = task
        
        self.user_preferences = user_preferences

        self.task_allocator = TaskAllocator(user_requirements,tasks)

        # # calculate the travel times between all task locations
        # self.task_allocator.get_travel_times(tasks)

    def create_first_generation(self):
        """
        Creates the initial generation for the genetic algorithm.
        """

        # set the number of individuals in initial population
        initial_population_size = 10

        # set to keep track of individuals produced
        orders = set()
        
        # get task IDs of all tasks
        task_IDs = [task_ID for task_ID in self.task_dict.keys()]
        # get an initial topological order
        top_order = self.topological_sort(task_IDs)
        # add initial topological order to list of orders
        orders.add(tuple(top_order))

        # iterate until the numbers of orders equals desired population size
        while len(orders) <= initial_population_size:
            new_order = tuple(self.shuffle_order(top_order))
            if new_order not in orders:
                orders.add(tuple(new_order))

        initial_population = []
        # get the order of tasks and preferences satisfied of each of initial population
        for order in orders:
            tasks = [self.task_dict[task_ref] for task_ref in order]
            allocated_tasks = self.task_allocator.knapsack_allocator(tasks)
            points = self.user_preferences.get_preferences_satisfied(allocated_tasks)
            initial_population.append([order,points])

        self.initial_population = initial_population

        """"
        the following prints out the individuals and corresponding user preferences satisfied
        of each of the individuals in the inital population
        """
        """ 
        print("INITIAL POPULATION")
            for order in self.initial_population:
                print(f"ORDER: {order[0]}, POINTS: {order[1]}")
        """

    def shuffle_order(self,order):
        """        
        Shuffles the order of tasks in a list while maintaining the topological order.

        Parameters:
        - order (List<Task>): A list of Task objects to be shuffled

        Returns:
        - new_order (List<Task>): A list of Task objects with shuffled order
        """
        
        # create an empty array to populated with new order
        new_order = [None] * len(order)

        # get the nodes that are important in maintaining topological order and order them
        unordered_important_nodes = self.get_important_nodes(order)
        # sort the important nodes in topological order
        important_nodes = self.topological_sort(unordered_important_nodes)

        # get nodes that aren't important in maintaining acyclic property
        unimportant_nodes = list(set(order) - set(important_nodes))

        # set the start index for assigning important nodes
        node_start = 0

        # iterate until all important nodes have been assigned
        while len(important_nodes) != 0:
            # get random index to place important node
            index = random.randint(node_start,len(new_order)-1)
            # assign task at this index
            new_order[index] = important_nodes[0]
            # check that this placement maintains topological order and remains enough space for remaining tasks
            if self.is_topological(new_order) and (len(new_order)-1-index >= len(important_nodes)-1):
                # update node_start index to next available space
                node_start = index + 1
                # remove the task that was just placed in the order
                important_nodes.remove(important_nodes[0])
            else:
                # remove allocated task if it doesn't meet requirements
                new_order[index] = None

        random.shuffle(unimportant_nodes)
        # assign the remaining unimportant nodes to the remaining indexes
        for index in range(len(new_order)):
            if new_order[index] is None:
                new_order[index] = unimportant_nodes[0]
                unimportant_nodes.pop(0)

        return new_order

    def get_important_nodes(self,order):
        """
        Returns the nodes that are important in maintaining the topological order of the tasks.

        Parameters:
        - order (List<Task>): A list of Task objects represented an order

        Returns:
        - important_nodes (List<Task>): A list of Task objects that are important in maintaining the topological order
        """

        incoming_edges = set()
        outgoing_edges = set()

        for taskId in order:
            # use taskID to fetch task object
            task_object = self.task_dict[taskId]
            # Iterate over the IDs of tasks that must precede the current task
            for prior_task_ref in task_object.get_prior_tasks():
                prior_task = self.task_dict[prior_task_ref]
                #  Mark the current task as having an incoming edge
                incoming_edges.add(taskId)
                 # Mark each preceding task as having an outgoing edge
                outgoing_edges.add(prior_task.getID())
                # Important nodes are those with either incoming or outgoing edges, indicating dependencies
        important_nodes = incoming_edges.union(outgoing_edges)
        return list(important_nodes)

    def is_topological(self, order):
        """	
        Determines whether a given order of tasks is topological.

        Parameters:
        - order (List<Task>): A list of Task objects to be checked for topological order

        Returns:
        - bool: True if the order is topological, False otherwise

        """

        seen = set()
        for task_ref in order:
            if task_ref is not None:
                # iterate over each prior task
                for prior_task_ref in self.task_dict[task_ref].get_prior_tasks():
                    prior_task = self.task_dict[prior_task_ref]
                    # if the prior task has not been seen, the order is not topological
                    if prior_task.getID() not in seen:
                        return False
                # mark the current task as seen
                seen.add(task_ref)
        return True

    def order_subset(self, tasks_subset):
        """
        This function takes a subset of tasks and returns a topological order of the subset.

        Parameters:
        - tasks_subset (List<Task>): A subset of tasks to be ordered

        Returns:
        - tasks_in_order (List<Task>): A list of Task objects in topological order

        """
        # get all the tasks that have dependencies with the subset
        sorted_tasks = self.topological_sort(tasks_subset)
        tasks_in_order = []
        for task in sorted_tasks:
            # add only the tasks in the subset to the order
            if task in tasks_subset:
                tasks_in_order.append(task)
        return tasks_in_order

    def topological_sort(self, task_IDs):
        """
        Sorts a list of tasks in topological order.
        
        Parameters:
        - task_IDs (List<Task>): A list of Task objects to be sorted

        Returns:
        - sorted_tasks_IDs (List<Task>): A list of Task objects in topological order
        """
        visited = set() 
        stack = [] 

        # convert list of task IDs to Task objects
        tasks = [self.task_dict[task_ID] for task_ID in task_IDs]

        def dfs(task):

            # Mark the current task as visited
            nonlocal visited
            visited.add(task)

            for prior_task_ref in task.get_prior_tasks():
                prior_task = self.task_dict[prior_task_ref]
                # If the prior task has not been visited, visit it
                if prior_task not in visited:
                    dfs(prior_task)

            stack.append(task)

        # Sort tasks by priority: HIGH, MEDIUM, LOW
        tasks.sort(key=lambda x: x.get_priority(), reverse=True)

        # Visit each task
        for task in tasks:
            if task not in visited:
                dfs(task)

        # Get the IDs of the sorted tasks
        sorted_tasks_IDs = [task.getID() for task in stack]

        return sorted_tasks_IDs

    def select_best_from_initial(self):
        """
        Selects the best performing individuals from the initial population.
        Returns:
        - best (List<Task>): A list of the best performing individuals
        """	        
        # sort the initial orders based on their points
        sorted_orders = sorted(self.initial_population, key=lambda x: x[1], reverse=True)
        # get the highest scoring order and its points
        best = sorted_orders[0]
        # return the order
        return best[0]

    def evolve(self):
        """
        Evolves the population of individuals to find the optimal solution.

        Returns:
        - optimal (List<Task>): A ordering of tasks representing the optimal solution
        """	

        # initialise optimal solution
        # format: ( list of allocated tasks , list of task IDs, user preferences satisfied)
        optimal = ((),(),0)
        # initialise counter for number of generations without improvemed solution
        same = 0

        # get the best performing individual from the initial population
        parent = self.select_best_from_initial()

        # set the generation counter
        generation = 1

        # iterate until the optimal solution has not improved for 20 generations
        while same < 20:

            new_generation = set() 

            while len(new_generation) <= self.generation_size:
                new_child = tuple(self.create_child(parent))
                if new_child not in new_generation:
                    tasks = [self.task_dict[task_ref] for task_ref in new_child]
                    allocated_tasks = self.task_allocator.knapsack_allocator(tasks)
                    points = self.user_preferences.get_preferences_satisfied(allocated_tasks)
                    new_generation.add((tuple(allocated_tasks),new_child,points))

            sorted_orders = sorted(new_generation, key=lambda x: x[1], reverse=True)

            # get the best performing individual from the new generation
            parent_result = sorted_orders[0]

            # get the task objects, order and points of the best performing individual
            tasks, order, points = parent_result[0], parent_result[1], parent_result[2]

            print("===================================")
            print(f"GENERATION {generation}: {order}, POINTS: {points}")
            print("===================================")
            generation += 1

            # check if the new generation has a better solution than the current optimal solution
            if points > optimal[2]:
                same = 0
            else:
                same += 1

            # update the optimal solution
            optimal = max((optimal, parent_result), key=lambda x: x[2])

        print("===================================")
        print(f"OPTIMAL ORDER: {optimal[1]}, POINTS: {optimal[2]}")
        print("===================================")

        # return the list of allocated tasks of the optimal solution
        return optimal[0]

    def create_child(self,parent):

        """
        Create a new child from a parent by performing crossover and mutation operations.

        Parameters:
        - parent (List<Task>): A list of Task objects representing the parent

        Returns:
        - child (List<Task>): A list of Task objects representing the child
        """

        valid_segment = False

        # iterate until a valid segment is found
        while not valid_segment:

            # get random index to start segment
            index = random.randint(0,len(parent)-2)

            # get random length of segment
            len_segment = random.randint(1,len(parent)-1-index)

            # get important nodes that affect the topological order in the order they must be placed
            important_nodes = self.topological_sort(self.get_important_nodes(parent))

            # create child array to be populated
            child = [None] * len(parent)
            
            # get segment from parent
            segment = parent[index:index+len_segment]

            # copy segment from parent to child
            for idx in range(len_segment):
                child[index+idx] = segment[idx]

            # check to see if segment contains any important nodes 
            important_segment_nodes = list(set(important_nodes) & set(segment))

            # if segment contains no important nodes, then segment is valid
            if len(important_segment_nodes) == 0:
                valid_segment = True
            # if segment contains important nodes, then check if there is enough space for remaining important nodes
            else:
                # get start and end indexes of segment
                start_segment = child[:index]
                end_segment = child[index+len_segment:]

                prior_index = float('inf')
                post_index = float('-inf')

                # finds the earliest and latest positions important_segment_nodes appear
                for segment_node in important_segment_nodes:
                    prior_index = min(prior_index, important_nodes.index(segment_node))
                    post_index = max(post_index, len(important_nodes) - important_nodes[::-1].index(segment_node) - 1)

                # get the important nodes that must be placed before / after segment
                prior = important_nodes[:prior_index]
                post = important_nodes[post_index + 1:]

                # check that there is enough space for remaining important prior nodes in the start segment and
                    # remaining important post nodes in the end segment
                if len(prior) <= len(start_segment) and len(post) <= len(end_segment):
                    valid_important_nodes = True
            
        # check if there are important nodes in the segment
        # check that not all important nodes are in the segment
        if len(important_segment_nodes) > 0 and len(important_segment_nodes) < len(important_nodes):

            prior_index = float('inf')
            post_index = float('-inf')

            # finds the earliest and latest positions important_segment_nodes appear
            for segment_node in important_segment_nodes:
                prior_index = min(prior_index, important_nodes.index(segment_node))
                post_index = max(post_index, len(important_nodes) - important_nodes[::-1].index(segment_node) - 1)

            #  get the important nodes that must be placed before / after segment
            prior = important_nodes[:prior_index]
            post = important_nodes[post_index + 1:]
            
            # set the start index for assigning prior important nodes
            node_start = 0
            # iterate until all prior important nodes have been assigned
            while len(prior) != 0: 
                # get random new index from start and furthest index so far
                new_index = random.randint(node_start,index-1)
                # assign task at this index
                child[new_index] = prior[0]
                # check that there remains enough space for remaining prior important nodes
                if (index - 1 - new_index >= len(prior)-1):
                    # update node_start index to next available space
                    node_start = new_index + 1
                    # remove the task that was just placed in the order
                    prior.remove(prior[0])
                else:
                    # remove allocated task is it doesn't meet requirements
                    child[new_index] = None

            # set the start index for assigning post important nodes
            node_start = index + len_segment
            # iterate until all post important nodes have been assigned
            while len(post) != 0:
                # get random new index between furthest index so far and last element
                new_index = random.randint(node_start,len(child)-1)
                # assign task at this index
                child[new_index] = post[0]
                # check that there remains enough space for remaining post important tasks
                if (len(child) - 1 - new_index >= len(post)-1):
                    # update node_start index to next available space
                    node_start = new_index + 1
                    # remove the task that was just placed in the order
                    post.remove(post[0])
                else:
                    # remove allocated task is it doesn't meet requirementse
                    child[new_index] = None

        # get the remaining nodes that have not been assigned
        remaining_nodes = list(set(parent)-set(child))

        # create array to store remaining nodes
        remaining_nodes_arr = [None] * len(remaining_nodes)

        # get the important nodes that have not been assigned in the case that there are no important nodes in the segment
        remaining_important_nodes = self.order_subset(list( set(remaining_nodes).intersection(  set(important_nodes)    )   ))

        # get the unimportant nodes that have not been assigned
        remaining_unimportant_nodes = list(set(remaining_nodes)-set(important_nodes))

        # iterate until all important nodes have been assigned
        if len(remaining_important_nodes) != 0:

            random_indexes_set = set()

            # iterate until all important nodes have been assigned
            while len(random_indexes_set) <= len(remaining_important_nodes)-1:

                # get random index to place important node
                new_index = random.randint(0,len(remaining_nodes)-1)

                # add index to set if it hasn't been used
                if new_index not in random_indexes_set:
                    random_indexes_set.add(new_index)
            
            # sort the indexes
            random_indexes = sorted(list(random_indexes_set))

            # assign the important nodes to the random indexes
            for idx in random_indexes:
                remaining_nodes_arr[idx] = remaining_important_nodes[0]
                remaining_important_nodes.pop(0)

        # assign the remaining unimportant nodes to the remaining indexes
        for index in range(len(remaining_nodes_arr)):
            if remaining_nodes_arr[index] is None:
                remaining_nodes_arr[index] = remaining_unimportant_nodes[0]
                remaining_unimportant_nodes.pop(0)

        # assign the remaining nodes to the child
        for index in range(len(child)):
            if child[index] is None:
                child[index] = remaining_nodes_arr[0]
                remaining_nodes_arr.pop(0)
        
        # mutate the child
        for i in range(len(child)-1):
            # get a copy of the child
            new_child = copy.copy(child)
            probability = random.random()
            # if probability is less than 0.2, swap the current node with another node
            if probability <= 0.2:
                current_node = child[i]
                swap_index = random.randint(0,len(child)-1)
                swap_node = child[swap_index]
                new_child[swap_index] = current_node
                new_child[i] = swap_node
                # check if the new child is topological
                if self.is_topological(new_child):
                    # if it is, set the child to the new child
                    child = new_child
        
        return child


# # tasks to allocate
task3 = Task("3","Push session",timedelta(hours=2,minutes=0),3,(),"BUSH HOUSE",(51.503162, -0.086852),2)
task2 = Task("2","OME Content",timedelta(hours=2,minutes=0),3,("3",),"GUY'S CAMPUS",(51.513056,-0.117352),0)
task1 = Task("1","NSE Content",timedelta(hours=1,minutes=0),3,("2",),"BUSH HOUSE",(51.503162, -0.086852),1)
task0 = Task("0","ML1 Content",timedelta(hours=1,minutes=0),3,("1",),"GUY'S CAMPUS",(51.513056,-0.117352),0)
task4 = Task("4","Work",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
task5 = Task("5","Pull session",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.503162, -0.086852),3)
task6 = Task("6","10k",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
task7 = Task("7","Dissertation",timedelta(hours=2,minutes=0),2,("3",),"GUY'S CAMPUS",(51.513056,-0.117352),0)
task8 = Task("8","Work",timedelta(hours=2,minutes=0),2,(),"BUSH HOUSE",(51.503162,-0.086852),0)
task9 = Task("9","Push session",timedelta(hours=2,minutes=0),1,("7","0",),"GUY'S CAMPUS",(51.513056,-0.117352),1)
task10 = Task("10","Coursework",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
task11 = Task("11","Legs session",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
task12 = Task("12","Dissertation",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),5)
task13 = Task("13","5k",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
tasks_to_be_allocated = [task3,task4,task5,task6,task7,task8,task9,task11,task12,task13,task0,task1,task2,task10]


nine_am = time(hour=9, minute=0, second=0)
five_pm = time(hour=17, minute=0, second=0)

user_requirements = UserRequirements(nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm)
user_preferences = UserPreferences(False, True, True, False, False, True, False, True, True, False, True, False, True, False, True, True, False, False, True, True, False, True, False, False, False, True, True, False)

# ga = GeneticAlgorithm(tasks_to_be_allocated,user_requirements,user_preferences)
# ga.create_first_generation()
# data = ga.evolve()