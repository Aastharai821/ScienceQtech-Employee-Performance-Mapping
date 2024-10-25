CREATE DATABASE employee;
USE employee;

SELECT * FROM employee.emp_record_table;
SELECT * FROM employee.proj_table;
SELECT * FROM employee.data_science_team;

DESCRIBE emp_record_table;

ALTER TABLE emp_record_table
MODIFY COLUMN EMP_ID VARCHAR(10) PRIMARY KEY, -- Assuming employee IDs are alphanumeric
MODIFY COLUMN FIRST_NAME VARCHAR(50),
MODIFY COLUMN LAST_NAME VARCHAR(50),
MODIFY COLUMN GENDER CHAR(1),  -- 'M' or 'F'
MODIFY COLUMN ROLE VARCHAR(50),
MODIFY COLUMN DEPT VARCHAR(50),
MODIFY COLUMN EXP INT,  -- Years of experience as integer
MODIFY COLUMN COUNTRY VARCHAR(50),
MODIFY COLUMN CONTINENT VARCHAR(50),
MODIFY COLUMN SALARY DECIMAL(10, 2),  -- Better for salary-related calculations
MODIFY COLUMN EMP_RATING INT,  -- Rating as integer (1-5)
MODIFY COLUMN MANAGER_ID VARCHAR(10),  -- Foreign Key to reference other employees
MODIFY COLUMN PROJ_ID VARCHAR(10);  -- Foreign Key to reference the project

DESCRIBE emp_record_table;
DESCRIBE proj_table;

-- update the START_DATE and CLOSURE_DATE columns to convert the MM/DD/YYYY format into the MySQL-compatible YYYY-MM-DD format.
-- Add a temporary column for the date conversion (we’ll later drop the old columns).
ALTER TABLE proj_table 
ADD COLUMN temp_start_date DATE, 
ADD COLUMN temp_closure_date DATE;

-- Use STR_TO_DATE() to convert the existing START_DATE and CLOSURE_DATE to the new date columns.
SET SQL_SAFE_UPDATES = 0;

UPDATE proj_table 
SET temp_start_date = STR_TO_DATE(START_DATE, '%m/%d/%Y'), 
    temp_closure_date = STR_TO_DATE(CLOSURE_DATE, '%m/%d/%Y');

-- TURNING ON THE SAFE MODE BACK AGAIN 
SET SQL_SAFE_UPDATES = 1;

-- update the rest of the proj_table columns and finalize the table with proper data types
-- Drop the Old start_date and closure_date Columns
ALTER TABLE proj_table
DROP COLUMN start_date,
DROP COLUMN closure_date;

-- Rename the temp_start_date and temp_closure_date Columns
ALTER TABLE proj_table
CHANGE COLUMN temp_start_date start_date DATE,
CHANGE COLUMN temp_closure_date closure_date DATE;

DESCRIBE proj_table;
-- Modify the Data Types for the Remaining Columns
ALTER TABLE proj_table
MODIFY COLUMN PROJECT_ID VARCHAR(10) PRIMARY KEY,  -- Assuming alphanumeric project IDs
MODIFY COLUMN PROJ_NAME VARCHAR(100),  -- Project names as strings
MODIFY COLUMN DOMAIN VARCHAR(50),  -- Domain of the project
MODIFY COLUMN DEV_QTR VARCHAR(5),  -- Quarter (e.g., 'Q1', 'Q2')
MODIFY COLUMN STATUS VARCHAR(20);  -- Status of the project
DESCRIBE proj_table;

DESCRIBE data_science_team;

ALTER TABLE data_science_team
MODIFY COLUMN EMP_ID VARCHAR(10),
MODIFY COLUMN FIRST_NAME VARCHAR(50),
MODIFY COLUMN LAST_NAME VARCHAR(50),
MODIFY COLUMN GENDER CHAR(1),
MODIFY COLUMN ROLE VARCHAR(50),
MODIFY COLUMN DEPT VARCHAR(50),
MODIFY COLUMN EXP INT,
MODIFY COLUMN COUNTRY VARCHAR(50),
MODIFY COLUMN CONTINENT VARCHAR(50);

DESCRIBE data_science_team;

-- Set up Primary and Foreign Key relationships
-- Foreign key to link projects (PROJ_ID) in emp_record_table with PROJECT_ID in proj_table.
-- Handle NA Values: The NA values are treated as non-matching data, which can cause issues with foreign key constraints
-- Convert NA to NULL: This will standardize the NA values to NULL, which will allow the foreign key constraint to work as expected.

-- disable safe mode 
SET SQL_SAFE_UPDATES = 0;

UPDATE emp_record_table
SET PROJ_ID = NULL
WHERE PROJ_ID = 'NA';

-- enable safe mode again 
SET SQL_SAFE_UPDATES = 0;

-- After cleaning up the NA values, you can proceed with adding the foreign key constraint again:
ALTER TABLE emp_record_table
ADD CONSTRAINT FK_Project
FOREIGN KEY (PROJ_ID) REFERENCES proj_table(PROJECT_ID)
ON DELETE SET NULL;

-- self-referencing foreign key for managers in emp_record_table.
ALTER TABLE emp_record_table
ADD CONSTRAINT FK_Manager
FOREIGN KEY (MANAGER_ID) REFERENCES emp_record_table(EMP_ID)
ON DELETE SET NULL;

