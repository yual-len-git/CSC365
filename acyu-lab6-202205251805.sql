-- Lab 6
-- acyu
-- May 25, 2022

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
select customers.FirstName, customers.LastName
from (
        select distinct receipts.Customer from receipts
        where receipts.Customer not in
        (
            select receipts.Customer from receipts
            where receipts.SaleDate >= "2007-10-05" and receipts.SaleDate <= "2007-10-11"
            order by receipts.Customer
        )
) as cust

join customers on customers.CId = cust.Customer
order by customers.LastName;


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
with mostSpent as
(
    select receipts.Customer, customers.FirstName, customers.LastName, sum(goods.Price) as MoneySpent from receipts 
    join items on items.Receipt = receipts.RNumber
    join goods on goods.GId = items.Item
    join customers on customers.CId = receipts.Customer
    where (receipts.SaleDate >= '2007-10-01') and (receipts.SaleDate <= '2007-10-31')
    group by receipts.Customer
)
select mostSpent.FirstName, mostSpent.Lastname, round(MoneySpent, 2)
from mostSpent
where MoneySpent = (select max(mostSpent.MoneySpent) from mostSpent);


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

with Twist as
(
select * from receipts
join items on items.Receipt = receipts.RNumber
join goods on goods.GId = items.Item
join customers on customers.CId = receipts.Customer
where (receipts.SaleDate >= '2007-10-01') and (receipts.SaleDate <= '2007-10-31')
)

select distinct Twist.FirstName, Twist.LastName from Twist
where Twist.Customer not in
(
select distinct Twist.Customer from Twist
where Twist.Food = 'Twist'
)
order by Twist.LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find the baked good(s) (flavor and food type) responsible for the most total revenue.
with BakedGoods as
(
select goods.Food, goods.Flavor, sum(goods.Price) as Price
from receipts
join items on items.Receipt = receipts.RNumber
join goods on goods.GID = items.Item
group by goods.Food, goods.Flavor
)

select BakedGoods.Flavor, BakedGoods.Food from BakedGoods
where BakedGoods.Price = (select max(BakedGoods.Price) from BakedGoods);


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (flavor and food) and total quantity sold.
with Sales as
(
select  goods.Flavor, goods.Food, count(*) as sold from receipts
join items on items.Receipt = receipts.RNumber
join goods on goods.GId = items.Item
group by goods.Food, goods.Flavor
)

select Sales.Flavor, Sales.Food, Sales.sold from Sales
where Sales.sold = (select max(Sales.sold) from Sales);


USE `BAKERY`;
-- BAKERY-6
-- Find the date(s) of highest revenue during the month of October, 2007. In case of tie, sort chronologically.
with Revenue as
(
select receipts.SaleDate, sum(goods.Price) as sales from receipts
join items on items.Receipt = receipts.RNumber
join goods on goods.GId = items.Item
where (receipts.SaleDate >= '2007-10-01') and (receipts.SaleDate <= '2007-10-31')
group by receipts.SaleDate
)

select Revenue.SaleDate from Revenue
where Revenue.sales = (select max(Revenue.sales) from Revenue);


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item(s) (by number of purchases) on the day(s) of highest revenue in October of 2007.  Report flavor, food, and quantity sold. Sort by flavor and food.
-- No attempt


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the quantity purchased. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
with Cake as
(
select customers.FirstName, customers.LastName, goods.Flavor, goods.Food, receipts.Customer, count(*) as purchases from receipts
join customers on customers.CId = receipts.Customer
join items on items.Receipt = receipts.RNumber
join goods on goods.GId = items.Item
where goods.Food = 'Cake' and receipts.SaleDate >= '2007-10-01' and receipts.Saledate <= '2007-10-31'
group by goods.Food, goods.Flavor, receipts.Customer
)

select cust.Flavor, cust.Food, cust.FirstName, cust.LastName, cust.purchases from Cake as cust
where cust.purchases =
(
select max(cust2.purchases) from Cake as cust2
where cust.Flavor = cust2.Flavor
)
order by cust.purchases desc, cust.LastName, cust.Flavor;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (last, first) of the customers and the *earliest* day in October on which they made a purchase, sorted in chronological order, then by last name.

