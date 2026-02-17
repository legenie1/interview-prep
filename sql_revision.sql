SELECT * FROM employees;
SELECT DISTINCT department FROM employees;
SELECT first_name, last_name FROM employees;
SELECT first_name, last_name FROM employees WHERE department = 10;
SELECT first_name, last_name FROM employees WHERE salary IS NULL;
SELECT first_name, last_name FROM employees WHERE department = 10 AND salary > 50000;
SELECT * FROM employees ORDER BY salary DESC;
SELECT COUNT(*) FROM employees;
SELECT * FROM employees WHERE first_name LIKE 'J%';
SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department;

UPDATE employees SET salary = salary * 1.1 WHERE department = 20;

DELETE FROM employees WHERE department = 30;

INSERT INTO employees (first_name, last_name, department, salary) VALUES ('John', 'Doe', 10, 60000);

-- Aggregate functions
SELECT department, COUNT(*) AS employee_count FROM employees GROUP BY department;
SELECT department, MAX(salary) AS max_salary FROM employees GROUP BY department;
SELECT department, MIN(salary) AS min_salary FROM employees GROUP BY department;
SELECT department, SUM(salary) AS total_salary FROM employees GROUP BY department;