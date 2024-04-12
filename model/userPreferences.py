from taskCategoryEnum import TaskCategory
from datetime import datetime

class UserPreferences:

    def __init__(self,
        university_morning, university_evening, university_start_of_week, university_end_of_week, 
        work_morning, work_evening, work_start_of_week, work_end_of_week, 
        health_morning, health_evening, health_start_of_week, health_end_of_week, 
        social_morning, social_evening, social_start_of_week, social_end_of_week, 
        family_morning, family_evening, family_start_of_week, family_end_of_week, 
        hobbies_morning, hobbies_evening, hobbies_start_of_week, hobbies_end_of_week, 
        miscellaneous_morning, miscellaneous_evening, miscellaneous_start_of_week, miscellaneous_end_of_week
    ):

        self.midday = datetime.combine(datetime.today(), datetime.min.time()).replace(hour=12, minute=0, second=0).time()
        self.midweek = 3

        self.university_morning = university_morning
        self.university_evening = university_evening
        self.university_start_of_week = university_start_of_week
        self.university_end_of_week = university_end_of_week

        self.work_morning = work_morning
        self.work_evening = work_evening
        self.work_start_of_week = work_start_of_week
        self.work_end_of_week = work_end_of_week

        self.health_morning = health_morning
        self.health_evening = health_evening
        self.health_start_of_week = health_start_of_week
        self.health_end_of_week = health_end_of_week
        
        self.social_morning = social_morning
        self.social_evening = social_evening
        self.social_start_of_week = social_start_of_week
        self.social_end_of_week = social_end_of_week

        self.family_morning = family_morning
        self.family_evening = family_evening
        self.family_start_of_week = family_start_of_week
        self.family_end_of_week = family_end_of_week

        self.hobbies_morning = hobbies_morning
        self.hobbies_evening= hobbies_evening
        self.hobbies_start_of_week = hobbies_start_of_week
        self.hobbies_end_of_week = hobbies_end_of_week      

        self.miscellaneous_morning = miscellaneous_morning
        self.miscellaneous_evening= miscellaneous_evening
        self.miscellaneous_start_of_week = miscellaneous_start_of_week
        self.miscellaneous_end_of_week = miscellaneous_end_of_week

    def get_preferences_satisfied(self,tasks):

        points = 0

        for task in tasks:
            
            match task.get_category():
                case TaskCategory.UNIVERSITY:
                    if self.university_morning and task.get_end_time() <= self.midday:
                        points += 1
                    if self.university_evening and task.get_start_time() > self.midday:
                        points += 1
                    if self.university_start_of_week and task.get_start_datetime().weekday() <= self.midweek:
                        points += 1
                    if self.university_end_of_week and task.get_start_datetime().weekday() > self.midweek:
                        points += 1
                case TaskCategory.WORK:
                    if self.work_morning and task.get_end_time() <= self.midday:
                        points += 1
                    if self.work_evening and task.get_start_time() > self.midday:
                        points += 1
                    if self.work_start_of_week and task.get_start_datetime().weekday() <= self.midweek:
                        points += 1
                    if self.work_end_of_week and task.get_start_datetime().weekday() > self.midweek:
                        points += 1
                case TaskCategory.HEALTH:
                    if self.health_morning and task.get_end_time() <= self.midday:
                        points += 1
                    if self.health_evening and task.get_start_time() > self.midday:
                        points += 1
                    if self.health_start_of_week and task.get_start_datetime().weekday() <= self.midweek:
                        points += 1
                    if self.health_end_of_week and task.get_start_datetime().weekday() > self.midweek:
                        points += 1
                case TaskCategory.SOCIAL:
                    if self.social_morning and task.get_end_time() <= self.midday:
                        points += 1
                    if self.social_evening and task.get_start_time() > self.midday:
                        points += 1
                    if self.social_start_of_week and task.get_start_datetime().weekday() <= self.midweek:
                        points += 1
                    if self.social_end_of_week and task.get_start_datetime().weekday() > self.midweek:
                        points += 1
                case TaskCategory.FAMILY:
                    if self.family_morning and task.get_end_time() <= self.midday:
                        points += 1
                    if self.family_evening and task.get_start_time() > self.midday:
                        points += 1
                    if self.family_start_of_week and task.get_start_datetime().weekday() <= self.midweek:
                        points += 1
                    if self.family_end_of_week and task.get_start_datetime().weekday() > self.midweek:
                        points += 1
                case TaskCategory.HOBBIES:
                    if self.hobbies_morning and task.get_end_time() <= self.midday:
                        points += 1
                    if self.hobbies_evening and task.get_start_time() > self.midday:
                        points += 1
                    if self.hobbies_start_of_week and task.get_start_datetime().weekday() <= self.midweek:
                        points += 1
                    if self.hobbies_end_of_week and task.get_start_datetime().weekday() > self.midweek:
                        points += 1
                case TaskCategory.MISCELLANEOUS:
                    if self.miscellaneous_morning and task.get_end_time() <= self.midday:
                        points += 1
                    if self.miscellaneous_evening and task.get_start_time() > self.midday:
                        points += 1
                    if self.miscellaneous_start_of_week and task.get_start_datetime().weekday() <= self.midweek:
                        points += 1
                    if self.miscellaneous_end_of_week and task.get_start_datetime().weekday() > self.midweek:
                        points += 1

        return points
            # print(f"NAME: {task.get_name()}, CATEGORY: {task.get_category()}")
