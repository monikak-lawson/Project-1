-- I first examined the tables.

SELECT *
FROM countries;

SELECT *
FROM economies;

-- Then, I created a joined table.

CREATE OR REPLACE TABLE t_Monika_Lawson_project_SQL_secondary_final
SELECT	ec.YEAR,
	ec.country,
	c.region_in_world,
	ec.GDP,
	ec.taxes,
	ec.gini,
	ec.population
FROM economies ec
JOIN countries c 
	ON ec.country = c.country
WHERE ec.country = 'Czech Republic'
	AND YEAR BETWEEN 2006 AND 2018
GROUP BY ec.year;
