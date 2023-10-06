-- Creating database with full name
CREATE DATABASE joslack;

-- Connecting to database 
\c joslack;

------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--- PART 1, QUESTIONS 1-4 ------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
\qecho 'Problem 1'
-- Develop appropriate insert and delete triggers that implement the primary
-- key and foreign key constraints that are specified for the Westerosi,
-- House, and ofHouse relations.
-- Your triggers should report appropriate error conditions. For this problem,
-- implement the triggers such that foreign key constraints are maintained
-- using the cascading delete semantics.
-- For a reference on cascading deletes associated with foreign keys mainte-
-- nance consult the PostgreSQL manual page
-- https://www.postgresql.orgdocs9.2ddl-constraints.html
-- Test your triggers using appropriate inserts and deletes.
-- CREATE TABLE Westerosi(wid integer,
--                     wname text,
--                     wlocation text,
--                     primary key (wid));
-- CREATE TABLE House(hname text,
--                      kingdom text,
--                      primary key (hname));
-- CREATE TABLE OfHouse(wid integer,
--                       hname text,
--                       wages integer,
--                       primary key (wid),
--                       foreign key (wid) references Westerosi (wid),
--                       foreign key (hname) references House(hname));

CREATE TABLE Westerosi(wid integer,
                    wname text,
                    wlocation text);
CREATE TABLE House(hname text,
                     kingdom text);
CREATE TABLE OfHouse(wid integer,
                      hname text,
                      wages integer);

-- primary key constraint for insertion into westerosi
CREATE FUNCTION check_insert_westerosi() RETURNS trigger AS
$$
     BEGIN
          IF NEW.wid IN (SELECT wid FROM Westerosi)
               THEN RAISE EXCEPTION 'wid already exists';
          END IF;
          RETURN NEW;
     END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER check_westerosi_key
     BEFORE INSERT ON Westerosi
     FOR EACH ROW
     EXECUTE PROCEDURE check_insert_westerosi();

-- cascading delete to maintain primary key constraint on Westerosi
CREATE FUNCTION check_delete_westerosi() RETURNS trigger AS
$$
     BEGIN
          IF OLD.wid IN (SELECT wid FROM OfHouse) 
               THEN DELETE FROM OfHouse WHERE wid = OLD.wid;
          END IF;
          RETURN OLD;
     END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER check_westerosi_key_deletion
     BEFORE DELETE ON Westerosi
     FOR EACH ROW
     EXECUTE PROCEDURE check_delete_westerosi();

INSERT INTO Westerosi VALUES
     (1001,'JonSnow','CastleBlack'),
     (1002,'Daenerys', 'CastleBlack'),
     (1003,'Sansa', 'KingsLanding');

-- test repeated insertion. 
INSERT INTO Westerosi VALUES
     (1001,'JonSnow','CastleBlack');

INSERT INTO OfHouse VALUES
     (1001,'NightsWatch', 65000);

-- test cascading delete from westerosi
DELETE FROM Westerosi w WHERE w.wid = 1001;
SELECT * FROM Westerosi;
SELECT * FROM OfHouse;

-- primary key constraint for insertion into House
CREATE FUNCTION check_insert_house() RETURNS trigger AS
$$
     BEGIN
          IF NEW.hname IN (SELECT hname FROM House)
               THEN RAISE EXCEPTION 'hname already exists';
          END IF;
          RETURN NEW;
     END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER check_house_key
     BEFORE INSERT ON House
     FOR EACH ROW
     EXECUTE PROCEDURE check_insert_house();

-- cascading delete to maintain primary key constraint on House
CREATE FUNCTION check_delete_house() RETURNS trigger AS
$$
     BEGIN
          IF OLD.hname IN (SELECT hname FROM OfHouse) 
               THEN DELETE FROM OfHouse WHERE hname = OLD.hname;
          END IF;
          RETURN OLD;
     END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER check_hname_key_deletion
     BEFORE DELETE ON House
     FOR EACH ROW
     EXECUTE PROCEDURE check_delete_house();

-- repeated insertion into House
INSERT INTO House VALUES
     ('NightsWatch', 'CastleBlack');

INSERT INTO House VALUES
     ('NightsWatch', 'CastleBlack');



-- cascading deletion from house
INSERT INTO OfHouse VALUES
     (1001,'NightsWatch', 65000);
DELETE FROM House WHERE hname = 'NightsWatch';
SELECT * FROM House;
SELECT * FROM OfHouse;

