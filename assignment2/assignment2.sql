-- Creating database with full name
CREATE DATABASE joslack;

-- Connecting to database 
\c joslack;



CREATE TABLE Westerosi(wid integer,
                    wname text,
                    wlocation text,
                    primary key (wid));

CREATE TABLE House(hname text,
                     kingdom text,
                     primary key (hname));

CREATE TABLE Skill(skill text,
                   primary key (skill));


CREATE TABLE OfHouse(wid integer,
                      hname text,
                      wages integer,
                      primary key (wid),
                      foreign key (wid) references Westerosi (wid),
                      foreign key (hname) references House(hname));


CREATE TABLE HouseAllyRegion(hname text,
                             region text,
                             primary key (hname, region),
                             foreign key (hname) references House (hname));


CREATE TABLE WesterosiSkill(wid integer,
                         skill text,
                         primary key (wid, skill),
                         foreign key (wid) references Westerosi (wid) on delete cascade,
                         foreign key (skill) references Skill (skill) on delete cascade);


CREATE TABLE Predecessor(succid integer,
                        predid integer,
                        primary key (succid, predid),
                        foreign key (succid) references Westerosi (wid),
                        foreign key (predid) references Westerosi (wid));

CREATE TABLE Knows(wid1 integer,
                   wid2 integer,
                   primary key(wid1, wid2),
                   foreign key (wid1) references Westerosi (wid),
                   foreign key (wid2) references Westerosi (wid));

INSERT INTO Westerosi VALUES
     (1001,'JonSnow','CastleBlack'),
     (1002,'Daenerys', 'CastleBlack'),
     (1003,'Sansa', 'KingsLanding'),
     (1004,'Cersei', 'KingsLanding'),
     (1005,'Jamie', 'CasterlyRock'),
     (1006,'Joffrey', 'BlackwaterBay'),
     (1007,'Stannis','Stormlands'),
     (1008,'Arya', 'Winterfell'),
     (1009,'Bran', 'Winterfell'),
     (1010,'Renly', 'BlackwaterBay'),
     (1011,'Catelyn', 'CasterlyRock'),
     (1012,'Samwell', 'CastleBlack'),
     (1013,'Tywin', 'Riverrun'), 
     (1014,'Brienne', 'Winterfell'), 
     (1015,'Olenna', 'Vale'),
     (1016,'Oberyn', 'BlackwaterBay'),
     (1017,'Robb', 'Stormlands'),
     (1018,'Theon', 'Winterfell'),
     (1019,'Tyrion', 'Highgarden'),
     (1020,'Varys', 'Oldtown');

INSERT INTO House VALUES
     ('NightsWatch', 'CastleBlack'),
     ('Baratheon', 'KingsLanding'),
     ('Lannister', 'CasterlyRock'),
     ('Stark', 'Winterfell'),
     ('Martell', 'Dorne'),
     ('Targaryen', 'KingsLanding'),
     ('Tyrell', 'Highgarden');


INSERT INTO OfHouse VALUES
     (1001,'NightsWatch', 65000),
     (1002,'Targaryen', 45000),
     (1003,'Stark', 55000),
     (1004,'Lannister', 55000),
     (1005,'Lannister', 60000),
     (1006,'Baratheon', 55000),
     (1007,'Baratheon', 50000),
     (1008,'Stark', 50000),
     (1009,'Stark',60000),
     (1010,'Baratheon', 55000),
     (1011,'Stark', 70000), 
     (1012,'NightsWatch', 50000),
     (1013,'Lannister', 55000),
     (1014,'NightsWatch', 50000), 
     (1015,'Tyrell', 60000),
     (1016,'Martell', 55000),
     (1017,'Stark', 60000),
     (1018,'NightsWatch', 50000),
     (1019,'Lannister', 50000);


