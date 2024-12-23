-- Question 4 Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- average salary

SELECT 
    payroll_year,
    AVG(average_salary) AS average_salary,
    LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS average_salary_previous_year,
    AVG(average_salary) - LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS YOY_difference,
    -- Calculate and round the percentage change (YOY increase or decrease)
    CASE 
        WHEN LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) = 0 
        THEN NULL 
        ELSE ROUND(
            (AVG(average_salary) - LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year)) 
            / LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) * 100, 2)
    END AS YOY_percentage_increase
FROM t_Monika_Lawson_project_SQL_primary_final
GROUP BY payroll_year
ORDER BY payroll_year;

-- average price

SELECT   
    year_from,
    AVG(average_price) AS average_price,
    product_name,
    LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) AS average_price_previous_year,  -- Previous year's average price
    AVG(average_price) - LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) AS YOY_difference, -- Year-to-year difference
    -- Calculate and round the percentage change (YOY increase or decrease)
    CASE 
        WHEN LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) = 0 
        THEN NULL 
        ELSE ROUND(
            (AVG(average_price) - LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from)) 
            / LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) * 100, 2
        )
    END AS YOY_percentage_increase
FROM 
    t_Monika_Lawson_project_SQL_primary_final
GROUP BY year_from
ORDER BY year_from;

-- final dataset

SELECT   
    year_from,
    AVG(average_price) AS average_price,
    LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) AS average_price_previous_year,
    AVG(average_price) - LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) AS YOY_difference_price,
    -- Calculate and round the percentage change (YOY increase or decrease)
    CASE 
        WHEN LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) = 0 
        THEN NULL 
        ELSE ROUND(
            (AVG(average_price) - LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from)) 
            / LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) * 100, 2
        )
    END AS YOY_percentage_increase_price,
     payroll_year,
    AVG(average_salary) AS average_salary,
    LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS average_salary_previous_year,
    AVG(average_salary) - LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS YOY_difference_salary,
    -- Calculate and round the percentage change (YOY increase or decrease)
    CASE 
        WHEN LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) = 0 
        THEN NULL 
        ELSE ROUND(
            (AVG(average_salary) - LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year)) 
            / LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) * 100, 2)
    END AS YOY_percentage_increase_salary
FROM 
    t_Monika_Lawson_project_SQL_primary_final
GROUP BY year_from
ORDER BY year_from;
