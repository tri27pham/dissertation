import matplotlib.pyplot as plt

from geneticAlgorithm import GeneticAlgorithm
from userRequirements import UserRequirements
from userPreferences import UserPreferences
from task import Task
from datetime import time, timedelta


task1 = Task("1", "Attend Lecture on Quantum Physics", timedelta(hours=2), 3, (), "Lecture Hall", (51.503162, -0.086852), 0)
task2 = Task("2", "Prepare Sales Report", timedelta(hours=3), 3, ("1",), "Office", (51.513056, -0.117352), 1)
task3 = Task("3", "Morning Jog", timedelta(hours=1), 3, (), "Local Park", (51.505, -0.1205), 2)
task4 = Task("4", "Meetup with Friends for Dinner", timedelta(hours=4), 2, ("3",), "Restaurant", (51.51, -0.11), 3)
task5 = Task("5", "Family Picnic", timedelta(hours=5), 2, (), "Picnic Spot", (51.5035, -0.086), 4)
task6 = Task("6", "Painting Class", timedelta(hours=2), 2, ("5",), "Art Studio", (51.512, -0.117),5)
task7 = Task("7", "Grocery Shopping", timedelta(hours=1.5), 2, (), "Supermarket", (51.509, -0.114), 6)
task8 = Task("8", "Study Group Session", timedelta(hours=3), 2, ("7",), "Library", (51.503162, -0.086852), 0)
task9 = Task("9", "Project Presentation", timedelta(hours=2.5), 1, (), "Conference Room", (51.51, -0.11), 1)
task10 = Task("10", "Yoga Class", timedelta(hours=1.5), 1, ("9",), "Yoga Studio", (51.513056, -0.117352), 2)
task11 = Task("11", "Volunteer at Local Shelter", timedelta(hours=3), 2, ("10",), "Shelter", (51.503162, -0.086852), 3)
task12 = Task("12", "Family Movie Night", timedelta(hours=2), 1, (), "Home", (51.51, -0.11), 4)
task13 = Task("13", "Photography Walk", timedelta(hours=2), 1, ("4",), "City Park", (51.5035, -0.086), 5)
task14 = Task("14", "Home Renovation Project", timedelta(hours=4), 1, ("13",), "Home", (51.512, -0.117), 5)
task15 = Task("15", "Study for Final Exams", timedelta(hours=4), 2, ("14",), "Library", (51.51, -0.11), 0)

tasks_to_be_allocated = [task1, task2, task3, task4, task5, task6, task7, task8, task9, task10, task11, task12, task13, task14, task15]

nine_am = time(hour=9, minute=0, second=0)
five_pm = time(hour=17, minute=0, second=0)

user_requirements = UserRequirements(nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm)
user_preferences = UserPreferences(False, True, True, False, False, True, False, True, True, False, True, False, True, False, True, True, False, False, True, True, False, True, False, False, False, True, True, False)

ga = GeneticAlgorithm(tasks_to_be_allocated,user_requirements,user_preferences)
data = ga.evolve()
print(data)

generations = [item[0] for item in ga.generation_data]
points = [item[1] for item in ga.generation_data]

plt.figure(figsize=(10, 6))
plt.plot(generations, points, marker='o', linestyle='-', color='b')
plt.title('Genetic Algorithm Performance Over Generations')
plt.xlabel('Generation')
plt.ylabel('Points Scored')
plt.grid(True)
plt.show()

