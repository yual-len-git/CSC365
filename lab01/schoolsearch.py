import sys

class students:
    def __init__(self, stLast, stFirst, grade, room, bus, gpa, tLast, tFirst):
        self.stLast = stLast        #[0]
        self.stFirst = stFirst      #[1]
        self.grade = grade          #[2]
        self.room = room            #[3]
        self.bus = bus              #[4]
        self.gpa = gpa              #[5]
        self.tLast = tLast          #[6]
        self.tFirst = tFirst        #[7]


def getData(sList):
    file = open(sys.argv[1], "r")
    for line in file:
        line = line.strip().split(",")
        sList.append(students(line[0],line[1],line[2],line[3],line[4],line[5],line[6],line[7]))
    return sList






def main():
    studentList = []
    getData(studentList)

    for student in studentList:
        if student.tFirst == "PERLA":
            print(student.stFirst + " " + student.stLast)



if __name__ == "__main__":
    main()