-- No attempt


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

-- No attempt


USE `INN`;
-- INN-1
-- Find the most popular room(s) (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room, report all such rooms). Report the full name of the room, the room code and the number of reservations.

with RoomRes as
(
select reservations.Room, rooms.RoomName, count(reservations.Code) as ResCount from reservations
join rooms on rooms.RoomCode = reservations.Room
group by reservations.Room
)

select RoomRes.RoomName, RoomRes.Room, RoomRes.ResCount from RoomRes
where RoomRes.ResCount = (select max(RoomRes.ResCount) from RoomRes);


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
with roomRes as 
(
select reservations.Room, rooms.RoomName, DateDiff(reservations.CheckIn, reservations.CheckOut) as numRes from reservations
join rooms on rooms.RoomCode = reservations.Room
group by reservations.Room, reservations.CheckIn, reservations.CheckOut
),

Occupied as
(
select roomRes.Room, roomRes.RoomName, sum(roomRes.numRes) as numberDays from roomRes
group by roomRes.Room
)

select Occupied.RoomName, Occupied.Room, Occupied.numberDays from Occupied
where Occupied.numberDays = (select max(Occupied.numberDays) from Occupied);


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid (rounded to the nearest penny.) Sort the output in descending order by total amount paid.
-- No attempt


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
-- No attempt


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month name, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
-- No attempt


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) with the largest number of students. Report the name of the teacher(s) (last, first) and the number of students in their class.

with Class as
(
select teachers.Last, teachers.First, count(*) as Students from teachers
join list on list.classroom = teachers.classroom
group by teachers.Last, teachers.First
)

select * from Class
where Class.Students = (select max(Class.Students) from Class);


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students. In case of tie, sort by grade number.
with Class as
(
select list.grade, count(*) as Students from teachers
join list on list.classroom = teachers.classroom
where list.LastName like 'A%' or list.LastName like 'B%' or list.LastName like 'C%'
group by list.grade
)

select * from Class
where Class.Students = (select max(Class.Students) from Class);


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers and the number of student in each classroom. Sort in ascending order by classroom.
with stuClass as
(
select teachers.classroom, count(*) as numStudents from teachers
join list on list.classroom = teachers.classroom
group by teachers.classroom
)

select * from stuClass
where stuClass.numStudents < (select avg(stuClass.numStudents) from stuClass);


USE `STUDENTS`;
-- STUDENTS-4
-- Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
with stuClass as
(
select teachers.classroom, count(*) as pairs from teachers
join list on list.classroom = teachers.classroom
group by teachers.classroom
),

pairClass as
(
select p1.classroom as c1, p2.classroom as c2, p1.pairs
from stuClass as p1
join stuClass as p2 on p1.classroom < p2.classroom
and p1.pairs = p2.pairs
order by p1.pairs
)

select * from pairClass;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the grade and the last name of the teacher who teaches the classroom with the largest number of students in the grade. Output results in ascending order by grade.
with Classes as
(
    select list.grade, count(distinct teachers.classroom) as NumClassrooms
    from teachers
    join list on list.classroom = teachers.classroom
    group by list.grade
)

with StudentsTaught as
(
    select list.grade, teachers.Last, teachers.First, count(*) as Students
    from teachers
    join list on list.classroom = teachers.classroom
    group by teachers.Last, teachers.First, list.grade
)

with MoreThanOneRoom as
(
    select *
    from StudentsTaught
    where StudentsTaught.grade in
    (
        select Classes.grade
        from Classes
        where Classes.NumClassrooms >= 2
    )
);


USE `CSU`;
-- CSU-1
-- Find the campus(es) with the largest enrollment in 2000. Output the name of the campus and the enrollment. Sort by campus name.

select campuses.Campus, enrollments.Enrolled from enrollments
join campuses on campuses.Id = enrollments.CampusId
where enrollments.year = 2000 and enrollments.Enrolled =
(
select max(enrollments.Enrolled) from enrollments
where enrollments.Year = 2000
);