INSERT INTO HouseAllyRegion VALUES
   ('NightsWatch', 'Winterfell'),
   ('Baratheon', 'BlackwaterBay'),
   ('Baratheon', 'Vale'),
   ('Baratheon', 'IronIslands'),
   ('Lannister', 'Highgarden'),
   ('Stark', 'Riverrun'),
   ('Stark', 'BlackwaterBay'),
   ('Martell', 'Winterfell'),
   ('NightsWatch', 'CastleBlack'),
   ('Baratheon', 'KingsLanding'),
   ('Lannister', 'CasterlyRock'),
   ('Stark', 'Stormlands'),
   ('Martell', 'Dorne'),
   ('Targaryen', 'Highgarden');

INSERT INTO Skill VALUES
   ('Archery'),
   ('Politics'),
   ('Swordsmanship'),
   ('HorseRiding'),
   ('Leadership');

INSERT INTO WesterosiSkill VALUES
 (1001,'Archery'),
 (1001,'Politics'),
 (1002,'Archery'),
 (1002,'Politics'),
 (1004,'Politics'),
 (1004,'Archery'),
 (1005,'Politics'),
 (1005,'Archery'),
 (1005,'Swordsmanship'),
 (1006,'Archery'),
 (1006,'HorseRiding'),
 (1007,'HorseRiding'),
 (1007,'Archery'),
 (1009,'HorseRiding'),
 (1009,'Swordsmanship'),
 (1010,'Swordsmanship'),
 (1011,'Swordsmanship'),
 (1011,'HorseRiding'),
 (1011,'Politics'),
 (1011,'Archery'),
 (1012,'Politics'),
 (1012,'HorseRiding'),
 (1012,'Archery'),
 (1013,'Archery'),
 (1013,'Politics'),
 (1013,'HorseRiding'),
 (1013,'Swordsmanship'),
 (1014,'HorseRiding'),
 (1014,'Politics'),
 (1014,'Swordsmanship'),
 (1015,'Archery'),
 (1015,'Politics'),
 (1016,'HorseRiding'),
 (1016,'Politics'),
 (1017,'Swordsmanship'),
 (1017,'Archery'),
 (1018,'Politics'),
 (1019,'Swordsmanship');

INSERT INTO Predecessor VALUES
 (1004, 1013),
 (1005, 1013),
 (1019, 1013),
 (1009, 1017),
 (1009, 1011),
 (1012, 1001),
 (1010, 1007),
 (1006, 1010),
 (1017, 1011),
 (1018, 1001),
 (1003, 1008),
 (1014, 1012),
 (1011, 1003),
 (1018, 1003),
 (1010, 1003);

 INSERT INTO Knows VALUES
 (1011,1009),
 (1007,1016),
 (1011,1010),
 (1003,1004),
 (1006,1004),
 (1002,1014),
 (1009,1005),
 (1018,1009),
 (1007,1017),
 (1017,1019),
 (1019,1013),
 (1016,1015),
 (1001,1012),
 (1015,1011),
 (1019,1006),
 (1013,1002),
 (1018,1004),
 (1013,1007),
 (1014,1006),
 (1004,1014),
 (1001,1014),
 (1010,1013),
 (1010,1014),
 (1004,1019),
 (1018,1007),
 (1014,1005),
 (1015,1018),
 (1014,1017),
 (1013,1018),
 (1007,1008),
 (1005,1015),
 (1017,1014),
 (1015,1002),
 (1018,1013),
 (1018,1010),
 (1001,1008),
 (1012,1011),
 (1002,1015),
 (1007,1013),
 (1008,1007),
 (1004,1002),
 (1015,1005),
 (1009,1013),
 (1004,1012),
 (1002,1011),
 (1004,1013),
 (1008,1001),
 (1008,1019),
 (1019,1008),
 (1001,1019),
 (1019,1001),
 (1004,1003),
 (1006,1003),
 (1015,1003),
 (1016,1004),
 (1016,1006),
 (1008,1015),
 (1010,1008),
 (1017,1013),
 (1002,1001),
 (1009,1001),
 (1011,1005),
 (1014,1012);


