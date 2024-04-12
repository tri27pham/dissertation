"""
This module contains the Flask application that serves as the API for the genetic algorithm.
"""

from flask import Flask, request, jsonify
from geneticAlgorithm import GeneticAlgorithm
from task import Task
from userRequirements import UserRequirements
from userPreferences import UserPreferences
from datetime import datetime, timedelta
import json

app = Flask(__name__)

@app.route('/data_endpoint', methods=['POST'])
def receive_data():
    """
    Receive data from the frontend and return the processed data.

    Parameters:
    - request: HTTP request object - the data to be passed to the Genetic Algorithm

    Returns:
    - response: HTTP response object - list of allocated tasks
    """
    data = request.json  
    processed_data = process_data(data)
    return jsonify(processed_data)

def process_data(data):
    """
    Process the data received from the frontend and return the list of allocated tasks.
    Parameters:
    - data: dict - the data received from the frontend
    Returns:
    - response_data: str - the list of allocated tasks in JSON format
    """

    tasks = data.get('tasks', [])
    times = data.get('times', {})
    preferences = data.get('preferences', {})

    tasks_to_allocate = process_tasks(tasks)
    user_requirements = process_times(times)
    user_preferences = process_preferences(preferences)
    
    ga = GeneticAlgorithm(tasks_to_allocate,user_requirements,user_preferences)
    data = ga.evolve()

    allocated_tasks_data = []
    for task in data:
        task_data = {
            "taskID": task.getID(),
            "name": task.get_name(),
            "start_datetime": task.get_start_datetime().isoformat(),
            "end_datetime": task.get_end_datetime().isoformat(),
            "priority": task.get_priority(),
            "prior_tasks": task.get_prior_tasks(),
            "location_name": task.get_location_name(),
            "location_coords": task.get_location_coords(),
            "category": task.get_category_val()
        }
        allocated_tasks_data.append(task_data)

    response_data = json.dumps(allocated_tasks_data)

    return response_data

def process_tasks(tasks):
    """
    Process the tasks received from the frontend and return a list of Task objects.
    Parameters:
    - tasks: list - the tasks received from the frontend
    Returns:
    - processed_tasks: list - the list of Task objects
    """
    processed_tasks = []

    for task in tasks:

        duration = timedelta(hours=task["hours"],minutes=task["minutes"])
        location_coords = (float(task["locationLatitude"]),float(task["locationLongitude"]))

        new_task = Task(
            str(task["taskID"]),
            task["name"],
            duration,
            task["priority"],
            task["priorTasks"],
            task["locationName"],
            location_coords,
            task["category"]
        )

        processed_tasks.append(new_task)
    
    return processed_tasks
    
def process_times(times):
    """
    Process the times received from the frontend and return a UserRequirements object.
    Parameters: 
    - times: dict - the times received from the frontend
    Returns:
    - user_requirements: UserRequirements - the UserRequirements object
    """
    times_data = json.loads(times)

    monday_start = parse_time_string(times_data["mondayStart"])
    monday_end = parse_time_string(times_data["mondayEnd"])
    tuesday_start = parse_time_string(times_data["tuesdayStart"])
    tuesday_end = parse_time_string(times_data["tuesdayEnd"])
    wednesday_start = parse_time_string(times_data["wednesdayStart"])
    wednesday_end = parse_time_string(times_data["wednesdayEnd"])
    thursday_start = parse_time_string(times_data["thursdayStart"])
    thursday_end = parse_time_string(times_data["thursdayEnd"])
    friday_start = parse_time_string(times_data["fridayStart"])
    friday_end = parse_time_string(times_data["fridayEnd"])
    saturday_start = parse_time_string(times_data["saturdayStart"])
    saturday_end = parse_time_string(times_data["saturdayEnd"])
    sunday_start = parse_time_string(times_data["sundayStart"])
    sunday_end = parse_time_string(times_data["sundayEnd"])

    user_requirements = UserRequirements(
        monday_start, monday_end, 
        tuesday_start, tuesday_end,
        wednesday_start, wednesday_end, 
        thursday_start, thursday_end,
        friday_start, friday_end,
        saturday_start, saturday_end, 
        sunday_start, sunday_end
    )

    return user_requirements

def process_preferences(preferences):
    """
    Process the preferences received from the frontend and return a UserPreferences object.
    Parameters:
    - preferences: dict - the preferences received from the frontend
    Returns:
    - user_preferences: UserPreferences - the UserPreferences object
    """
    preferences_data = json.loads(preferences)

    university_morning = preferences_data['university']['morning']
    university_evening = preferences_data['university']['evening']
    university_start_of_week = preferences_data['university']['startOfWeek']
    university_end_of_week = preferences_data['university']['endOfWeek']

    work_morning = preferences_data['work']['morning']
    work_evening = preferences_data['work']['evening']
    work_start_of_week = preferences_data['work']['startOfWeek']
    work_end_of_week = preferences_data['work']['endOfWeek']

    health_morning = preferences_data['health']['morning']
    health_evening = preferences_data['health']['evening']
    health_start_of_week = preferences_data['health']['startOfWeek']
    health_end_of_week = preferences_data['health']['endOfWeek']

    social_morning = preferences_data['social']['morning']
    social_evening = preferences_data['social']['evening']
    social_start_of_week = preferences_data['social']['startOfWeek']
    social_end_of_week = preferences_data['social']['endOfWeek']

    family_morning = preferences_data['family']['morning']
    family_evening = preferences_data['family']['evening']
    family_start_of_week = preferences_data['family']['startOfWeek']
    family_end_of_week = preferences_data['family']['endOfWeek']

    hobbies_morning = preferences_data['hobbies']['morning']
    hobbies_evening = preferences_data['hobbies']['evening']
    hobbies_start_of_week = preferences_data['hobbies']['startOfWeek']
    hobbies_end_of_week = preferences_data['hobbies']['endOfWeek']

    miscellaneous_morning = preferences_data['miscellaneous']['morning']
    miscellaneous_evening = preferences_data['miscellaneous']['evening']
    miscellaneous_start_of_week = preferences_data['miscellaneous']['startOfWeek']
    miscellaneous_end_of_week = preferences_data['miscellaneous']['endOfWeek']

    user_preferences = UserPreferences(
        university_morning, university_evening, university_start_of_week, university_end_of_week, 
        work_morning, work_evening, work_start_of_week, work_end_of_week, 
        health_morning, health_evening, health_start_of_week, health_end_of_week, 
        social_morning, social_evening, social_start_of_week, social_end_of_week, 
        family_morning, family_evening, family_start_of_week, family_end_of_week, 
        hobbies_morning, hobbies_evening, hobbies_start_of_week, hobbies_end_of_week, 
        miscellaneous_morning, miscellaneous_evening, miscellaneous_start_of_week, miscellaneous_end_of_week
    )

    return user_preferences

def parse_time_string(time_str):
    """
    Parse a time string in the format "YYYY-MM-DDTHH:MM:SS.MMM" and return a time object.
    Parameters:
    - time_str: str - the time string to be parsed
    Returns:
    - time_obj: time - the time object
    """
    time_part = time_str.split("T")[1]
    time_obj = datetime.strptime(time_part, "%H:%M:%S.%f").time()

    return time_obj

if __name__ == '__main__':
    app.run()