-- primary and foreign key constraint constraint for OfHouse
-- primary key constraint for insertion into House
CREATE FUNCTION check_insert_ofhouse() RETURNS trigger AS
$$
     BEGIN
          IF NEW.wid IN (SELECT wid FROM OfHouse)
               THEN RAISE EXCEPTION 'wid already exists';
          END IF;
          IF NEW.wid NOT IN (SELECT wid FROM Westerosi)
               THEN RAISE EXCEPTION 'No Westerosi with given wid';
          END IF;
          IF NEW.hname NOT IN(SELECT hname FROM House)
               THEN RAISE EXCEPTION 'No House with given hname';
          END IF;
          RETURN NEW;
     END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER check_ofhouse_key
     BEFORE INSERT ON OfHouse
     FOR EACH ROW
     EXECUTE PROCEDURE check_insert_ofhouse();

-- testing insertion on OfHouse
INSERT INTO Westerosi VALUES
     (1001,'JonSnow','CastleBlack');
INSERT INTO House VALUES
     ('NightsWatch', 'CastleBlack');
INSERT INTO OfHouse VALUES
     (1001,'NightsWatch', 65000);

-- repeated insert
INSERT INTO OfHouse VALUES
     (1001,'NightsWatch', 65000);
-- insert with invalid wid
INSERT INTO OfHouse VALUES
     (1011,'NightsWatch', 65000);
-- insert with invalid hname
INSERT INTO OfHouse VALUES
     (1002,'Lannister', 65000);



DROP FUNCTION check_insert_ofhouse CASCADE;
DROP FUNCTION check_insert_house CASCADE;
DROP FUNCTION check_delete_house CASCADE;
DROP FUNCTION check_delete_westerosi CASCADE;
DROP FUNCTION check_insert_westerosi CASCADE;
DROP TABLE Westerosi;
DROP TABLE House;
DROP TABLE OfHouse;
\qecho 'Problem 2'
-- Consider two relations R(A:integer,B:integer) and S(B:integer) and a view
-- with the following definition:
-- select distinct r.A
-- from R r, S s
-- where r.A > 10 and r.B = s.B;
-- Suppose we want to maintain this view as a materialized view called
-- V(A:integer) upon the insertion of tuples in R and in S. (You do not
-- have to consider deletions in this question.) Define SQL insert triggers
-- and their associated trigger functions on the relations R and S that imple-
-- ment this materialized view. Write your trigger functions in the language
-- ‘plpgsql.’ Make sure that your trigger functions act in an incremental way
-- and that no duplicates appear in the materialized view.

CREATE TABLE R(A integer, B integer);
CREATE TABLE S(B integer);
CREATE TABLE V(A integer);
-- insert on R
CREATE FUNCTION insert_R() RETURNS trigger AS
$$
     BEGIN
          IF (NEW.A IN (SELECT v.A FROM V v)) THEN
               RETURN NEW;
          END IF;
          -- where r.a = 10
          IF (NEW.A > 10) THEN 
               -- and r.b is equal to some s.b
               IF (NEW.B IN (SELECT B FROM S)) THEN 
                    INSERT INTO V VALUES (NEW.A);
                    RETURN NEW;
               END IF;
          END IF;
          RETURN NEW;
     END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER check_R
     BEFORE INSERT ON R
     FOR EACH ROW
     EXECUTE PROCEDURE insert_R();

-- insert on S
CREATE FUNCTION insert_S() RETURNS trigger AS
$$
     BEGIN
          IF (NEW.B IN (SELECT r.B FROM R r)) THEN 
               INSERT INTO V 
                    SELECT DISTINCT r.A
                    FROM R r
                    WHERE r.A > 10 AND r.B = NEW.B AND r.A NOT IN (SELECT * FROM V);
               RETURN NEW;
          END IF;
          RETURN NEW;
     END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER check_S
     BEFORE INSERT ON S
     FOR EACH ROW
     EXECUTE PROCEDURE insert_S();


-- testing insertion 
INSERT INTO R VALUES
     (11,2),
     (22,2);
SELECT * FROM R;
SELECT * FROM S;
SELECT * FROM V;
-- should insert 11,22 into v
INSERT INTO S VALUES
     (2);
SELECT * FROM R;
SELECT * FROM S;
SELECT * FROM V;

-- should insert 33 into v
INSERT INTO R VALUES
     (33,2);
SELECT * FROM R;
SELECT * FROM S;
SELECT * FROM V;

-- should not insert into V because of repeated A
INSERT INTO S VALUES
     (3);
INSERT INTO R VALUES
     (33, 3);
SELECT * FROM R;
SELECT * FROM S;
SELECT * FROM V;





--- creating tables to test 3 and 4
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
CREATE TABLE WesterosiSkill(wid integer,
                         skill text,
                         primary key (wid, skill),
                         foreign key (wid) references Westerosi (wid) on delete cascade,
                         foreign key (skill) references Skill (skill) on delete cascade);
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

INSERT INTO Skill VALUES
   ('Archery'),
   ('Politics'),
   ('Swordsmanship'),
   ('HorseRiding'),
   ('Leadership');

