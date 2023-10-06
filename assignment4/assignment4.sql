-- Creating database with full name
CREATE DATABASE yourname;
-- Connecting to database 
\c yourname;

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
 (1011, 'Leadership'),
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


\qecho 'Problem 1'
/*
Formulate a query in RA SQL that returns each hname such that no Wes-
terosi belonging to that house has the ’Archery’ skill.
*/
SELECT h.hname
FROM House h
EXCEPT
SELECT oh.hname
FROM OfHouse oh JOIN WesterosiSkill ws
     ON (oh.wid = ws.wid AND ws.skill = 'Archery');

\qecho 'Problem 2'
/*
Formulate a query in RA SQL that returns the wid and region of each
Westerosi that:
	• Knows at least 2 people OR,
	• Has no successors
*/
SELECT q.wid, q.region
FROM (
     SELECT DISTINCT w.wid, har.region
     FROM Westerosi w JOIN OfHouse h 
          ON (h.wid = w.wid) JOIN HouseAllyRegion har 
               ON(h.hname = har.hname) JOIN Knows k1
                    ON (w.wid = k1.wid1) JOIN Knows k2
                         ON (w.wid = k2.wid1 AND k2.wid2 <> k1.wid2)
     UNION
     (SELECT DISTINCT w.wid, har.region
     FROM Westerosi w JOIN OfHouse h 
          ON (h.wid = w.wid) JOIN HouseAllyRegion har 
               ON(h.hname = har.hname)
     EXCEPT
     SELECT DISTINCT w.wid, har.region
     FROM Westerosi w JOIN OfHouse h 
          ON (h.wid = w.wid) JOIN HouseAllyRegion har 
               ON(h.hname = har.hname) JOIN Predecessor p
                    ON (p.predid = w.wid)
     )
) q
ORDER BY q.wid;



\qecho 'Problem 3'
/*
Formulate a query in RA SQL that returns each skill that is a skill of
some predid, such that each succid associated with that predid does
not have any of those skills
*/
SELECT ws.skill
FROM WesterosiSkill ws JOIN Predecessor p
     ON(ws.wid = p.predid)
EXCEPT
SELECT ss.skill
FROM WesterosiSkill ss JOIN WesterosiSkill ws
     ON(ss.skill = ws.skill) JOIN Predecessor p
          ON(ss.wid = p.succid AND ws.wid = p.predid);


\qecho 'Problem 4'
/*

Consider the following query in Pure SQL:
     
     select w.wid, exists (select 1
     from Predecessor P1, Predecessor P2
     where P1.predid = w.wid and P2.predid = w.wid and
     P1.succid <> P2.succid)
     from Westerosi w;

This query returns a pair (w, t) if w is the wid of a Westerosi who has at
least two predecessors and returns the pair (w, f ) otherwise 

Formulate the query above in RA SQL.
*/
-- select w.wid, exists (select 1
--      from Predecessor P1, Predecessor P2
--      where P1.predid = w.wid and P2.predid = w.wid and
--      P1.succid <> P2.succid)
--      from Westerosi w;

SELECT q.wid, q.booleancondition
FROM 
(SELECT DISTINCT w.wid, 't' as booleancondition
FROM Westerosi w JOIN Predecessor P1
     ON (P1.predid = w.wid) JOIN Predecessor P2
          ON (P2.predid = w.wid AND P1.succid <> P2.succid)
UNION
(SELECT DISTINCT w.wid, 'f' as booleancondition
FROM Westerosi w
EXCEPT
SELECT DISTINCT w.wid, 'f' as booleancondition
FROM Westerosi w JOIN Predecessor P1
     ON (P1.predid = w.wid) JOIN Predecessor P2
          ON (P2.predid = w.wid AND P1.succid <> P2.succid)
)
 ) q
ORDER BY q.wid;
\qecho 'Problem 5'
/*
Formulate a query in RA SQL that finds the wid and wname of each Wes-
terosi who belongs to a house allied in Winterfell but does not know any
Westerosi that lives in BlackwaterBay.
*/

SELECT w.wid, w.wname
FROM Westerosi w JOIN OfHouse oh 
     ON (w.wid = oh.wid) JOIN HouseAllyRegion har
          ON (oh.hname = har.hname AND har.region = 'Winterfell')
EXCEPT
SELECT w.wid, w.wname
FROM Westerosi w JOIN Knows k
     ON (w.wid = k.wid1) JOIN Westerosi w2 
          ON (w2.wid = k.wid2 AND w2.wlocation = 'BlackwaterBay');



-- Connect to default database
\c postgres;
-- Drop database created for this assignment
DROP DATABASE yourname;