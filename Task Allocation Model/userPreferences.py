from taskCategoryEnum import TaskCategory
from datetime import datetime, timedelta, time

class UserPreferences:

    # def __init__(university_morning,university_evening,university_start_of_week,etc.):

    def __init__(self):

        # self.midday = datetime.time(12, 0)
        self.midday = datetime.combine(datetime.today(), datetime.min.time()).replace(hour=12, minute=0, second=0).time()
        self.midweek = 3

        self.university_morning = True
        self.university_evening = False
        self.university_start_of_week = True
        self.university_end_of_week = False

        self.work_morning = False
        self.work_evening = True
        self.work_start_of_week = False
        self.work_end_of_week = False

        self.health_morning = True
        self.health_evening = False
        self.health_start_of_week = False
        self.health_end_of_week = False
        
        self.social_morning = False
        self.social_evening = False
        self.social_start_of_week = True
        self.social_end_of_week = False

        self.family_morning = False
        self.family_evening = False
        self.family_start_of_week = False
        self.family_end_of_week = False

        self.hobbies_morning = False
        self.hobbies_evening= False
        self.hobbies_start_of_week = False
        self.hobbies_end_of_week = False      

        self.miscellaneous_morning = True
        self.miscellaneous_evening= False
        self.miscellaneous_start_of_week = False
        self.miscellaneous_end_of_week = True      

    def get_preferences_satisfied(self,tasks):

        points = 0

        for task in tasks:
            
            match task.get_category():
                case TaskCategory.UNIVERSITY:
                    # print(task.get_name())
                    # print(task.get_end_time().time())
                    if self.university_morning and task.get_end_time().time() <= self.midday:
                        points += 1
                    if self.university_evening and task.get_start_time().time() > self.midday:
                        points += 1
                    if self.university_start_of_week and task.get_start_time().weekday() <= self.midweek:
                        points += 1
                    if self.university_end_of_week and task.get_start_time().weekday() > self.midweek:
                        points += 1
                case TaskCategory.WORK:
                    if self.work_morning and task.get_end_time().time() <= self.midday:
                        points += 1
                    if self.work_evening and task.get_start_time().time() > self.midday:
                        points += 1
                    if self.work_start_of_week and task.get_start_time().weekday() <= self.midweek:
                        points += 1
                    if self.work_end_of_week and task.get_start_time().weekday() > self.midweek:
                        points += 1
                case TaskCategory.HEALTH:
                    if self.health_morning and task.get_end_time().time() <= self.midday:
                        points += 1
                    if self.health_evening and task.get_start_time().time() > self.midday:
                        points += 1
                    if self.health_start_of_week and task.get_start_time().weekday() <= self.midweek:
                        points += 1
                    if self.health_end_of_week and task.get_start_time().weekday() > self.midweek:
                        points += 1
                case TaskCategory.SOCIAL:
                    if self.social_morning and task.get_end_time().time() <= self.midday:
                        points += 1
                    if self.social_evening and task.get_start_time().time() > self.midday:
                        points += 1
                    if self.social_start_of_week and task.get_start_time().weekday() <= self.midweek:
                        points += 1
                    if self.social_end_of_week and task.get_start_time().weekday() > self.midweek:
                        points += 1
                case TaskCategory.FAMILY:
                    if self.family_morning and task.get_end_time().time() <= self.midday:
                        points += 1
                    if self.family_evening and task.get_start_time().time() > self.midday:
                        points += 1
                    if self.family_start_of_week and task.get_start_time().weekday() <= self.midweek:
                        points += 1
                    if self.family_end_of_week and task.get_start_time().weekday() > self.midweek:
                        points += 1
                case TaskCategory.HOBBIES:
                    if self.hobbies_morning and task.get_end_time().time() <= self.midday:
                        points += 1
                    if self.hobbies_evening and task.get_start_time().time() > self.midday:
                        points += 1
                    if self.hobbies_start_of_week and task.get_start_time().weekday() <= self.midweek:
                        points += 1
                    if self.hobbies_end_of_week and task.get_start_time().weekday() > self.midweek:
                        points += 1
                case TaskCategory.MISCELLANEOUS:
                    if self.miscellaneous_morning and task.get_end_time().time() <= self.midday:
                        points += 1
                    if self.miscellaneous_evening and task.get_start_time().time() > self.midday:
                        points += 1
                    if self.miscellaneous_start_of_week and task.get_start_time().weekday() <= self.midweek:
                        points += 1
                    if self.miscellaneous_end_of_week and task.get_start_time().weekday() > self.midweek:
                        points += 1

        return points
            # print(f"NAME: {task.get_name()}, CATEGORY: {task.get_category()}")