CREATE TABLE Pizza(diameter float);
INSERT INTO Pizza VALUES
(22.44),
(19.96),
(20.12),
(77.44),
(65.01),
(20.15);


drop table if exists equation;

CREATE TABLE EQUATION(A int, B int, C int);


INSERT INTO EQUATION
VALUES
(1,4,3),
(1,-4,4),
(1,-6,9),
(1,-4,3),
(2,-3,1);

DROP TABLE IF EXISTS LINKEDLIST;
CREATE TABLE LINKEDLIST(NODE int, NEXTNODE int);

\qecho 'Problem 1'
/* Consider the relation {\tt Equation(a int, b int, c int)},
find the roots r1,r2 of the the quadratic equation: $ax^2 + bx + c$ */
SELECT ( (-e.b + SQRT(e.b * e.b - 4*e.a*e.c) ) /(2*e.a)) AS r1 ,( (-e.b - SQRT(e.b * e.b - 4*e.a*e.c) ) /(2*e.a)) AS r2
FROM Equation e; 

\qecho 'Problem 2'
/* Using the same relation Pizza, write a SQL query that calculates the ratio
of the areas of the 2 largest Pizzas (largest / second largest) rounded to 2
decimal places. (π = 3.14) */
CREATE FUNCTION LargestDiameter(p Pizza) RETURNS float
AS $$
     SELECT MAX(p.diameter)
     FROM Pizza p;
$$ LANGUAGE SQL;
CREATE FUNCTION SecondLargest(p Pizza) RETURNS float
AS $$
     SELECT MAX(p.diameter)
     FROM Pizza p
     WHERE p.diameter < LargestDiameter(p);
$$ LANGUAGE SQL;

SELECT DISTINCT ROUND(CAST((3.14*(LargestDiameter(p)/2)*(LargestDiameter(p)/2))/(3.14*(SecondLargest(p)/2)*(SecondLargest(p)/2)) as numeric),2) AS ratio
From Pizza p;

\qecho 'Problem 3'
/* Create a function skillsInRange(n1 int, n2 int) returns the count of
Westerosis that have at least n1 skills and at most n2 skills. Test your
queries with inputs: */
CREATE FUNCTION skillsInRange(n1 int, n2 int) RETURNS int
AS $$
     SELECT COUNT(*)
     FROM Westerosi ws
     WHERE (SELECT COUNT(1) FROM WesterosiSkill ws1 Where ws1.wid = ws.wid) <= n2 AND (SELECT COUNT(1) FROM WesterosiSkill ws1 Where ws1.wid = ws.wid) >= n1;
$$ LANGUAGE SQL;


/* Test Case 1 */
SELECT * FROM skillsInRange(0,1);

/* Test Case 2 */
SELECT * FROM skillsInRange(4,5);


\qecho 'Problem 4'
/* Create a function/parameterized view familyGuy(housename) that takes
an hname as input, and returns the wids of the Westerosi with the most
amount of immediate successors. Test your query with inputs:

*/
CREATE FUNCTION countSucc(wid int) RETURNS int
AS $$
     SELECT COUNT(*)
     FROM Predecessor p
     WHERE p.predid = wid;
$$ LANGUAGE SQL;
-- 
CREATE FUNCTION familyGuy(house text) RETURNS TABLE(wid int)
AS $$
     SELECT oh.wid
     FROM OfHouse oh
     WHERE oh.hname = house
          AND
          countSucc(oh.wid) = (
               SELECT MAX(countSucc(oh1.wid))
               FROM OfHouse oh1
               WHERE oh1.hname = house
          );
$$ LANGUAGE SQL;


/* Test Case 1 */
SELECT * FROM familyGuy('Stark');

/* Test Case 2 */
SELECT * FROM familyGuy('Baratheon');

\qecho 'Problem 5'

/*
Find the wid of the Westerosi who don’t have ‘Archery’ or ‘Swordsmanship’ as
their skill.
*/


