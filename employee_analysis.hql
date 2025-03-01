-- Query 1: Select employees who joined after 2015
SELECT * 
FROM employees_partitioned 
WHERE year(join_date) > 2015;

-- Query 2: Average salary per department
SELECT department, AVG(salary) AS avg_salary 
FROM employees_partitioned 
GROUP BY department;

-- Query 3: Select employees working on project 'Alpha'
SELECT * 
FROM employees_partitioned 
WHERE project = 'Alpha';

-- Query 4: Count employees per job role
SELECT job_role, COUNT(*) AS employee_count 
FROM employees_partitioned 
GROUP BY job_role;

-- Query 5: Select employees with salary greater than the average salary in their department
SELECT e.* 
FROM employees_partitioned e
JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees_partitioned 
    GROUP BY department
) dept_avg 
ON e.department = dept_avg.department
WHERE e.salary > dept_avg.avg_salary;

-- Query 6: Department with the highest number of employees
SELECT department, COUNT(*) AS employee_count
FROM employees_partitioned 
GROUP BY department
ORDER BY employee_count DESC
LIMIT 1;

-- Query 7: Select employees with non-null values in all key columns
SELECT * 
FROM employees_partitioned 
WHERE emp_id IS NOT NULL
AND name IS NOT NULL
AND age IS NOT NULL
AND job_role IS NOT NULL
AND salary IS NOT NULL
AND project IS NOT NULL
AND join_date IS NOT NULL
AND department IS NOT NULL;

-- Query 8: Join employees with their department details
SELECT e.emp_id, e.name, e.job_role, e.salary, e.project, e.join_date, d.department_name, d.location
FROM employees_partitioned e
JOIN departments d 
ON e.department = d.department_name;

-- Query 9: Rank employees within each department based on salary
SELECT emp_id, name, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM employees_partitioned;

-- Query 10: Select top 3 highest salaried employees per department
SELECT emp_id, name, department, salary, salary_rank
FROM (
    SELECT emp_id, name, department, salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM employees_partitioned
) ranked
WHERE salary_rank <= 3;