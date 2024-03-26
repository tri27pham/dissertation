from flask import Flask, request, jsonify
from geneticAlgorithm import GeneticAlgorithm


from datetime import datetime, timedelta, time
from hardTask import HardTask
from task import Task
from userRequirements import UserRequirements
from userPreferences import UserPreferences

import json

app = Flask(__name__)

@app.route('/data_endpoint', methods=['POST'])
def receive_data():
    data = request.json  
    print('Received data:', data)
    process_data(data)
    return jsonify({'message': 'Data received successfully'})

def process_data(data):

    tasks = data.get('tasks', [])
    times = data.get('times', {})
    preferences = data.get('preferences', {})

    processed_tasks = []

    for task in tasks:
        print(task)

        duration = timedelta(hours=task["hours"],minutes=task["minutes"])
        location_coords = (float(task["locationLongitude"]),float(task["locationLatitude"]))

        new_task = Task(
            task["taskID"],
            task["name"],
            duration,
            task["priority"],
            task["priorTasks"],
            task["locationName"],
            location_coords,
            task["category"]
        )

        processed_tasks.append(new_task)

    times_data = json.loads(times)

    mondayStart = parse_time_string(times_data["mondayStart"])
    mondayEnd = parse_time_string(times_data["mondayEnd"])
    tuesdayStart = parse_time_string(times_data["tuesdayStart"])
    tuesdayEnd = parse_time_string(times_data["tuesdayEnd"])
    wednesdayStart = parse_time_string(times_data["wednesdayStart"])
    wednesdayEnd = parse_time_string(times_data["wednesdayEnd"])
    thursdayStart = parse_time_string(times_data["thursdayStart"])
    thursdayEnd = parse_time_string(times_data["thursdayEnd"])
    fridayStart = parse_time_string(times_data["fridayStart"])
    fridayEnd = parse_time_string(times_data["fridayEnd"])
    saturdayStart = parse_time_string(times_data["saturdayStart"])
    saturdayEnd = parse_time_string(times_data["saturdayEnd"])
    sundayStart = parse_time_string(times_data["sundayStart"])
    sundayEnd = parse_time_string(times_data["sundayEnd"])

    



def parse_time_string(time_str):
    """
    Parse a time string in the format "YYYY-MM-DDTHH:MM:SS.MMM" and return a timedelta object.
    """
    # Extract time part from the datetime string
    time_part = time_str.split("T")[1]
    
    # Convert time string to datetime object with arbitrary date
    time_dt = datetime.strptime(time_part, "%H:%M:%S.%f")
    
    # Calculate timedelta for the time part
    timedelta_from_midnight = timedelta(hours=time_dt.hour, minutes=time_dt.minute, seconds=time_dt.second,
                                        microseconds=time_dt.microsecond)
    
    return timedelta_from_midnight

# @app.route('/')
# def index():
    

    # dt1_startx = datetime.now() + timedelta(hours=1)
    # dt1_start = dt1_startx.replace(second=0, microsecond=0)
    # dt1_endx = datetime.now() + timedelta(hours=2)
    # dt1_end = dt1_endx.replace(second=0, microsecond=0)

    # dt2_startx = datetime.now() + timedelta(hours=18)
    # dt2_start = dt2_startx.replace(second=0, microsecond=0)
    # dt2_endx = datetime.now() + timedelta(hours=20)
    # dt2_end = dt2_endx.replace(second=0, microsecond=0)

    # dt3_startx = datetime.now() + timedelta(hours=24)
    # dt3_start = dt3_startx.replace(second=0, microsecond=0)
    # dt3_endx = datetime.now() + timedelta(hours=25)
    # dt3_end = dt3_endx.replace(second=0, microsecond=0)

    # dt4_startx = datetime.now() + timedelta(days=2)
    # dt4_start = dt4_startx.replace(second=0, microsecond=0)
    # dt4_endx = datetime.now() + timedelta(days=2,hours=1)
    # dt4_end = dt4_endx.replace(second=0, microsecond=0)

    # dt5_startx = datetime.now() + timedelta(days=2, hours=2)
    # dt5_start = dt5_startx.replace(second=0, microsecond=0)
    # dt5_endx = datetime.now() + timedelta(days=2, hours=4)
    # dt5_end = dt5_endx.replace(second=0, microsecond=0)

    # hardTask1 = HardTask("h1","HardTask1",dt1_start,dt1_end,(51.513056,-0.117352))
    # hardTask2 = HardTask("h2","HardTask2",dt2_start,dt2_end,(51.513056,-0.117352))
    # hardTask3 = HardTask("h3","HardTask3",dt3_start,dt3_end,(51.513056,-0.117352))
    # hardTask4 = HardTask("h4","HardTask4",dt4_start,dt4_end,(51.513056,-0.117352))
    # hardTask5 = HardTask("h5","HardTask5",dt5_start,dt5_end,(51.513056,-0.117352))

    # hard_tasks = [hardTask1,hardTask2,hardTask3,hardTask4,hardTask4,hardTask5]

    # # tasks to allocate
    # task3 = Task("s3","Push session",timedelta(hours=2,minutes=0),3,(),"BUSH HOUSE",(51.503162, -0.086852),2)
    # task2 = Task("s2","OME Content",timedelta(hours=2,minutes=0),3,(task3,),"GUY'S CAMPUS",(51.513056,-0.117352),0)
    # task1 = Task("s1","NSE Content",timedelta(hours=1,minutes=0),3,(task2,),"BUSH HOUSE",(51.503162, -0.086852),1)
    # task0 = Task("s0","ML1 Content",timedelta(hours=1,minutes=0),3,(task1,),"GUY'S CAMPUS",(51.513056,-0.117352),0)
    # task4 = Task("s4","Work",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
    # task5 = Task("s5","Pull session",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.503162, -0.086852),3)
    # task6 = Task("s6","10k",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
    # task7 = Task("s7","Dissertation",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),0)
    # task8 = Task("s8","Work",timedelta(hours=2,minutes=0),2,(),"BUSH HOUSE",(51.503162,-0.086852),0)
    # task9 = Task("s9","Push session",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),1)
    # task10 = Task("s10","Coursework",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
    # task11 = Task("s11","Legs session",timedelta(hours=2,minutes=0),2,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
    # task12 = Task("s12","Dissertation",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),5)
    # task13 = Task("s13","5k",timedelta(hours=2,minutes=0),1,(),"GUY'S CAMPUS",(51.513056,-0.117352),2)
    # tasks_to_be_allocated = [task3,task4,task5,task6,task7,task8,task9,task11,task12,task13,task0,task1,task2,task10]

    # task_dict = {}

    # for task in tasks_to_be_allocated:
    #     task_dict[task.getID()] = task

    # nine_am = time(hour=9, minute=0, second=0)
    # five_pm = time(hour=18, minute=0, second=0)

    # user_requirements = UserRequirements(nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm,nine_am,five_pm)
    # user_preferences = UserPreferences()

    # ga = GeneticAlgorithm(tasks_to_be_allocated,hard_tasks,user_requirements,user_preferences)
    # ga.create_first_generation()
    # data = ga.evolve()

    # return jsonify(data)
    # return 

if __name__ == '__main__':
    app.run()