\qecho '5a: Using Exists, Not Exists'
SELECT w.wid
FROM Westerosi w
WHERE NOT EXISTS(
     SELECT ws.wid 
     FROM WesterosiSkill ws
     WHERE w.wid = ws.wid AND (ws.skill = 'Archery' OR ws.skill = 'Swordsmanship')
);

\qecho '5b: Using In, Not In'
SELECT w.wid
FROM Westerosi w
WHERE w.wid NOT IN(
     SELECT ws.wid
     FROM WesterosiSkill ws
     WHERE ws.skill = 'Archery' OR ws.skill = 'Swordsmanship'
);


\qecho 'Problem 6'

/*
Find all pairs (h1,h2) of hnames of different houses such that h1 and h2
do not have two Westerosis belonging to the same wlocation.
*/

\qecho '6a: Using Exists, Not Exists'
SELECT DISTINCT h1.hname as hname1, h2.hname as hname2
FROM House h1, House h2
WHERE h1.hname <> h2.hname AND NOT EXISTS(
     SELECT h3.hname, h4.hname
     FROM Westerosi w1, Westerosi w2, OfHouse h3, OfHouse h4
     WHERE (w1.wid <> w2.wid) 
          AND (w1.wlocation = w2.wlocation) 
          AND (h3.wid = w1.wid AND h4.wid = w2.wid)
          AND h1.hname = h3.hname AND h2.hname = h4.hname
)
ORDER BY h1.hname;

\qecho '6b: Using In, Not In'
SELECT DISTINCT h1.hname as hname1, h2.hname as hname2
FROM House h1, House h2
WHERE h1.hname <> h2.hname AND (h1.hname, h2.hname) NOT IN(
     SELECT h3.hname, h4.hname
     FROM Westerosi w1, Westerosi w2, OfHouse h3, OfHouse h4
     WHERE (w1.wid <> w2.wid) 
          AND (w1.wlocation = w2.wlocation) 
          AND (h3.wid = w1.wid AND h4.wid = w2.wid)
          AND h1.hname = h3.hname AND h2.hname = h4.hname
);

\qecho '6c: Using Except, Intersect'

(SELECT DISTINCT h1.hname as hname1, h2.hname as hname2
FROM House h1, House h2
WHERE h1.hname <> h2.hname)
EXCEPT 
(SELECT h3.hname, h4.hname
     FROM Westerosi w1, Westerosi w2, OfHouse h3, OfHouse h4
     WHERE (w1.wid <> w2.wid) 
          AND (w1.wlocation = w2.wlocation) 
          AND (h3.wid = w1.wid AND h4.wid = w2.wid));


\qecho 'Problem 7'

/*
Find the (wid,hname) of all the westerosis who belong to a hname and
know at least 2 people belonging to the same house.
*/

\qecho '7a: Using Exists, Not Exists'
SELECT h.wid, h.hname
FROM OfHouse h
WHERE EXISTS (
     SELECT k.wid1
     FROM Knows k
     WHERE k.wid1 = h.wid AND EXISTS(
          SELECT k1.wid2, k2.wid2
          FROM Knows k1, Knows k2, OfHouse h1, OfHouse h2
          WHERE k1.wid2 <> k2.wid2 AND k.wid1 = k1.wid1 AND k.wid1 = k2.wid1 AND (k2.wid2 = h2.wid AND h2.hname = h.hname) AND (k1.wid2 = h1.wid AND h1.hname = h.hname)
     )
);


\qecho '7b: Using In, Not In'
SELECT h.wid, h.hname
FROM OfHouse h
WHERE h.wid IN (
     SELECT k.wid1
     FROM Knows k
     WHERE k.wid1 = h.wid AND k.wid1 IN(
          SELECT k1.wid1
          FROM Knows k1, Knows k2, OfHouse h1, OfHouse h2
          WHERE k1.wid2 <> k2.wid2 AND k.wid1 = k1.wid1 AND k.wid1 = k2.wid1 AND (k2.wid2 = h2.wid AND h2.hname = h.hname) AND (k1.wid2 = h1.wid AND h1.hname = h.hname)
     )
);


