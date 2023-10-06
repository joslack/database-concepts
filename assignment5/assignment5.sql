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
                     foreign key (wid) references Westerosi 
(wid),
                     foreign key (hname) references 
House(hname));

CREATE TABLE HouseAllyRegion(hname text,
                            region text,
                            primary key (hname, region),
                            foreign key (hname) references House 
(hname));

CREATE TABLE WesterosiSkill(wid integer,
                        skill text,
                        primary key (wid, skill),
                        foreign key (wid) references Westerosi 
(wid) on delete cascade,
                        foreign key (skill) references Skill 
(skill) on delete cascade);

CREATE TABLE Predecessor(succid integer,
                       predid integer,
                       primary key (succid, predid),
                       foreign key (succid) references Westerosi 
(wid),
                       foreign key (predid) references Westerosi 
(wid));

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
SELECT W.WID, W.WNAME
FROM WESTEROSI W, PREDECESSOR P
WHERE W.WID = P.SUCCID
AND W.WID not in
(SELECT W.WID
FROM WESTEROSI W,
PREDECESSOR P,
OFHOUSE OH1,
OFHOUSE OH2
WHERE W.WID = P.SUCCID
AND OH1.WID = P.SUCCID
AND OH2.WID = P.PREDID
AND OH1.WAGES <= OH2.WAGES );
*/


-- SELECT w.wid, w.wname 
-- FROM Westerosi w, Predecessor p
-- Where w.wid = p.succid
-- AND w.wid NOT IN(
--      SELECT w.wid 
--      FROM Westerosi w, Predecessor p, Ofhouse oh1, OfHouse oh2
--      WHERE w.wid = p.succid AND oh1.wid = p.succid AND oh2.wid = p.predid
--           AND oh1.wages <= oh2.wages);


-- SELECT w.wid, w.wname 
-- FROM Westerosi w, Predecessor p
-- WHERE w.wid = p.succid
-- EXCEPT
-- SELECT w.wid, w.wname
-- FROM Westerosi w, Predecessor p, Ofhouse oh1, OfHouse oh2
-- WHERE w.wid = p.succid AND oh1.wid = p.succid AND oh2.wid = p.predid
--      AND oh1.wages <= oh2.wages;

-- SELECT w.wid, w.wname 
-- FROM Westerosi w JOIN Predecessor p ON (w.wid = p.succid)
-- EXCEPT
-- SELECT w.wid, w.wname
-- FROM Westerosi w JOIN Predecessor p ON (w.wid = p.succid) 
--           JOIN (Ofhouse oh1 JOIN OfHouse oh2 ON (oh1.wages <= oh2.wages))
--                ON (oh1.wid = p.succid AND oh2.wid = p.predid);

SELECT w.wid, w.wname
FROM Westerosi w NATURAL JOIN (SELECT p.succid as wid FROM Predecessor p) as s
EXCEPT
SELECT w.wid, w.wname
FROM Westerosi w NATURAL JOIN
  (SELECT p.succid as wid
  FROM Predecessor p NATURAL JOIN
     (SELECT oh2.wid as predid, oh1.wid as succid
     FROM OfHouse oh1 JOIN OfHouse oh2 ON (oh1.wages <= oh2.wages)
     ) as q
  ) as s;


\qecho 'Problem 2'
/*
SELECT H.HNAME, H.KINGDOM
FROM HOUSE H
WHERE H.HNAME in
(SELECT OH.HNAME
FROM OFHOUSE OH
WHERE OH.WAGES < 60000
AND OH.WID = SOME
(SELECT WS.WID
FROM WESTEROSISKILL WS
WHERE WS.SKILL = ’Archery’));
*/

SELECT DISTINCT H.HNAME, H.KINGDOM
FROM HOUSE H NATURAL JOIN (
  SELECT OH.HNAME
  FROM OFHOUSE OH NATURAL JOIN (
     SELECT WS.WID
     FROM WESTEROSISKILL WS
     WHERE WS.SKILL='Archery'
  ) AS B
  WHERE OH.WAGES < 60000
) AS A;
\qecho 'Problem 3'
/*
SELECT DISTINCT W.WID
FROM WESTEROSI W
WHERE W.WLOCATION = ’Winterfell’
AND EXISTS (SELECT 1
FROM OFHOUSE H, WESTEROSISKILL W1
WHERE W.WID = H.WID AND W.WID = W1.WID
AND H.WAGES = 50000 AND NOT W1.SKILL = ’Swordsmanship’);
*/
SELECT DISTINCT w.wid
FROM Westerosi w NATURAL JOIN(
	SELECT h.wid
	FROM OfHouse h NATURAL JOIN (
		SELECT ws.wid
		FROM WesterosiSkill ws
		WHERE ws.skill <> 'Swordsmanship'
		) as skill
	WHERE h.wages = 50000
	) as wages
WHERE w.wlocation = 'Winterfell';

\qecho 'Problem 4'
/*
SELECT W.WID
FROM WESTEROSI W
WHERE NOT EXISTS (SELECT 1
FROM HOUSEALLYREGION HA
WHERE HA.REGION = ’IronIslands’ AND
HA.HNAME NOT IN (SELECT H.HNAME
FROM OFHOUSE H
WHERE H.WID = W.WID
AND H.WID in (SELECT WS.WID
FROM WESTEROSISKILL WS
WHERE WS.SKILL = ’Archery’)));
*/

WITH IRONISLANDS AS (SELECT HA.HNAME FROM HOUSEALLYREGION HA WHERE HA.REGION='IronIslands'),
     ARCHERY AS (SELECT WS.WID FROM WESTEROSISKILL WS WHERE WS.SKILL='Archery')
SELECT W.WID
FROM (
     SELECT W.WID
     FROM WESTEROSI W
     EXCEPT
     SELECT W.WID
     FROM (
          SELECT HA.HNAME,W.WID
          FROM WESTEROSI W NATURAL JOIN IRONISLANDS HA
          EXCEPT
          SELECT OH.HNAME, OH.WID
          FROM OFHOUSE OH NATURAL JOIN ARCHERY
     ) AS W
) AS W;
\qecho 'Problem 5'
/*
Find the wname and wlocation of each westerosi whose wages are
strictly greater than 50000, and belongs to a house which has a king-
dom in KingsLanding and has some skill.
*/
-- SELECT DISTINCT W.WID
-- FROM WESTEROSI W, OFHOUSE OH, HOUSEALLYREGION HA, WESTEROSISKILL WS
-- WHERE W.WID=OH.WID 
--   AND WS.WID = W.WID  
--   AND OH.WAGES > 50000 
--   AND OH.HNAME = HA.HNAME 
--   AND HA.REGION='KingsLanding';

WITH KINGSLANDING AS (SELECT HA.HNAME FROM HOUSEALLYREGION HA WHERE HA.REGION=  'KingsLanding')
SELECT DISTINCT w.wid
FROM WESTEROSI W NATURAL JOIN (
	SELECT WS.WID
	FROM WESTEROSI WS NATURAL JOIN(
		SELECT OH.WID 
		FROM OFHOUSE OH NATURAL JOIN KINGSLANDING
    WHERE OH.WAGES > 50000
	) AS A
	
) AS B;
\c postgres;
DROP DATABASE joslack;