-- Foreign key to link data_science_team with emp_record_table.
ALTER TABLE data_science_team
ADD CONSTRAINT FK_EmpDataScience
FOREIGN KEY (EMP_ID) REFERENCES emp_record_table(EMP_ID)
ON DELETE CASCADE;

-- Now, data types modified & FK set, generate ER successfully !! 

-- Task-3: To fetch employee details
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, GENDER, DEPT AS DEPARTMENT
FROM emp_record_table;

-- Task-4: To fetch Employee ratings
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING,
       CASE
           WHEN EMP_RATING < 2 THEN 'Less than 2'
           WHEN EMP_RATING > 4 THEN 'Greater than 4'
           WHEN EMP_RATING BETWEEN 2 AND 4 THEN 'Between 2 and 4'
       END AS Rating_Category
FROM emp_record_table
WHERE EMP_RATING < 2 OR EMP_RATING > 4 OR EMP_RATING BETWEEN 2 AND 4;

-- Task-5: To concatenate the first and last names of employees in the Finance department and alias the result as NAME
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME
FROM emp_record_table
WHERE DEPT = 'FINANCE';

-- Task-6: List Employees with Reporters and show the number of reporters
SELECT MANAGER_ID, 
       (SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) 
        FROM emp_record_table AS e 
        WHERE e.EMP_ID = emp_record_table.MANAGER_ID) AS EMPLOYEE_NAME, 
       COUNT(EMP_ID) AS Number_of_Reporters
FROM emp_record_table
WHERE MANAGER_ID IS NOT NULL
GROUP BY MANAGER_ID;

-- Task-7: List Employees from Healthcare and Finance Departments
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS Employee_name, DEPT
FROM emp_record_table
WHERE DEPT = 'HEALTHCARE'
UNION
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS Employee_name, DEPT
FROM emp_record_table
WHERE DEPT = 'FINANCE';

-- Task-8: Query to List Employee Details and Max Rating by Department
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, ROLE, DEPT AS DEPARTMENT, EMP_RATING,
       (SELECT MAX(EMP_RATING) 
        FROM emp_record_table AS sub
        WHERE sub.DEPT = emp_record_table.DEPT) AS MAX_EMP_RATING
FROM emp_record_table
GROUP BY EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING;

-- Task 9: Query to Calculate Min and Max Salary for Each Role
SELECT ROLE, 
       MIN(SALARY) AS MIN_SALARY, 
       MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY ROLE;

-- Task 10: Query to Assign Ranks Based on Experience
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, EXP, 
       RANK() OVER (ORDER BY EXP DESC) AS EXPERIENCE_RANK
FROM emp_record_table;

-- Task 11: Query to Create a View for Employees with Salary Above 6000
CREATE VIEW HighSalaryEmployees AS
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, COUNTRY, SALARY
FROM emp_record_table
WHERE SALARY > 6000;

-- Task 12: Nested Query to Find Employees with More Than 10 Years of Experience
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, EXP
FROM emp_record_table
WHERE EXP > 10;

-- Task 13: Query to Create a Stored Procedure for Employees with More Than 3 Years of Experience
DELIMITER $$
CREATE PROCEDURE GetEmployeesWithExperience()
BEGIN
    SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, EXP
    FROM emp_record_table
    WHERE EXP > 3;
END $$
DELIMITER ;

-- Task-14: Part-1> Create a Stored Function that returns the expected job profile based on the employee's experience
DELIMITER $$
CREATE FUNCTION GetJobProfile(exp INT) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE job_profile VARCHAR(50);
    IF exp <= 2 THEN
        SET job_profile = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp > 2 AND exp <= 5 THEN
        SET job_profile = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp > 5 AND exp <= 10 THEN
        SET job_profile = 'SENIOR DATA SCIENTIST';
    ELSEIF exp > 10 AND exp <= 12 THEN
        SET job_profile = 'LEAD DATA SCIENTIST';
    ELSEIF exp > 12 AND exp <= 16 THEN
        SET job_profile = 'MANAGER';
    ELSE
        SET job_profile = 'INVALID';
    END IF;

    RETURN job_profile;
END $$
DELIMITER ;

-- Task-14: Part-2> we can now query the data_science_team table to check if the employee's current job profile matches the expected one
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, ROLE AS Current_Job_Profile, 
       GetJobProfile(EXP) AS Expected_Job_Profile,
       IF(ROLE = GetJobProfile(EXP), 'MATCH', 'MISMATCH') AS Profile_Status
FROM data_science_team;

-- Task 15: Create an Index for FIRST_NAME in the emp_record_table to Improve Performance
-- Create the Index on FIRST_NAME:
CREATE INDEX idx_first_name ON emp_record_table(FIRST_NAME);

-- Query to Find Employee Whose First Name is 'Eric':
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, ROLE, DEPT, SALARY
FROM emp_record_table
WHERE FIRST_NAME = 'Eric';

-- check the performance improvement by running the following:
EXPLAIN SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, ROLE, DEPT, SALARY
FROM emp_record_table
WHERE FIRST_NAME = 'Eric';

-- Task 16: Calculate Bonus for All Employees (bonus is 5% of salary * employee rating)
SELECT EMP_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS EMPLOYEE_NAME, SALARY, EMP_RATING,
       (0.05 * SALARY * EMP_RATING) AS Bonus
FROM emp_record_table;

-- Task 17: Calculate Average Salary Distribution Based on Continent and Country
SELECT CONTINENT, COUNTRY, AVG(SALARY) AS Avg_Salary
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY
ORDER BY CONTINENT, COUNTRY;
