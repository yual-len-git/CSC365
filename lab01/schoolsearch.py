import sys
import os

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
    if os.path.exists("students.txt"):
        file = open("./students.txt", "r")
        for line in file:
            line = line.strip().split(",")
            sList.append(students(line[0],line[1],line[2],line[3],line[4],line[5],line[6],line[7]))
        return True
    else:
        return False

def home():
    print("Enter S[tudent] to search by student last name. Enter a B[us] for additional info.")
    print("Enter T[eacher] to search by teacher last name.")
    print("Enter G[rade] to search by grade number. Enter H[igh] or L[ow] for highest or lowest GPA student")
    print("Enter B[us] to search by bus route number.")
    print("Enter A[verage] to search for the average GPA of the grade.")
    print("Enter I[nfo] for school student info.")
    print("Enter Q[uit] to end program.")
    print("All entries are case sensitive.")
    print("Make sure to include space for selections with additional options.")

def searchLastName(sList, last):
    print("\nStudent   Grade Classroom Teacher")
    print("---------------------------------------------")
    for student in sList:
        if student.stLast == last:
            print(student.stLast + " " + student.stFirst + " " + student.grade + " " + student.room + " " + student.tLast + " " + student.tFirst)

def searchTeacher(sList, last):
    print("\nStudent")
    print("---------------------------------------------")
    for student in sList:
        if student.tLast == last:
            print(student.stLast + " " + student.stFirst)

def searchGrade(sList, num):
    print("\nStudent")
    print("---------------------------------------------")
    for student in sList:
        if student.grade == num:
            print(student.stLast + " " + student.stFirst)

def searchBus(sList, num):
    print("\nStudent   Grade Classroom")
    print("---------------------------------------------")
    for student in sList:
        if student.bus == num:
            print(student.stLast + " " + student.stFirst + " " + student.grade + " " + student.room)

def searchAverage(sList, num):
    print("\nGrade GPA")
    print("---------------------------------------------")
    count = 0
    gpa = 0
    for student in sList:
        if student.grade == num:
            count+=1
            gpa += float(student.gpa)
    average_gpa = round(gpa / count, 2)
    print(num + " " + str(average_gpa))

def searchNameBus(sList, last):
    print("\nStudent   Bus")
    print("---------------------------------------------")
    for student in sList:
        if student.stLast == last:
            print(student.stLast + " " + student.stFirst + " " + student.bus)

def searchHighGrade(sList, num):
    print("\nStudent    GPA  Teacher    Bus")
    print("---------------------------------------------")
    highest = students("0","0","0","0","0","0","0","0")
    for student in sList:
        if student.grade == num:
            if float(student.gpa) > float(highest.gpa):
                highest = student
    print(highest.stLast + " " + highest.stFirst + " " + highest.gpa + " " + highest.tLast + " " + highest.tFirst + " " + highest.bus)

def searchLowGrade(sList, num):
    print("\nStudent    GPA   Teacher    Bus")
    print("---------------------------------------------")
    lowest = students("4","4","4","4","4","4","4","4")
    for student in sList:
        if student.grade == num:
            if float(student.gpa) < float(lowest.gpa):
                lowest = student
    print(lowest.stLast + " " + lowest.stFirst + " " + lowest.gpa + " " + lowest.tLast + " " + lowest.tFirst + " " + lowest.bus)

def info(sList):
    print("\nGrade    Number of Students")
    print("---------------------------------------------")
    grade_count = [0] * 7
    for student in sList:
        grade_count[int(student.grade)] += 1
    for num in grade_count:
        print(str(grade_count.index(num)) + ": " + str(num))


def main():
    studentList = []
    if getData(studentList) == False:
        print("Error file \"students.txt\" not found.")
        return

    while True:
        home()
        user_in = input("Select option:")
        if user_in == 'S' or user_in == 'Student':
            last_in = input("Input student's last name(names will be automatically capitalized):")
            last_in = last_in.upper()
            searchLastName(studentList, last_in)
        elif user_in == 'T' or user_in == 'Teacher':
            tLast = input("Input teacher's last name(names will be automatically capitalized):")
            tLast = tLast.upper()
            searchTeacher(studentList, tLast)
        elif user_in == 'G' or user_in == 'Grade':
            grade_in = input("Input student's grade level(Enter a integer):")
            searchGrade(studentList, grade_in)
        elif user_in == 'B' or user_in == 'Bus':
            bus_in = input("Input student bus route(Enter a integer):")
            searchBus(studentList, bus_in)
        elif user_in == 'A' or user_in == 'Average':
            avg_in = input("Enter grade to find average GPA of the grade(Enter a integer):")
            searchAverage(studentList, avg_in)
        elif user_in == 'I' or user_in == 'Info':
            info(studentList)
        elif user_in == 'Q' or user_in == 'Quit':
            print("Ending Program")
            break
        elif user_in == "S B" or user_in == "Student Bus" or user_in == "S Bus" or user_in == "Student B":
            last_in = input("Input student's last name(names will be automatically capitalized):")
            last_in = last_in.upper()
            searchNameBus(studentList, last_in)
        elif user_in == 'G H' or user_in == 'Grade High' or user_in == 'G High' or user_in == 'Grade H':
            grade_in = input("Input student's grade level(Enter a integer):")
            searchHighGrade(studentList, grade_in)
        elif user_in == 'G L' or user_in == 'Grade Low' or user_in == 'G Low' or user_in == 'Grade L':
            grade_in = input("Input student's grade level(Enter a integer):")
            searchLowGrade(studentList, grade_in)
        print("")




if __name__ == "__main__":
    main()