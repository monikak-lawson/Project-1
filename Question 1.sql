-- Question 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- I added LAG column 'average_salary_previous_year' to obtain the value of the column in the previoius year.
-- Then, I added column year-over-year 'YOY_difference' to calculate the difference between years. 

SELECT 
    payroll_year,
    AVG(average_salary) AS average_salary,
    industry_branch_code,
    LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS average_salary_previous_year,
    AVG(average_salary) - LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS YOY_difference
FROM t_Monika_Lawson_project_SQL_primary_final
GROUP BY payroll_year, 
		industry_branch_code
ORDER BY YOY_difference ASC,
		industry_branch_code, 
		payroll_year;
