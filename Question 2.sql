-- Question 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- Finding 'category_codes' for milk and bread.

SELECT category_code,
	   name,
	   date_from 
FROM czechia_price AS cp
JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
WHERE cpc.name IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
GROUP BY name;

-- 114201 = Mléko polotučné pasterované
-- 111301 = Chléb konzumní kmínový

SELECT	payroll_year,
	category_code,
	product_name,
	average_salary,
	average_price,
	ROUND(average_salary/average_price, 2) AS how_much_can_buy
FROM t_Monika_Lawson_project_SQL_primary_final
WHERE category_code IN (114201, 111301)
	AND payroll_year IN (2006, 2018) -- -- first year 2006 and last year 2018
GROUP BY payroll_year ASC,
	category_code;