USE `CSU`;
-- CSU-2
-- Find the university (or universities) that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university, sorted alphabetically.

with Graduated as
(
select degrees.CampusId, campuses.Campus, sum(degrees.degrees) as granted from degrees
join campuses on campuses.Id = degrees.CampusId
group by degrees.CampusId
)

select Graduated.Campus from Graduated
where Graduated.granted = (select max(Graduated.Granted) from Graduated);


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment. In case of tie, sort by campus name.
with Enrollment as
(
select campuses.Campus, enrollments.FTE / faculty.FTE as ratio from campuses
join faculty on faculty.CampusId = campuses.Id
join enrollments on enrollments.CampusId = campuses.Id and enrollments.Year = faculty.Year
where enrollments.Year = 2003
)

select Enrollment.campus, round(Enrollment.ratio, 1) as studFac from Enrollment
where Enrollment.ratio = (select min(Enrollment.ratio) from Enrollment);


USE `CSU`;
-- CSU-4
-- Among undergraduates studying 'Computer and Info. Sciences' in the year 2004, find the university with the highest percentage of these students (base percentages on the total from the enrollments table). Output the name of the campus and the percent of these undergraduate students on campus. In case of tie, sort by campus name.
with CIS as
(
select campuses.Campus, discEnr.Ug / enrollments.Enrolled as ratio from campuses
join discEnr on discEnr.CampusId = campuses.Id
join enrollments on enrollments.CampusId = campuses.Id
join disciplines on disciplines.Id = discEnr.Discipline
where discEnr.Year = 2004 and enrollments.Year = 2004 and disciplines.Name = 'Computer and Info. Sciences'
)

select CIS.Campus, round(CIS.ratio * 100, 1) as percent from CIS
where CIS.ratio = (select max(CIS.ratio) from CIS);


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the year, the name of the campuses, and the ratio. List in chronological order.
with Enrolled as
(
select enrollments.Year, campuses.Campus, (degrees.degrees / enrollments.Enrolled) as ratio from degrees
join campuses on campuses.Id = degrees.CampusId
join enrollments on enrollments.CampusId = campuses.Id and enrollments.year = degrees.year
where (degrees.year > 1996 and degrees.year < 2004) and (enrollments.year > 1996 and enrollments.year < 2004)
)

select * from Enrolled as e1
where e1.ratio =
(
select max(e2.ratio) from Enrolled as e2
where e1.Year = e2.Year
)
order by e1.Year;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the highest student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios and round to two decimal places.
with Enrollments as
(
select campuses.Campus, enrollments.Year, max(enrollments.FTE / faculty.FTE) as ratio from campuses
join faculty on faculty.CampusId = campuses.Id
join enrollments on enrollments.CampusId = campuses.Id and enrollments.Year = faculty.Year
group by enrollments.Year, campuses.Campus
)

select e1.Campus, e1.Year, round(e1.ratio, 2) from Enrollments as e1
where e1.ratio =
(
select max(e2.ratio) from Enrollments as e2
where e1.Campus = e2.Campus
)
order by e1.Campus;


USE `CSU`;
-- CSU-7
-- For each year for which the data is available, report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

with Enrollments as
(
select campuses.Campus, enrollments.Year, max(enrollments.FTE / faculty.FTE) as ratio from campuses
join faculty on faculty.CampusId = campuses.Id
join enrollments on enrollments.CampusId = campuses.Id and enrollments.Year = faculty.Year
group by enrollments.Year, campuses.Campus
)
select e1.Year + 1, count(*) from Enrollments as e1
where e1.ratio <
(
select max(e2.ratio) from Enrollments as e2
where e1.Campus = e2.Campus and e1.Year + 1 = e2.Year
)

group by (e1.Year + 1)
order by (e1.Year + 1);


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

with Runners as
(
select marathon.state, count(*) as number from marathon
group by marathon.State
)

select Runners.State from Runners
where Runners.number = (select max(Runners.number) from Runners)
order by Runners.State;


USE `MARATHON`;
-- MARATHON-2
-- Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Include only those towns that fielded at least 1 male runner and at least 1 female runner. Report the names of towns, sorted alphabetically.