\qecho 'Problem 3'
-- Consider the following on the WesterosiSkill relation. ”Each skill of a Wes-
-- terosi who belongs to house Lannister must also be a skill of a Westerosi
-- who belongs to the house NightsWatch.”
-- Write a trigger that maintains this constraint when inserting pairs (wid, skill)
-- into the WesterosiSkill table.

CREATE FUNCTION get_skills_of_nightswatch() RETURNS TABLE(skill text) AS
$$ 
     SELECT DISTINCT ws.skill
     FROM WesterosiSkill ws
     WHERE ws.wid IN (SELECT oh.wid FROM OfHouse oh WHERE oh.hname = 'NightsWatch');

$$ LANGUAGE SQL;
CREATE FUNCTION skill_constraint() RETURNS trigger AS
$$
     BEGIN
          IF NEW.wid IN (SELECT wid FROM OfHouse WHERE hname = 'Lannister') THEN
               IF NEW.skill NOT IN(SELECT * FROM get_skills_of_nightswatch()) THEN 
                    RAISE EXCEPTION 'Cannot give a Lannister a skill that the NightsWatch do not have';
               END IF;
          END IF;
          RETURN NEW;
     END;

$$ LANGUAGE 'plpgsql';

CREATE TRIGGER constrain_skills
     BEFORE INSERT ON WesterosiSkill
     FOR EACH ROW
     EXECUTE PROCEDURE skill_constraint();

INSERT INTO WesterosiSkill VALUES
 (1001,'Archery'), -- 1001 is nightswatch
 (1001,'Politics');

-- this should fail
INSERT INTO WesterosiSkill VALUES
     -- 1013 is lannister
     (1013, 'Swordsmanship');
 

DROP FUNCTION skill_constraint CASCADE;
\qecho 'Problem 4'
-- Consider the view WesterosiHasSkills(wid ,skills) which associates with each Westerosi, identified by a wid, his or her set of skills.
-- \begin{verbatim}
--     Create view WesterosiHasSkills as 
--             select distinct W.wid from 
--             Westerosi W, WesterosiSkill WS
--             where W.wid = WS.wid 
--             order by 1;
-- \end{verbatim}

-- Write a trigger that will delete all the skill records from
--  $WesterosiSkill$ relation when a Westerosi entry(wid) is deleted 
--  from the above $WesterosiHasSkills$ view. Show appropriate delete statements.

Create view WesterosiHasSkills as 
     select distinct W.wid from 
     Westerosi W, WesterosiSkill WS
     where W.wid = WS.wid 
     order by 1;
CREATE FUNCTION delete_all_skills() RETURNS trigger AS
$$
     BEGIN
          IF OLD.wid IN (SELECT wid FROM WesterosiSkill) THEN
               DELETE FROM WesterosiSkill WHERE wid = OLD.wid;
          END IF;
          RETURN NULL;
     END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER delete_skill_records
     INSTEAD OF DELETE 
     ON WesterosiHasSkills
     FOR EACH ROW
     EXECUTE PROCEDURE delete_all_skills();

SELECT * FROM WesterosiSkill;
DELETE FROM WesterosiHasSkills WHERE wid = '1001';
-- should be empty
SELECT * FROM WesterosiSkill;

------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--- PART 2 QUESTIONS 5-10 ------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-- for my sanity i delete all of the triggers and functions defined above by clearing the database
-- Connect to default database
\c postgres;

-- Drop database
DROP DATABASE joslack;
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



\qecho 'Problem 5'
-- Find the hname of each house who only has Westerosis currently stationed
-- in ‘Winterfell’ or ‘CastleBlack’ location.
CREATE FUNCTION WesterosiStationedAnywhere(house text) RETURNS TABLE(wid int)
AS $$
     SELECT oh.wid
     FROM OfHouse oh
     WHERE oh.hname = house
$$ LANGUAGE SQL;

CREATE VIEW WesterosiStationedAtCastleBlackOrWinterfell AS
     SELECT oh.wid
     FROM OfHouse oh
     WHERE oh.wid IN (
          SELECT w.wid
          FROM Westerosi w
          WHERE w.wlocation = 'CastleBlack' or w.wlocation = 'Winterfell'
     );

SELECT DISTINCT oh.hname
FROM OfHouse oh
WHERE NOT EXISTS (
     SELECT wsa.wid
     FROM WesterosiStationedAnywhere(oh.hname) wsa
     WHERE wsa.wid NOT IN (
          SELECT wscbwf.wid
          FROM WesterosiStationedAtCastleBlackOrWinterfell wscbwf
     )
);

\qecho 'Problem 6'
/*
Find the wid of each Westerosi who knows all Westerosis who belongs to ‘Lannister’ house and makes wages that is equal to 55000.
*/

CREATE FUNCTION PeopleKnownBy(wid int) RETURNS TABLE(wid int)
AS $$
     SELECT k.wid2
     FROM Knows k
     WHERE k.wid1 = wid
