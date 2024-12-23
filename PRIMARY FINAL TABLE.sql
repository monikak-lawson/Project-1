-- I first examined the payroll tables.

SELECT *
FROM czechia_payroll_unit;
-- 200	tis. osob (tis. os.)
-- 80403	Kč

SELECT *
FROM czechia_payroll_value_type cpvt;
-- 316	Průměrný počet zaměstnaných osob
-- 5958	Průměrná hrubá mzda na zaměstnance

SELECT *
FROM czechia_payroll_calculation cpc; 
-- 100	fyzický
-- 200	přepočtený

--  Then I added a calculated column 'average salary', removed null values and filtered values.
SELECT ROUND(AVG(cp.value), 2) AS average_salary,
	cp.industry_branch_code,
	cp.payroll_year,
	cp.calculation_code,
	cp.value_type_code,
	cp.unit_code 
FROM czechia_payroll AS cp
WHERE cp.industry_branch_code IS NOT NULL -- without null values
	  AND cp.value_type_code = 5958 -- prumerna hruba mzda na zamestnance
	  AND cp.calculation_code = 200 -- prepocteny kod pocita i zkracene uvazky
GROUP BY cp.industry_branch_code,
		cp.payroll_year
ORDER BY cp.industry_branch_code, 
		 cp.payroll_year; 

		
SELECT *
FROM czechia_price cp;

SELECT *
FROM czechia_price_category cpc;

SELECT cp2.region_code,
	ROUND(AVG(cp2.value), 2) AS average_price,
	cp2.category_code,
	YEAR(cp2.date_from) AS year_from,
	cpc.name AS product_name,
	cpc.code,
	cpc.price_value,
	cpc.price_unit 
FROM czechia_price AS cp2
JOIN czechia_price_category AS cpc
	ON cp2.category_code = cpc.code
WHERE cp2.region_code IS NOT NULL -- without NULL values
GROUP BY cp2.category_code,
		year_from;

CREATE OR REPLACE TABLE t_Monika_Lawson_project_SQL_primary_final
SELECT 
	cp.payroll_year,
	cp.industry_branch_code,
	ROUND(AVG(cp.value), 2) AS average_salary,
	cp.calculation_code,
	cp.value_type_code,
	cp.unit_code,
	YEAR(cp2.date_from) AS year_from,
	cpc.name AS product_name,
	ROUND(AVG(cp2.value), 2) AS average_price,
	cp2.category_code,
	cp2.region_code,
	cpc.code,
	cpc.price_value,
	cpc.price_unit 
FROM czechia_payroll AS cp  
JOIN czechia_price AS cp2 
	ON cp.payroll_year = YEAR(cp2.date_from)
JOIN czechia_price_category AS cpc
	ON cp2.category_code = cpc.code
WHERE value_type_code = 5958  -- prumerna hruba mzda na zamestnance
		AND calculation_code = 200 -- prepocteny kod pocita i zkracene uvazky
		AND industry_branch_code IS NOT NULL
		AND region_code IS NOT NULL
GROUP BY cp.industry_branch_code,
		cp.payroll_year,
		cp2.category_code,
		year_from
ORDER BY cp.industry_branch_code,
		cp.payroll_year,
		cp2.category_code,
		year_from;
