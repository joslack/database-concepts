CREATE DATABASE joslack;
\c joslack


\qecho 'Problem 1'
create function isprime(n int)
returns boolean as
$$
BEGIN
  for i in 2..floor(sqrt(n))
  LOOP
    if (n % i) = 0
    THEN 
      RETURN 0;
    END IF;
  END LOOP;
  RETURN 1;
END
$$ language 'plpgsql';
select isprime(7);
select isprime(17);
select isprime(541);
select isprime(20);

create function sum_of_primes(n int)
returns integer as
$$
DECLARE sum integer := 0;
DECLARE count integer := 0;
DECLARE current integer := 2;
BEGIN
  WHILE count < n 
  LOOP
    IF isprime(current) THEN
      sum := sum + current;
      count := count + 1;
    END IF;
    current := current + 1;
  END LOOP;
  RETURN sum;
END;
$$ language 'plpgsql';

\qecho 'Sum of Primes to 100: '
select sum_of_primes(100);


\qecho 'Problem 2'

create function selection_sort(arr numeric[])
returns numeric[] as
$$ 
  declare 
    temp numeric;
    idx int;
    n int := array_length(arr, 1);
  BEGIN
  FOR i in 1..n
  LOOP
    idx := i;
    FOR j in i+1..n
    LOOP
    -- find min value
      IF arr[idx] > arr[j]
      THEN idx := j;
      END IF;
    END LOOP;
    -- swap min value to the lowest position in the array
    temp := arr[i];
    arr[i] := arr[idx];
    arr[idx] := temp;
  END LOOP;
  RETURN arr;
  END;
$$ language 'plpgsql';






select selection_sort(ARRAY[3.14, 2.11, -9, -13, 50, 4.3, 4, 19]);

-- we recursively define ANC(x,y)
-- if PC(p,c) then ANC(p,c)
-- if ANC(a,p) and PC(p,c) then ANC(a, c)
create function new_anc_pairs() returns table (A integer, D integer) as
$$ 
(
  SELECT A,C
  FROM ANC JOIN PC ON (D=P)
)
EXCEPT
(
  SELECT A,D
  FROM ANC
);
$$ language sql;

CREATE OR REPLACE FUNCTION Ancestor_Descendant()
returns void as
$$
BEGIN
  DROP TABE IF EXISTS ANC;
  CREATE TABLE ANC(A integer, D integer);
  INSERT INTO ANC SELECT * FROM PC;
  WHILE EXISTS(SELECT * FROM new_anc_pairs())
    LOOP
      INSERT INTO ANC SELECT * FROM new_anc_pairs();
    END LOOP;
END;
$$ language plpgsql;

-- suppose also unary relations Male(P), Female(P)
-- want Ancestor_Male_Female(x,y,z) such that x is ancestor of male descendant y, y is an ancestor of female descendant z





-- problem 5
--original query:
SELECT p1.pid, p1.pname, p2.pid 
FROM Person p1, Person p2 
WHERE p1.city = 'Bloomington' 
AND p1.pid <> p2.pid 
AND p2.pid <> ALL (SELECT w.pid 
                  FROM Works w 
                  WHERE w.salary > 100000 
                  AND p1.pname = 'Eric');

-- define p1
WITH People1 as (select p.pid, p.pname from Person p where p.city = 'Bloomington'),
     People2 as ( (select p2.pid from Person p2) except (select w.pid from Works w where w.salary > 100000 AND p1.pname = 'Eric') )
SELECT p1.pid, p1.pname, p2.pid
FROM People1 p1 JOIN People2 p2 ON (p1.pid <> p2.pid);

-- b
SELECT m.mid 
FROM Manages m, worksFor w1, worksFor w2 
WHERE m.mid = w1.pid AND m.eid = w2.pid AND 
w1.salary < w2.salary AND w1.cname = 'Google';


SELECT m.mid
FROM Manages m JOIN worksFor w1 on (m.mid = w1.pid AND w1.cname = 'Google') JOIN worksfor w2 ON (m.eid = w2.wid AND w1.salary < w2.salary);
-- manager is w1, employee is w2, manager makes less than employee, and manager works at google
-- find manager employee tuples
SELECT m.mid, m.eid
FROM Manages m
INTERSECT
-- which follow the given constraints
SELECT w1.pid, w2.pid
FROM worksFor w1 JOIN worksFor w2 ON (w1.salary < w2.salary)
WHERE w1.cname = 'Google';


\c postgres
DROP DATABASE joslack;