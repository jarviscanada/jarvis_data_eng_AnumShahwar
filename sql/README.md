# Introduction
The project is designed to pull out data based on what needs to be analyzed. This project consists of sample data from a country club that has three main tables. There are different queries performed to understand how the data can be leveraged to analyze the demand for their facilities along with their usage.

# ERD Diagram
![ERDtable](./assets/ERDtable.jpg)
## Table Set up DDL
```sql
CREATE TABLE cd.members
    (
       memid integer NOT NULL, 
       surname character varying(200) NOT NULL, 
       firstname character varying(200) NOT NULL, 
       address character varying(300) NOT NULL, 
       zipcode integer NOT NULL, 
       telephone character varying(20) NOT NULL, 
       recommendedby integer,
       joindate timestamp NOT NULL,
       CONSTRAINT members_pk PRIMARY KEY (memid),
       CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
            REFERENCES cd.members(memid) ON DELETE SET NULL
    );

CREATE TABLE cd.facilities
    (
       facid integer NOT NULL, 
       name character varying(100) NOT NULL, 
       membercost numeric NOT NULL, 
       guestcost numeric NOT NULL, 
       initialoutlay numeric NOT NULL, 
       monthlymaintenance numeric NOT NULL, 
       CONSTRAINT facilities_pk PRIMARY KEY (facid)
    );

 CREATE TABLE cd.bookings
    (
       bookid integer NOT NULL, 
       facid integer NOT NULL, 
       memid integer NOT NULL, 
       starttime timestamp NOT NULL,
       slots integer NOT NULL,
       CONSTRAINT bookings_pk PRIMARY KEY (bookid),
       CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
       CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
    );
```
# SQL Queries
All SQL queries are saved to [](queries.sql).
#### Question 1: The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values: facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
```sql
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa', 20, 30, 100000, 800);
```
#### Question 2: Add the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else: Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800
```sql
INSERT INTO cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    SELECT (SELECT MAX(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800;
```
#### Question 3: For the second tennis court, the initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
```sql
UPDATE cd.faciailites
SET initialoutlay = 10000
WHERE facid = 1;
 ```
