-- Creating database with full name
 
CREATE DATABASE yourname;

\c yourname; -- Connecting to database you created


\qecho 'Problem 1' -- This will display the output to the terminal when you run the command
-- Write your query for problem 1 here

\qecho 'Problem 2'
-- Write your query for problem 2 here

\qecho 'Problem 3'
-- Write your query for problem 3 here

-- END OF QUESTIONS -- 
\c postgres; -- Connect to the default database after all the queries have finished executing

DROP DATABASE yourname; -- Drop the database you created for this assignment


-- INSTRUCTIONS
-- Copy this file in any folder / directory of your choice
-- Open a terminal in that directory
-- Enter postgres with 'psql -U postgres'
-- Run the file with '\i filename.sql'