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

def home():
    print("Enter S[tudent] to search by student last name.")
    print("Enter T[eacher] to search by teacher last name.")
    print("Enter G[rade] to search by grade number.")
    print("Enter B[us] to search by bus route number.")
    print("Enter A[verage] to search for the average GPA of the grade.")
    print("Enter I[nfo] for school student info.")
    print("Enter Q[uit] to end program.")

def searchLastName(sList, last):
    for student in sList:
        if student.stLast == last:
            print(student.stLast + " " + student.stFirst + " " + student.grade + " " + student.room + " " + student.tLast + " " + student.tFirst)

def info(sList):
    count = 0
    for student in sList:
        count+=1

    print()


def main():
    studentList = []
    getData(studentList)

    # for student in studentList:
    #     if student.tFirst == "PERLA":
    #         print(student.stFirst + " " + student.stLast)

    # while True:
    home()
    # searchLastName(studentList, "LINHART")



if __name__ == "__main__":
    main()