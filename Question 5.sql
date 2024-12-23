-- Question 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

SELECT *
FROM economies;

SELECT *
FROM t_Monika_Lawson_project_SQL_primary_final;

SELECT *
FROM t_Monika_Lawson_project_SQL_secondary_final;

-- I created view from a code that I used for question 4.

CREATE OR REPLACE VIEW v_ML_average_price_average_salary AS
SELECT 
   year_from,
    AVG(average_price) AS average_price,
    LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) AS average_price_previous_year,
    AVG(average_price) - LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) AS YOY_difference_price,
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
    CASE 
        WHEN LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) = 0 
        THEN NULL 
        ELSE ROUND(
            (AVG(average_salary) - LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year)) 
            / LAG(AVG(average_salary)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) * 100, 2)
    END AS YOY_percentage_increase_salary
FROM t_Monika_Lawson_project_SQL_primary_final
GROUP BY payroll_year
ORDER BY payroll_year;

-- I created a view for increase/decrease in GDP

CREATE OR REPLACE VIEW v_ML_GDP_increase AS
SELECT 
    year,
    GDP AS current_year_GDP,
    LAG(GDP) OVER (ORDER BY year) AS previous_year_GDP,
    GDP - LAG(GDP) OVER (ORDER BY year) AS YOY_difference_GDP,
    CASE 
        WHEN LAG(GDP) OVER (ORDER BY year) = 0 
        THEN NULL 
        ELSE ROUND(
            (GDP - LAG(GDP) OVER (ORDER BY year)) / LAG(GDP) OVER (ORDER BY year) * 100, 2
        )
    END AS YOY_percentage_increase_GDP
FROM t_Monika_Lawson_project_SQL_secondary_final;

-- final dataset

SELECT payroll_year,
		YOY_percentage_increase_price,
		YOY_percentage_increase_salary,
		vmlgi.YOY_percentage_increase_GDP
FROM v_ML_average_price_average_salary
JOIN t_Monika_Lawson_project_SQL_secondary_final AS tmlpssf
	ON tmlpssf.year = payroll_year
JOIN v_ML_GDP_increase AS vmlgi
	ON payroll_year = vmlgi.year;
