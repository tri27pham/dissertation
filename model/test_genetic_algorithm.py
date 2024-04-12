"""
This module contains the unit tests for the GeneticAlgorithm and TaskAllocator class.
%%%%%%%%%%%%%%%%%%%%%%%%%%%
To run these tests, you need to be in directory:

"""

import unittest
from geneticAlgorithm import GeneticAlgorithm
from userRequirements import UserRequirements
from userPreferences import UserPreferences
from allocatedTask import AllocatedTask
from task import Task
from datetime import time, timedelta
import time as timer

class TestGeneticAlgorithm(unittest.TestCase):

    def setUp(self):
        """      
        Set up the test by creating the tasks, user requirements, user preferences and the genetic algorithm object.
        """
       
        self.task1 = Task("1", "Attend Lecture on Quantum Physics", timedelta(hours=2), 3, (), "Lecture Hall", (51.503162, -0.086852), 0)
        self.task2 = Task("2", "Prepare Sales Report", timedelta(hours=3), 3, (), "Office", (51.513056, -0.117352), 1)
        self.task3 = Task("3", "Morning Jog", timedelta(hours=1), 3, (), "Local Park", (51.505, -0.1205), 2)
        self.task4 = Task("4", "Meetup with Friends for Dinner", timedelta(hours=4), 2, (), "Restaurant", (51.51, -0.11), 3)
        self.task5 = Task("5", "Family Picnic", timedelta(hours=5), 2, (), "Picnic Spot", (51.5035, -0.086), 4)
        self.task6 = Task("6", "Painting Class", timedelta(hours=2), 2, ("5",), "Art Studio", (51.512, -0.117),5)
        self.task7 = Task("7", "Grocery Shopping", timedelta(hours=1.5), 2, (), "Supermarket", (51.509, -0.114), 6)
        self.task8 = Task("8", "Study Group Session", timedelta(hours=3), 2, ("1",), "Library", (51.503162, -0.086852), 0)
        self.task9 = Task("9", "Project Presentation", timedelta(hours=2.5), 1, ("2",), "Conference Room", (51.51, -0.11), 1)
        self.task10 = Task("10", "Yoga Class", timedelta(hours=1.5), 1, ("5",), "Yoga Studio", (51.513056, -0.117352), 2)
        self.task11 = Task("11", "Volunteer at Local Shelter", timedelta(hours=3), 2, (), "Shelter", (51.503162, -0.086852), 3)
        self.task12 = Task("12", "Family Movie Night", timedelta(hours=2), 1, ("7",), "Home", (51.51, -0.11), 4)
        self.task13 = Task("13", "Photography Walk", timedelta(hours=2), 1, ("8",), "City Park", (51.5035, -0.086), 5)
        self.task14 = Task("14", "Home Renovation Project", timedelta(hours=4), 1, ("1",), "Home", (51.512, -0.117), 5)
        self.task15 = Task("15", "Study for Final Exams", timedelta(hours=4), 2, ("1",), "Library", (51.51, -0.11), 0)

        tasks_to_be_allocated = [self.task1, self.task2, self.task3, self.task4, self.task5, self.task6, self.task7, self.task8, self.task9, self.task10, self.task11, self.task12, self.task13, self.task14, self.task15]

        nine_am = time(hour=9, minute=0, second=0)
        five_pm = time(hour=17, minute=0, second=0)
        self.user_requirements = UserRequirements(nine_am, five_pm, nine_am, five_pm, nine_am, five_pm, nine_am, five_pm, nine_am, five_pm, nine_am, five_pm, nine_am, five_pm)

        self.user_preferences = UserPreferences(False, True, True, False, False, True, False, True, True, False, True, False, True, False, True, True, False, False, True, True, False, True, False, False, False, True, True, False)
        
        self.ga = GeneticAlgorithm(tasks_to_be_allocated, self.user_requirements, self.user_preferences)

        # Get the tasks as IDs and objects
        self.tasks_as_IDs = [taskID for taskID in self.ga.task_dict.keys()]
        self.task_as_objects = [self.ga.task_dict[taskID] for taskID in self.tasks_as_IDs]

    def test_init(self):
        """Test if initialization correctly sets up the task list, task dictionary, and task allocator."""
        self.assertEqual(len(self.ga.tasks), 15)
        self.assertEqual(len(self.ga.task_dict), 15)

    def test_create_first_generation(self):
        """Test if the first generation of the genetic algorithm is created properly."""
        self.ga.create_first_generation(self.tasks_as_IDs,timer.time())
        self.assertEqual(len(self.ga.initial_population), self.ga.initial_population_size)
        self.ga.reset_initial_population()
    
    def test_fitness_function(self):
        """Test if the fitness function calculates a valid value."""
        allocated_tasks = self.ga.task_allocator.knapsack_allocator(self.task_as_objects)
        fitness = self.ga.get_fitness(allocated_tasks)
        self.assertTrue(fitness >= 0)

    def test_genetic_algorithm_profficiency(self):
        """Test if the fitness function calculates a valid value."""
        allocated_tasks = self.ga.evolve()
        fitness = self.ga.get_fitness(allocated_tasks)
        self.assertTrue(fitness >= len(allocated_tasks)/2)

    def test_evolve(self):
        """Test if the genetic algorithm evolves properly."""
        result = self.ga.evolve()
        self.assertIsInstance(result, tuple)
        self.assertTrue(len(result)>0)
        for task in result:
            self.assertIsInstance(task, AllocatedTask)

    def test_execution_time(self):
        """Test if the genetic algorithm executes within a reasonable time frame."""

        max_execution_time = 30 

        import time
        start_time = time.time()

        self.ga.evolve()

        elapsed_time = time.time() - start_time

        self.assertLessEqual(elapsed_time, max_execution_time)

    def test_tightly_constrained_tasks(self):
        """Test if the genetic algorithm returns a result provided tightly constrained tasks."""

        # Define the tightly constrained tasks to be allocated

        task1 = Task("1", "Attend Lecture on Quantum Physics", timedelta(hours=2), 3, (), "Lecture Hall", (51.503162, -0.086852), 0)
        task2 = Task("2", "Prepare Sales Report", timedelta(hours=3), 3, ("1",), "Office", (51.513056, -0.117352), 1)
        task3 = Task("3", "Morning Jog", timedelta(hours=1), 3, ("2",), "Local Park", (51.505, -0.1205), 2)
        task4 = Task("4", "Meetup with Friends for Dinner", timedelta(hours=4), 2, ("3"), "Restaurant", (51.51, -0.11), 3)
        task5 = Task("5", "Family Picnic", timedelta(hours=5), 2, ("4",), "Picnic Spot", (51.5035, -0.086), 4)
        task6 = Task("6", "Painting Class", timedelta(hours=2), 2, ("5",), "Art Studio", (51.512, -0.117),5)
        task7 = Task("7", "Grocery Shopping", timedelta(hours=1.5), 2, ("6",), "Supermarket", (51.509, -0.114), 6)
        task8 = Task("8", "Study Group Session", timedelta(hours=3), 2, ("7",), "Library", (51.503162, -0.086852), 0)
        task9 = Task("9", "Project Presentation", timedelta(hours=2.5), 1, ("8",), "Conference Room", (51.51, -0.11), 1)
        task10 = Task("10", "Yoga Class", timedelta(hours=1.5), 1, ("9",), "Yoga Studio", (51.513056, -0.117352), 2)
        task11 = Task("11", "Volunteer at Local Shelter", timedelta(hours=3), 2, ("10",), "Shelter", (51.503162, -0.086852), 3)
        task12 = Task("12", "Family Movie Night", timedelta(hours=2), 1, ("11",), "Home", (51.51, -0.11), 4)
        task13 = Task("13", "Photography Walk", timedelta(hours=2), 1, ("12",), "City Park", (51.5035, -0.086), 5)
        task14 = Task("14", "Home Renovation Project", timedelta(hours=4), 1, ("13",), "Home", (51.512, -0.117), 5)
        task15 = Task("15", "Study for Final Exams", timedelta(hours=4), 2, ("14",), "Library", (51.51, -0.11), 0)

        tasks_to_be_allocated = [task1, task2, task3, task4, task5, task6, task7, task8, task9, task10, task11, task12, task13, task14, task15]

        nine_am = time(hour=9, minute=0, second=0)
        five_pm = time(hour=17, minute=0, second=0)
        user_requirements = UserRequirements(nine_am, five_pm, nine_am, five_pm, nine_am, five_pm, nine_am, five_pm, nine_am, five_pm, nine_am, five_pm, nine_am, five_pm)

        user_preferences = UserPreferences(False, True, True, False, False, True, False, True, True, False, True, False, True, False, True, True, False, False, True, True, False, True, False, False, False, True, True, False)
        
        ga = GeneticAlgorithm(tasks_to_be_allocated, user_requirements, user_preferences)
        result = ga.evolve()

        self.assertIsNotNone(result)

    def test_shuffle_order(self):
        """Test if the order of tasks is shuffled while maintaining topological order."""
        new_order = self.ga.shuffle_order(self.tasks_as_IDs)
        self.assertTrue(self.ga.is_topological(new_order))

    def test_get_important_nodes(self):
        """Test if the important nodes in maintaining the topological order of tasks are retrieved."""
        # get the important nodes using method
        result_important_nodes = self.ga.get_important_nodes(self.tasks_as_IDs)
        # actual important nodes
        important_nodes = ['5','1','2','7','8','6','9','10','12','13','14','15']
        self.assertEqual(sorted(result_important_nodes), sorted(important_nodes))

    def test_is_topological(self):
        """Test if a given order of tasks is topological."""
        """
            self.task1 = Task("1", "Attend Lecture on Quantum Physics", timedelta(hours=2), 3, (), "Lecture Hall", (51.503162, -0.086852), 0)
            self.task8 = Task("8", "Study Group Session", timedelta(hours=3), 2, ("1",), "Library", (51.503162, -0.086852), 0)
            self.task13 = Task("13", "Photography Walk", timedelta(hours=2), 1, ("8",), "City Park", (51.5035, -0.086), 5)
            only valid topolgical order is: 1, 8, 13
        """
        valid_order = [self.task1.getID(), self.task8.getID(), self.task13.getID()]
        invalid_order = [self.task13.getID(), self.task8.getID(), self.task1.getID()]
        self.assertTrue(self.ga.is_topological(valid_order))
        self.assertFalse(self.ga.is_topological(invalid_order))

    def test_order_subset(self):
        """Test if a subset of tasks is ordered properly."""
        tasks_subset = [self.task3.getID(), self.task4.getID(), self.task5.getID(), self.task6.getID(), self.task7.getID()]
        ordered_subset = self.ga.order_subset(tasks_subset)
        self.assertTrue(self.ga.is_topological(ordered_subset)) 

    def test_topological_sort(self):
        """Test if tasks are sorted in topological order."""
        sorted_tasks = self.ga.topological_sort(self.tasks_as_IDs)
        self.assertTrue(self.ga.is_topological(sorted_tasks))

    def test_crossover(self):
        """Test if crossover maintains topological order."""
        child = self.ga.crossover(self.tasks_as_IDs)
        self.assertTrue(self.ga.is_topological(child))

    def test_mutate(self):
        """"Test if mutation maintains topological order."""
        mutuated_child = self.ga.mutate(self.tasks_as_IDs)
        self.assertTrue(self.ga.is_topological(mutuated_child))

    def test_tasks_allocation_times(self):
        """Test if tasks are allocated within the user's time constraints."""
        allocated_tasks = self.ga.evolve()
        for task in allocated_tasks:
            self.assertTrue(task.get_start_datetime().time() >= self.user_requirements.get_current_day_start(task.get_start_datetime_as_weekday()))
            self.assertTrue(task.get_end_datetime().time() <= self.user_requirements.get_current_day_end(task.get_end_datetime_as_weekday()))
        
if __name__ == '__main__':
    unittest.main()
