import math

class UserRequirements:

    def __init__(self,mon_start,mon_end,tue_start,tue_end,wed_start,wed_end,thu_start,
                thu_end,fri_start,fri_end,sat_start,sat_end,sun_start,sun_end):

        self.mon_start = mon_start
        self.mon_end = mon_end
        self.tue_start = tue_start
        self.tue_end = tue_end
        self.wed_start = wed_start
        self.wed_end = wed_end
        self.thu_start = thu_start
        self.thu_end = thu_end
        self.fri_start = fri_start
        self.fri_end = fri_end
        self.sat_start = sat_start
        self.sat_end = sat_end
        self.sun_start = sun_start
        self.sun_end = sun_end

    def get_avg_daily_availability(self):
        return math.ceil(((self.mon_end - self.mon_start) + (self.tue_end - self.tue_start) + 
                        (self.wed_end - self.wed_start) + (self.thu_end - self.thu_start) + 
                        (self.fri_end - self.fri_start) + (self.sat_end - self.sat_start) + 
                        (self.sun_end - self.sun_start)) / 7)
    
    def get_daily_availability(self,day):
        match day:
            case 0:
                return self.getMondayAvailability()
            case 1:
                return self.getTuesdayAvailability()
            case 2:
                return self.getWednesdayAvailability()
            case 3:
                return self.getThursdayAvailability()
            case 4:
                return self.getFridayAvailability()
            case 5: 
                return self.getSaturdayAvailability()
            case 6:
                print("SUNDAY")
                return self.getSundayAvailability()

    def get_current_day_start(self,day):
         match day:
            case 0:
                return self.mon_start
            case 1:
                return self.tue_start
            case 2:
                return self.wed_start
            case 3:
                return self.thu_start
            case 4:
                return self.fri_start
            case 5: 
                return self.sat_start
            case 6:
                return self.sun_start
    
    def get_current_day_end(self,day):
         match day:
            case 0:
                return self.mon_end
            case 1:
                return self.tue_end
            case 2:
                return self.wed_end
            case 3:
                return self.thu_end
            case 4:
                return self.fri_end
            case 5: 
                return self.sat_end
            case 6:
                return self.sun_end

    # def getMondayAvailability(self):
    #     return math.ceil(self.mon_end - self.mon_start)

    # def getTuesdayAvailability(self):
    #     return math.ceil(self.tue_end - self.tue_start)

    # def getWednesdayAvailability(self):
    #     return math.ceil(self.wed_end - self.wed_start)

    # def getThursdayAvailability(self):
    #     return math.ceil(self.thu_end - self.thu_start)

    # def getFridayAvailability(self):
    #     return math.ceil(self.fri_end - self.fri_start)

    # def getSaturdayAvailability(self):
    #     return math.ceil(self.sat_end - self.sat_start)

    # def getSundayAvailability(self):
    #     return math.ceil(self.sun_end - self.sun_start)
