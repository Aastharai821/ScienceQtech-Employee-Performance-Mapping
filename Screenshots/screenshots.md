# Screenshots
## ER Diagram
![ER diagram (Reverse Engineer)](https://github.com/user-attachments/assets/04776a0f-d989-4d9a-8889-3f688a9f9aef)
*Description:* MySQL Workbench’s Database -> Reverse Engineer feature was used to generate the ER diagram, and the relationships between the tables were demonstrated that helped in visualizing the relationships among entities, showcasing primary keys, foreign keys, and table connections.

### Database Creation & Initial Data Import and Formatting
![image](https://github.com/user-attachments/assets/e30c192f-3108-4dcd-b95d-ac59e2be795c)
In the first step, we created a new database named employee using the SQL command. Once the database was created, we imported three datasets (emp_record_table, proj_table, and data_science_team) into the employee database. Each dataset contained specific information essential for employee performance mapping.

![image](https://github.com/user-attachments/assets/9309b575-d303-4904-8450-0a712da5a46d)
![image](https://github.com/user-attachments/assets/9edadf20-6c0d-48a6-9158-d889beb1969d)
![image](https://github.com/user-attachments/assets/1ee3475d-cc1e-46f5-b3a1-fb325b20d7dd)
Following the data import, we modified the structure of nearly all columns, as they were initially in TEXT format. Key columns were adjusted to appropriate data types: for example, emp_id (a primary key) was changed to INT, salary was set to DECIMAL, and start_date/closure_date were converted to DATE. These adjustments were necessary to align with relational database standards and enable accurate querying, efficient indexing, and consistent data representation for our analysis.

![image](https://github.com/user-attachments/assets/bb744cea-8ba4-4295-a536-26d953e10ea4)
*Image:* Screenshot of the SQL query done for modification of emp_record_table columns

![image](https://github.com/user-attachments/assets/4fd36b6a-d3d2-416f-8e02-721bfdfd4f52)
*Image:* Screenshot of the modification done for the proj_table

![image](https://github.com/user-attachments/assets/ed106332-834f-41ca-809b-163171279089)
*Image:* Screenshot of the modification done for the proj_table

![image](https://github.com/user-attachments/assets/ad91ad00-38d5-4c24-803d-2fe28c880af1)
*Image:* Screenshot of the modification done for the columns of data_science_team

*** 

### Setting Up Primary and Foreign Key Relationships
To enforce data integrity and relational structure across tables, we established primary and foreign key constraints. Each table was assigned a primary key to ensure unique identification of records.
**1.	emp_record_table:**
+ Primary Key: EMP_ID
+ Foreign Key (Manager): MANAGER_ID should refer to EMP_ID in the same table
+ Foreign Key (Project): PROJ_ID should refer to PROJECT_ID in the proj_table

But before linking PROJ_ID in emp_record_table with PROJECT_ID in proj_table, there were some NA values error which happened when the values in the PROJ_ID from emp_record_table didn’t match all the values in the PROJ_TABLE. Hence, following querying were done to handle the NA values and were converted to NULL so that the foreign key constraint is allowed. Also, there was another error while updating which occurred due to the safe mode. Hence, the safe mode was disabled before the update and enabled back again after. 
![image](https://github.com/user-attachments/assets/2c29a8f8-4b00-4092-8203-7b852eef89f1)

After cleaning up the NA values, you can proceed with adding the foreign key constraint again:

![image](https://github.com/user-attachments/assets/402a3876-0f81-4c57-a48b-d942cfc8db74)

Self-referencing foreign key for managers in emp_record_table

![image](https://github.com/user-attachments/assets/959e059b-9cd9-489d-86fe-472a822b8359)

Foreign key to link data_science_team with emp_record_table.

![image](https://github.com/user-attachments/assets/e969ab83-c426-421a-991f-5116ed7229db)

### Fetching Employee and Department Details

![image](https://github.com/user-attachments/assets/4978b268-b57f-4a87-94de-6b98100bb322)
This query was used to retrieve essential employee information, including EMP_ID, concatenated employee names as EMPLOYEE_NAME, and department details. This task allowed us to view employee details in relation to their department, which provided useful insights for the HR department at ScienceQtech.

### Employee Ratings with Categories

![image](https://github.com/user-attachments/assets/5394b80c-79c5-49d9-b0f1-552c20e42e80)
Using a CASE statement, we categorized employee ratings into three groups: less than 2, greater than 4, and between 2 and 4. This helped identify performance tiers and analyze rating distribution.

### Concatenate Name for Finance Department

![image](https://github.com/user-attachments/assets/3d96df39-1479-4641-beb4-59d085879987)
We concatenated the FIRST_NAME and LAST_NAME for employees in the Finance department, creating a single NAME field. This simplified name referencing and reporting.

### Employees with Reporters

![image](https://github.com/user-attachments/assets/010e1b59-7116-4128-ab7b-90aca513a137)
By grouping by MANAGER_ID and counting EMP_ID, we identified employees who supervise others, listing each with their respective count of reporters. This was essential for understanding team hierarchies.

### Healthcare and Finance Department Employees

![image](https://github.com/user-attachments/assets/b7e11e1b-ea62-4192-9950-781a1de3d58d)
Using UNION, we combined two queries to list employees from the Healthcare and Finance departments, with concatenated names and department details. This method allowed easy access to data from multiple departments in a unified view.

### Employee Details with Maximum Rating by Department

![image](https://github.com/user-attachments/assets/53c3bb36-5b92-46f4-ae0d-c3e46e7188dd)
Grouped by department, we listed employee details with their ratings and included the maximum rating in each department. This provided a comparative view of ratings, highlighting top performers per department.

### Min and Max Salary by Role

![image](https://github.com/user-attachments/assets/9b28d29b-75fb-4fa7-9df5-ba5adf27e1c5)
By grouping employees by role and calculating minimum and maximum salaries, we gained insight into salary ranges for each position, supporting analyses on salary distribution and potential adjustments.

### Rank Employees by Experience

![image](https://github.com/user-attachments/assets/65c2eaf6-3ada-417b-a0fb-213a88acdd2a)
Using the RANK() function, we ranked employees based on their experience, providing a clear hierarchy of expertise levels across the organization.

### View for High-Salary Employees

![image](https://github.com/user-attachments/assets/870d5df3-babd-4bc9-ad10-0d03eec59be8)
We created a view to list employees earning over 6000, including their names and countries. This filtered view provided insights into high-salary distribution across different regions.

### Find Employees with Over 10 Years of Experience

![image](https://github.com/user-attachments/assets/34110701-a9db-41f2-b9c8-ca09d945a1bd)
A nested query allowed us to filter for employees with more than 10 years of experience, providing a targeted view of long-tenured employees for analysis.

### Stored Procedure for Employees with More Than 3 Years of Experience

![image](https://github.com/user-attachments/assets/c53b841c-c269-4368-afcc-41a28d4d0f35)
We created a stored procedure that fetches employee details for those with over three years of experience. This procedure streamlined experience-based data retrieval for frequent analysis.

### Job Profile Matching Based on Experience

![image](https://github.com/user-attachments/assets/81a23521-0fca-4dac-83e7-0589a2f958a7)
Using a stored function, we defined a standard for assigning job profiles based on experience. We compared this standard against actual job titles, marking them as "MATCH" or "MISMATCH" to assess profile accuracy.

### Index for Performance Improvement on First Name Searches

![image](https://github.com/user-attachments/assets/91df8fed-d2db-46bc-81b6-f68a36966d6d)
Creating an index on FIRST_NAME improved the performance of searches for specific employees, verified with an EXPLAIN query. This indexing significantly sped up data retrieval for frequent name-based queries.

### Bonus Calculation Based on Rating and Salary

![image](https://github.com/user-attachments/assets/e7d28993-99f0-4e64-afde-74a473e3870d)
Using a formula of 5% of salary * employee rating, we calculated the bonus for each employee, facilitating quick access to performance-based financial incentives.

### Average Salary by Continent and Country

![image](https://github.com/user-attachments/assets/82c3d14b-a698-4824-8941-7f3996286201)
We calculated average salaries grouped by continent and country, offering insights into regional salary distribution, aiding in geographic compensation analysis.

***
## Conclusion: 
In conclusion, the ScienceQtech Employee Performance Mapping project was instrumental in structuring, organizing, and analyzing employee data using MySQL Workbench 8.0. Each task was successfully completed, gaining insights into employee ratings, salary distribution, and departmental performance. The project has provided valuable takeaways that can assist ScienceQtech in effective decision-making and organizational analysis.
