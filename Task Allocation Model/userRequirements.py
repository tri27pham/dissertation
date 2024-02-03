import math

class UserRequirements:

    def __init__(self,monStart,monEnd,tueStart,tueEnd,wedStart,wedEnd,thuStart,
                thuEnd,friStart,friEnd,satStart,satEnd,sunStart,sunEnd):

        self.monStart = monStart
        self.monEnd = monEnd
        self.tueStart = tueStart
        self.tueEnd = tueEnd
        self.wedStart = wedStart
        self.wedEnd = wedEnd
        self.thuStart = thuStart
        self.thuEnd = thuEnd
        self.friStart = friStart
        self.friEnd = friEnd
        self.satStart = satStart
        self.satEnd = satEnd
        self.sunStart = sunStart
        self.sunEnd = sunEnd

    def getAvgDailyAvailability():
        return math.ceil(((self.monEnd - self.monStart) + (self.tueEnd - self.tueStart) + 
                        (self.wedEnd - self.wedStart) + (self.thuEnd - self.thuStart) + 
                        (self.friEnd - self.friStart) + (self.satEnd - self.satStart) + 
                        (self.sunEnd - self.sunStart)) / 7)
    
    def getDailyAvailability(self,day):
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
                print("SATURDAY")
                return self.getSaturdayAvailability()
            case 6:
                return self.getSundayAvailability()


    def getMondayAvailability(self):
        return math.ceil(self.monEnd - self.monStart)

    def getTuesdayAvailability(self):
        return math.ceil(self.tueEnd - self.tueStart)

    def getWednesdayAvailability(self):
        return math.ceil(self.wedEnd - self.wedStart)

    def getThursdayAvailability(self):
        return math.ceil(self.thuEnd - self.thuStart)

    def getFridayAvailability(self):
        return math.ceil(self.friEnd - self.friStart)

    def getSaturdayAvailability(self):
        return math.ceil(self.satEnd - self.satStart)

    def getSundayAvailability(self):
        return math.ceil(self.sunEnd - self.sunStart)