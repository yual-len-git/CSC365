import sys
import os

# data = []
# file = open(sys.argv[1], "r")
# data.append(sys.argv[1][:-4])
# file.close()

# print(data)




def getData(dList):
    file = open(sys.argv[1], "r")
    dList.append(sys.argv[1][:-4])
    for line in file:
        line = line.strip().split(",")
        dList.append(line)
        print(line)
    file.close()


def is_float(element):
    try:
        float(element)
        return True
    except ValueError:
        return False
# INSERT INTO Customer (Name, Zip_Code) VALUES ('Cust A', '93405');
# INSERT INTO Customer (Name, Zip_Code) VALUES ('Cust B', '93405');

# INSERT INTO Customer (Name, Zip_Code) VALUES (


def main():
    data = []
    getData(data)
    itext = "INSERT INTO "
    values = "VALUES"

    # for file name on write out
    title = sys.argv[2].upper() + "-populate.sql"

    insertStr = itext + data[0] + " ("

    for value in data[1]:
        insertStr += value + ", "
    
    insertStr = insertStr[:-2] + ") VALUES ("
   
    f = open(title, "a")

    for line in data[2:]:
        insertValue = insertStr
        for value in line:
            value = value.strip() #replace(" ","")
            # print(is_float(value))
            if (is_float(value) or value.isdecimal()):
                insertValue += value + ", "
            else:
                insertValue += "\"" + value.strip() + "\", "
        if (is_float(value) or value.isdecimal()):
            insertValue = insertValue[:-2] + ");"
        else:
            insertValue = insertValue[:-3] + "\");"
        print(insertValue)
        f.write(insertValue + "\n")
    
    f.close()



if __name__ == "__main__":
    main()