\qecho '7c: Using Except, Intersect'
(SELECT h.wid, h.hname
FROM OfHouse h)
INTERSECT 
(SELECT h0.wid, h0.hname
FROM OfHouse h0, Knows k1, Knows k2, OfHouse h1, OfHouse h2
WHERE h0.wid = k1.wid1 AND
     h0.wid = k2.wid1 AND
     k1.wid2 <> k2.wid2 AND
     h1.wid = k1.wid2 AND
     h2.wid = k2.wid2 AND
     h1.hname = h0.hname AND
     h2.hname = h0.hname);

\qecho 'Problem 8'

/*
Use a VIEW to return the pairs (wid, wname) of all Westerosis that earn
a wage strictly greater than their immediate predecessors.
*/

CREATE VIEW ShouldersOfGiants(wid, wname) AS
     SELECT w.wid, w.wname
     FROM Westerosi w
     WHERE w.wid IN(
          SELECT p.succid
          FROM Predecessor p, OfHouse h
          WHERE h.wid = p.succid
               AND h.wages > ALL(
                    SELECT h1.wages
                    FROM OfHouse h1, Predecessor p2
                    WHERE h1.wid = p2.predid AND p2.succid = p.succid
               )
);
SELECT * FROM ShouldersOfGiants;

\qecho 'Problem 9'

/*
Define a materialized view HouseLeader that, for each hname, returns the
wid of Westerosis known by atleast 1 Westerosis from the same region.
*/

CREATE MATERIALIZED VIEW HouseLeader AS
     SELECT oh.wid
     FROM OfHouse oh, OfHouse oh1, House h, House h1, Knows k
     WHERE oh.wid <> oh1.wid AND --not the same person
          k.wid1 = oh1.wid AND k.wid2 = oh.wid AND-- oh1 knows oh (meaning at least 1 person knows them)
          oh.hname = h.hname AND oh1.hname = h1.hname AND -- for each house
          h.kingdom = h1.kingdom -- house is in the same region
     ORDER BY oh.wid;

-- find subset of those who are housed
-- find locations of houses
-- find the subset of those who are known by another westerosi
SELECT * FROM HouseLeader;
\qecho 'Problem 10'

/*
Let LinkedList(node integer, nextNode integer) be a binary rela-
tion, where a pair (n, m) in LinkedList indicates that node n is succeeded
by node m. The SequentialOrder(node) unary relation is inductively
defined using the following two rules:

• If n is NULL, m is a node in SequentialOrder, and represents the
head of the LinkedList relation. (Base rule)
• If s is a node in SequentialOrder and (n, m) is a pair in LinkedList
such that s = n, it implies that m succeeds s in the order. If m is
NULL, n is the last node in LinkedList. (Inductive Rule)
Write a recursive view SequentialOrder(node) that starts at the head
and visits each node in LinkedList in sequential order. You may assume
each node in LinkedList is unique. Test your view with the data in the
a2data.sql file.

*/
CREATE RECURSIVE VIEW SequentialOrder(node) AS (
     SELECT l.NEXTNODE
     FROM LinkedList l
     WHERE l.NODE IS NULL
     UNION 
     SELECT l.NEXTNODE
     FROM LinkedList l, SequentialOrder s
     WHERE l.NODE = s.node
     AND l.NEXTNODE IS NOT NULL
);
     

-- Test 1
insert into LinkedList values (NULL,1),(1,2),(2,4), (4,8), (8,16),(16,NULL);
select * from SequentialOrder;

-- Test 2
delete from linkedlist;
insert into linkedlist values (null,0), (0,3), (3,7), (7,5), (5,null);
select * from SequentialOrder;



-- Connect to default database
\c postgres;

-- Drop database created for this assignment
DROP DATABASE joslack;
