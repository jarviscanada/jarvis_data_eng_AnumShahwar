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

   1.
   INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
   VALUES (9, 'Spa', 20, 30, 100000, 800);

   2.
   INSERT INTO cd.facilities
       (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
       SELECT (SELECT MAX(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800;

   3.
   UPDATE cd.faciailites
   SET initialoutlay = 10000
   WHERE facid = 1;

   4.
   UPDATE cd.facilities
   SET membercost = (SELECT membercost FROM cd.facilities WHERE facid = 1) * 1.1,
       guestcost = (SELECT guestcost FROM cd.facilities WHERE facid = 1) * 1.1
       WHERE facid = 1;

   5.
   DELETE FROM cd.bookings;

   6.
   DELETE FROM cd.members
   WHERE memid = 37

   7.
   SELECT facid, name, membercost, monthlymaintenance FROM cd.facilities
   WHERE membercost > 0 and membercost < monthlymaintenance /50 ;


   8.
   SELECT * FROM cd.facilities
   WHERE name LIKE '%Tennis%';

   9.
   SELECT * FROM cd.facilities
   WHERE facid IN(1,5);

   10.
   SELECT memid, surname, firstname, joindate FROM cd.members
   WHERE joindate > '2012-09-01' ;

   11.
   SELECT surname from cd.members UNION SELECT name FROM cd.facilities;

   12.
   SELECT starttime FROM cd.bookings AS bookings
   JOIN cd.members ON bookings.memid = members.memid
   WHERE firstname = 'David' AND surname = 'Farrell';

   13.
   SELECT b.starttime, f.name AS facilityname FROM cd.bookings as b
   JOIN cd.facilities AS f ON b.facid=f.facid
   WHERE f.name LIKE '%Tennis Court%' AND date(b.starttime)='2012-09-21'
   ORDER BY b.starttime ;

   14.
   SELECT members.firstname as mfirstname, members.surname as msurname, recommendedby.firstname as rfirstname, recommendedby.surname as rsurname
   FROM cd.members members
   LEFT OUTER JOIN cd.members recommendedby ON recommendedby.memid = members.recommendedby
   ORDER BY msurname, mfirstname;

   15.
   SELECT DISTINCT recommendedby.firstname as firstname, recommendedby.surname as surname
   FROM cd.members members
   INNER JOIN cd.members recommendedby ON recommendedby.memid = members.recommendedby
   ORDER BY surname, firstname;

   16.
   SELECT DISTINCT CONCAT(firstname, ' ', surname) AS members,
       (SELECT CONCAT(recs.firstname, ' ', recs.surname)
           FROM cd.members recs
           WHERE recs.memid = members.recommendedby) AS recommender
   FROM cd.members
   ORDER BY members;

   17.
   SELECT recommendedby AS number_of_recommendations, COUNT(*) FROM cd.members
   WHERE recommendedby IS NOT NULL
   GROUP BY recommendedby
   ORDER BY recommendedby;

   18.
   SELECT facid, SUM(slots) AS "Total Slots" FROM cd.bookings
   GROUP BY facid
   ORDER BY facid;

   19.
   SELECT facid, SUM(slots) AS "Total Slots" FROM cd.bookings
   WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
   GROUP BY facid
   ORDER BY SUM(slots) ;

   20.
   SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots) AS total_slots FROM cd.bookings
   WHERE EXTRACT(YEAR FROM starttime) = 2012
   GROUP BY facid, month
   ORDER BY facid, month;

   21.
   SELECT COUNT(DISTINCT memid) FROM cd.bookings;

   22.
   SELECT m.surname, m.firstname, m.memid, MIN(bookings.starttime) AS starttime
   FROM cd.bookings bookings
   INNER JOIN cd.members m ON m.memid = bookings.memid
   WHERE starttime >= '2012-09-01'
   GROUP BY m.surname, m.firstname, m.memid
   ORDER BY m.memid ;

   23.
   SELECT (SELECT COUNT(*) FROM cd.members), firstname, surname
   FROM cd.members
   ORDER BY joindate

   24.
   SELECT row_number() over(ORDER BY joindate), firstname, surname FROM cd.members
   ORDER BY joindate ;

   25.
   SELECT facid, SUM(slots) AS Total_slots FROM cd.bookings
   GROUP BY facid
   HAVING SUM(slots) = (SELECT MAX(sum2.Total_slots) FROM
   		(SELECT SUM(slots) as Total_slots
   		FROM cd.bookings
   		GROUP BY facid) AS sum2);

   26.
   SELECT CONCAT(surname, ', ', firstname) AS name FROM cd.members;

   27.
   SELECT memid, telephone FROM cd.members
   WHERE telephone LIKE '%(%' OR telephone LIKE '%)%'
   ORDER BY memid;

   28.
   SELECT SUBSTR(surname,1,1) AS Letter, Count(*) AS Count FROM cd.members
   GROUP BY letter
   ORDER BY letter;
   