#### Question 4: Alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.
```sql
UPDATE cd.facilities
SET membercost = (SELECT membercost FROM cd.facilities WHERE facid = 1) * 1.1,
    guestcost = (SELECT guestcost FROM cd.facilities WHERE facid = 1) * 1.1
    WHERE facid = 1;
```
#### Question 5: Delete all bookings from the cd.bookings table.
```sql
DELETE FROM cd.bookings;
```
#### Question 6: Remove member 37, who has never made a booking, from our database.
```sql
DELETE FROM cd.members
WHERE memid = 37;
```
#### Question 7: Produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost. Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.
```sql
SELECT facid, name, membercost, monthlymaintenance FROM cd.facilities
WHERE membercost > 0 and membercost < monthlymaintenance /50 ;
```
#### Question 8: Produce a list of all facilities with the word 'Tennis' in their name.
```sql
SELECT * FROM cd.facilities
WHERE name LIKE '%Tennis%';
```
#### Question 9: Retrieve the details of facilities with ID 1 and 5. Try to do it without using the OR operator.
```sql
SELECT * FROM cd.facilities
WHERE facid IN(1,5);
```
#### Question 10: Produce a list of members who joined after the start of September 2012. Return the memid, surname, firstname, and joindate of the members in question.
```sql
SELECT memid, surname, firstname, joindate FROM cd.members
WHERE joindate > '2012-09-01' ;
```
#### Question 11: Create a combined list of all surnames and all facility names.
```sql
SELECT surname from cd.members UNION SELECT name FROM cd.facilities;
```
#### Question 12: Produce a list of the start times for bookings by members named 'David Farrell'.
```sql
SELECT starttime FROM cd.bookings AS bookings
JOIN cd.members ON bookings.memid = members.memid
WHERE firstname = 'David' AND surname = 'Farrell';
```
#### Question 13: Produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'. Return a list of start time and facility name pairings, ordered by the time.
```sql
SELECT b.starttime, f.name AS facilityname FROM cd.bookings as b
JOIN cd.facilities AS f ON b.facid=f.facid
WHERE f.name LIKE '%Tennis Court%' AND date(b.starttime)='2012-09-21'
ORDER BY b.starttime ;
```
#### Question 14: Output a list of all members, including the individual who recommended them (if any). Ensure that results are ordered by (surname, firstname).
```sql
SELECT members.firstname as mfirstname, members.surname as msurname, recommendedby.firstname as rfirstname, recommendedby.surname as rsurname
FROM cd.members members
LEFT OUTER JOIN cd.members recommendedby ON recommendedby.memid = members.recommendedby
ORDER BY msurname, mfirstname;
```
#### Question 15: Output a list of all members who have recommended another member. Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
```sql
SELECT DISTINCT recommendedby.firstname as firstname, recommendedby.surname as surname
FROM cd.members members
INNER JOIN cd.members recommendedby ON recommendedby.memid = members.recommendedby
ORDER BY surname, firstname;
```
#### Question 16: Output a list of all members, including the individual who recommended them (if any), without using any joins. Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.
```sql
SELECT DISTINCT CONCAT(firstname, ' ', surname) AS members,
    (SELECT CONCAT(recs.firstname, ' ', recs.surname)
        FROM cd.members recs
        WHERE recs.memid = members.recommendedby) AS recommender
FROM cd.members
ORDER BY members;
```
#### Question 17: Produce a count of the number of recommendations each member has made. Order by member ID.
```sql
SELECT recommendedby AS number_of_recommendations, COUNT(*) FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;
```
#### Question 18: Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.
```sql
SELECT facid, SUM(slots) AS "Total Slots" FROM cd.bookings 
GROUP BY facid
ORDER BY facid;
```
#### Question 19: Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.
```sql
SELECT facid, SUM(slots) AS "Total Slots" FROM cd.bookings 
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY SUM(slots);
```
#### Question 20: Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.
```sql
SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots) AS total_slots FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;
```
#### Question 21: Find the total number of members (including guests) who have made at least one booking.
```sql
SELECT COUNT(DISTINCT memid) FROM cd.bookings;
```
#### Question 22: Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
```sql
SELECT m.surname, m.firstname, m.memid, MIN(bookings.starttime) AS starttime
FROM cd.bookings bookings
INNER JOIN cd.members m ON m.memid = bookings.memid
WHERE starttime >= '2012-09-01'
GROUP BY m.surname, m.firstname, m.memid
ORDER BY m.memid;
```
#### Question 23: Produce a list of member names, with each row containing the total member count. Order by join date and include guest members.
```sql
SELECT (SELECT COUNT(*) FROM cd.members), firstname, surname
FROM cd.members
ORDER BY joindate;
```
#### Question 24: Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.
```sql
SELECT row_number() over(ORDER BY joindate), firstname, surname FROM cd.members
ORDER BY joindate;
```
#### Question 25: Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.
```sql
SELECT facid, SUM(slots) AS Total_slots FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) = (SELECT MAX(sum2.Total_slots) FROM
		(SELECT SUM(slots) as Total_slots
		FROM cd.bookings
		GROUP BY facid) AS sum2);
```
#### Question 26: Output the names of all members, formatted as 'Surname, Firstname'.

```sql
SELECT CONCAT(surname, ', ', firstname) AS name FROM cd.members;
```
#### Question 27: Find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.

```sql
SELECT memid, telephone FROM cd.members
WHERE telephone LIKE '%(%' OR telephone LIKE '%)%'
ORDER BY memid;
```
#### Question 28: Produce a count of how many members you have whose surname starts with each letter of the alphabet. Sort by the letter, and don't worry about printing out a letter if the count is 0.
```sql
SELECT SUBSTR(surname,1,1) AS Letter, Count(*) AS Count FROM cd.members
GROUP BY letter
ORDER BY letter ;
```