$$ LANGUAGE SQL;

CREATE VIEW OfHouseLannisterMakes55000 AS
     SELECT oh.wid
     FROM OfHouse oh
     WHERE oh.hname = 'Lannister' AND oh.wages = 55000;


CREATE VIEW KnowsAllLannistersWhoMake55000 AS
     SELECT DISTINCT k.wid1
     FROM Knows k
     WHERE NOT EXISTS(
          SELECT ohl.wid
          FROM OfHouseLannisterMakes55000 ohl
          WHERE ohl.wid NOT IN (
               SELECT pkb.wid
               FROM PeopleKnownBy(k.wid1) pkb
          )
     );

SELECT k.wid1
FROM KnowsAllLannistersWhoMake55000 k;
\qecho 'Problem 7'
/*
Find the pairs (s1, s2) of different Successors(Westerosis) such that some Predecessors of Successor1 are Predecessors of Successor2.
*/
CREATE FUNCTION PredecessorsOf(wid int) RETURNS TABLE (wid int)
AS $$
     SELECT p.predid
     FROM Predecessor p
     WHERE p.succid = wid
$$ LANGUAGE SQL;

SELECT w1.wid, w2.wid
FROM Westerosi w1, Westerosi w2
WHERE w1.wid <> w2.wid AND EXISTS(
     SELECT p1.wid
     FROM PredecessorsOf(w1.wid) p1
     INTERSECT 
     SELECT p2.wid
     FROM PredecessorsOf(w2.wid) p2
);
\qecho 'Problem 8'

/*
Find the hname of each house that not only has Westerosis with ‘Politics’ in their skills set.
*/

CREATE FUNCTION WesterosiWithoutPolitics(house text) RETURNS TABLE(wid int) 
AS $$
     SELECT DISTINCT ws.wid
     FROM WesterosiSkill ws
     WHERE ws.wid IN (
          SELECT oh.wid
          FROM OfHouse oh
          WHERE oh.hname = house
     ) AND ws.skill <> 'Politics'
$$ LANGUAGE SQL;
CREATE FUNCTION WesterosiWithPolitics(house text) RETURNS TABLE(wid int) 
AS $$
     SELECT DISTINCT ws.wid
     FROM WesterosiSkill ws
     WHERE ws.wid IN (
          SELECT oh.wid
          FROM OfHouse oh
          WHERE oh.hname = house
     ) AND ws.skill = 'Politics'
$$ LANGUAGE SQL;


SELECT DISTINCT h.hname
FROM House h
WHERE EXISTS(
     SELECT wwp.wid
     FROM WesterosiWithoutPolitics(h.hname) wwp
     WHERE wwp.wid NOT IN (
          SELECT wwp1.wid
          FROM WesterosiWithPolitics(h.hname) wwp1
     )
);
\qecho 'Problem 9'

/*
Find the pairs (wid1, wid2) of different Westerosis such that Westerosi with wid1 and the Westerosi with wid2 knows same number of Westerosis.
*/

CREATE FUNCTION NumberOfWesterosiKnown(wid int) RETURNS int
AS $$ 
     SELECT COUNT(1)
     FROM Knows k
     WHERE k.wid1 = wid
$$ LANGUAGE SQL;

SELECT DISTINCT w1.wid, w2.wid
FROM Westerosi w1, Westerosi w2
WHERE w1.wid <> w2.wid AND NumberOfWesterosiKnown(w1.wid) = NumberOfWesterosiKnown(w2.wid);
\qecho 'Problem 10'

/*
Find the hname of each house that has strictly 2 Westerosis with minimum wages at that house and knows at least 3 Westerosis.
*/

CREATE FUNCTION WesWithMinWages(house text) RETURNS TABLE (wid int)
AS $$
     SELECT oh.wid
     FROM OfHouse oh
     WHERE oh.hname = house 
          AND oh.wages = (
               SELECT MIN(oh1.wages)
               FROM OfHouse oh1
               WHERE oh.hname = oh1.hname
               )
$$ LANGUAGE SQL;

CREATE VIEW WesterosiWhoKnowAtLeastThreePeople AS
     SELECT w.wid
     FROM Westerosi w 
     WHERE (
          SELECT COUNT(k.wid1)
          FROM Knows k
          WHERE k.wid1 = w.wid
     ) >= 3;

SELECT DISTINCT oh.hname
FROM OfHouse oh
WHERE (
     SELECT COUNT(*)
     FROM (
          SELECT wwmw.wid
          FROM WesWithMinWages(oh.hname) wwmw
          INTERSECT 
          SELECT w.wid
          FROM WesterosiWhoKnowAtLeastThreePeople w
     ) AS intersection
) = 2;
-- Connect to default database
\c postgres;

-- Drop database created for this assignment
DROP DATABASE joslack;