with Females as
(
select marathon.Town, count(*) as fRunners from marathon
where marathon.Sex = 'F' and marathon.State = 'RI'
group by marathon.Town
),

Males as 
(
select marathon.Town, count(*) as mRunners from marathon
where marathon.Sex = 'M' and marathon.State = 'RI'
group by marathon.Town
)

select Females.Town from Females
join Males on Males.Town = Females.Town
where mRunners < fRunners
order by Females.Town;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
with Runners as
(
select marathon.State, marathon.Sex, marathon.AgeGroup, count(*) as participants from marathon
group by marathon.State, marathon.Sex, marathon.AgeGroup
)

select p1.State, p1.AgeGroup, p1.Sex, p1.participants from Runners as p1
where p1.participants =
(
select max(p2.participants) from Runners as p2
where p1.State = p2.State
)
and p1.participants > 1
order by p1.State, p1.AgeGroup, p1.Sex;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
select runner1.Place, runner1.FirstName, runner1.LastName from marathon as runner1
where runner1.sex = 'F' and
(
select count(*) from marathon as runners
where sex = 'F' and runner1.Place > runners.Place
) = 29

group by runner1.Place;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

-- No attempt


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

select Band.FirstName from Band
where Band.Id not in
(
select distinct Instruments.Bandmate from Instruments
where Instruments.Instrument = 'accordion'
);


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

select Songs.Title from Songs
where Songs.SongId not in
(select distinct Vocals.Song from Vocals)
order by Songs.Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
with NumInstruments as
(
select Songs.SongId, Songs.Title, count(Instruments.Instrument) as InstrPlayed from Songs
join Instruments on Instruments.Song = SongId
group by Instruments.Song
)

select NumInstruments.Title from NumInstruments
where NumInstruments.InstrPlayed = (select max(NumInstruments.InstrPlayed) from NumInstruments);


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument, and the number of songs on which the performer played that instrument. Sort in alphabetical order by the first name, then instrument.

with favInstr as
(
select Band.Id, Instruments.Instrument, Band.Firstname, count(*) as numSongs from Band
join Instruments on Instruments.Bandmate = Band.Id
group by Band.Id, Instruments.Instrument
)

select perf.Firstname, perf.Instrument, perf.numSongs from favInstr as perf
where perf.numSongs =
(
select max(perf2.numSongs) from favInstr as perf2
where perf.Id = perf2.id
)

order by perf.Firstname, perf.Instrument, perf.numSongs;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instrument names in alphabetical order.
with Anne as
(
select Instruments.Instrument from Band
join Instruments on Instruments.Bandmate = Band.Id
where Band.Firstname = 'Anne-Marit'
)

select * from Anne
where Instrument not in
(
select Instruments.Instrument from Band
join Instruments on Instruments.Bandmate = Band.Id
where Band.Firstname != 'Anne-Marit'
)
order by Anne.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report, in alphabetical order, the first name(s) of the performer(s) who played the largest number of different instruments.

with perInstr as
(
select Band.Id, Band.Firstname, count(distinct Instruments.Instrument) as numInstr from Band
join Instruments on Instruments.Bandmate = Band.Id
group by Band.Id
)

select perInstr.Firstname from perInstr
where perInstr.numInstr = (select max(perInstr.numInstr) from perInstr)
order by perInstr.Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments, sorted alphabetically (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
With numInstr as
(
select Instruments.Instrument, count(Instruments.Song) as Songs from Instruments
join Songs on Songs.SongId = Instruments.Song
group by Instruments.Instrument
)

select numInstr.Instrument from numInstr
where numInstr.Songs = (select max(numInstr.Songs) from numInstr);


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s), sorted in alphabetical order.

with CentPer as
(
select Band.Firstname, Performance.Bandmate, count(*) as Center from Performance
join Band on Band.Id = Performance.Bandmate
where Performance.StagePosition = 'center'
group by Performance.Bandmate
)

select CentPer.Firstname from CentPer
where CentPer.Center = (select max(CentPer.Center) from CentPer)
order by CentPer.Firstname;


