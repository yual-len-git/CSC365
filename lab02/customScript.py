import sys
import os

def getData(dList):
    file = open(sys.argv[1], "r")
    # dList.append(sys.argv[1][:-4])
    for line in file:
        line = line.strip().split(";")
        dList.append(line)
        # print(line)
    file.close()



# INSERT INTO Customer (Name, Zip_Code) VALUES ('Cust A', '93405');
# INSERT INTO Customer (Name, Zip_Code) VALUES ('Cust B', '93405');

# INSERT INTO Customer (Name, Zip_Code) VALUES (


def main():
    data = []
    getData(data)
    itext = "INSERT INTO "
    values = "VALUES ("

    data[0].pop()
    data[-1].pop()
    data = list(filter(None, data))
    for line in data:
        print(line)

    # for file name on write out
    title = sys.argv[2].upper() + "-populate.sql"


    insertp = itext + "players" + " (" + data[0][0] + ", " + data[0][1] + ", " + data[0][2] + ") " + values
    inserts = itext + "stats" + " (" + data[0][0] + ", " + data[0][5] + ", " + data[0][4] + ", " + data[0][7] + ") " + values
    insertt = itext + "teams" + " (" + data[0][1] + ", " + data[0][8] + ", " + data[0][3] + ", " + data[0][6] + ") " + values
   
    f = open(title, "a")

    for line in data[1:]:
        Pinsert = insertp + line[0] + ", '" + line[1] + "', '" + line[2] + "');"
        # print (Pinsert)
        f.write(Pinsert + "\n")

    for line in data[1:]:
        Sinsert = inserts + line[0] + ", " + line[5] + ", " + line[4] + ", " + line[7] + ");"
        # print(Sinsert)
        f.write(Sinsert + "\n")

    for line in data[1:]:
        Tinsert = insertt + "'" + line[1] + "', " + line[8] + ", '" + line[3] + "', " + line[6] + ");"
        # print(Tinsert)
        f.write(Tinsert + "\n")


    
    f.close()



if __name__ == "__main__":
    main()