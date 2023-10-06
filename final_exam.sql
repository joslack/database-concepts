--1

-- x is ancestor of two sisters y and z
-- y and z are female
-- y and z share a parent
-- x is an ancestor of y and z
create or replace function Ancestor-Sisters(x
integer, y integer, z integer)
returns boolean as
$$
  select exists (select a.A, sister_1.C, sister_2.C
  from ANC a1, ANC a2,PC sister_1, PC sister_2
  where a1.A = x -- X is the ancestor
        AND a2.A = x -- doing this twice to ensure that both sisters are descendants of a, because if they are half sisters its possible that x is not an ancestor of both
        AND sister_1.C = y
        AND sister_2.C = z
        AND a1.D = sister_1.C -- sister1 is descendant of x
        AND a2.D = sister_2.C -- sister2 is also a descendant of X
        AND sister_1.P = sister_2.P -- sisters share a parent
        AND sister_1.C in (SELECT P from Female) -- sister1 is female
        AND sister_2.C in (SELECT P from Female) -- sister2 is female      
  )
$$ language sql;



--Translate the following query into an equivalent relational algebra expression. Show intermediate steps.

SELECT DISTINCT E1.cno
FROM Enroll E1, Enroll E2
WHERE E1.grade = 'A' 
AND E1.sid <> SOME (SELECT S.sid
                    FROM Student S
                    WHERE S.major = 'CS' 
                    AND E1.cno <> E2.cno)

-- we must first get rid of the 


--Consider the view studentCourses(sid, Courses) which associates which each student sid the set of cnos of courses in which the student with that sid is enrolled. Furthermore, consider the view majorStudents(major,Students) which associates with each major the set of sids of students with that major.

create view studentCourses as
  (select s.sid, array(select e.cno
                        from Enroll e
                        where e.sid = s.sid) as Courses
                        from Student s);

create view majorStudents as
  (select d.dept as major, array(select sid
                          from Student s
                          where s.major = d.department) as Students
                          from department d);

-- Using only these views and the relation Student, write the following query in object-relational SQL:


-- In your solution, you cannot use the set predicates [NOT] IN, [NOT] EXISTS, ALL, and SOME. Instead use the following functions and predicates defined in the this file.

-- Download file. (from assignment 6)

/*
Functions:
set_union(A,B)               A union B
set_intersection(A,B)        A intersection B
set_difference(A,B)          A - B

Predicates:
is_in(x,A)                   x in A
is_not_in(x,A)               not(x in A)
is_empty(A)                  A is the emptyset
is_not_emptyset(A)           A is not the emptyset
subset(A,B)                  A is a subset of B
superset(A,B)                A is a super set of B
equal(A,B)                   A and B have the same elements
overlap(A,B)                 A intersection B is not empty
disjoint(A,B)                A and B are disjoint
*/

-- student courses = student -> courses they are taking
-- major students = major -> students in that major
-- Find the sid and name of each student such that each course 
--in which that student is enrolled is among the courses in which students who major in 'CS' are enrolled.
SELECT s.sid, s.sname
FROM Student S
WHERE is_subset(SELECT Courses FROM studentCourses sc where sc.sid = s.sid, array(SELECT DISTINCT unnest(sc.Courses)
                                                                                  FROM studentCourses sc
                                                                                  WHERE is_in(sc.sid, array(SELECT ms.Students 
                                                                                  FROM majorStudents ms
                                                                                  WHERE ms.major = 'CS')))
                                                                                  );
-- select the id and name of students where the courses in which they are enrolled are a subset of the combined set of courses of all CS majors
-- the first select in is_subset is guaranteed to be a single array because of the primary key constraint
-- the second wraps a query in an array, the query selects all of the courses of students enrolled in cs

-- set of all courses of cs students


