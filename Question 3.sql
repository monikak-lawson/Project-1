-- Question 3 Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

SELECT *
FROM t_Monika_Lawson_project_SQL_primary_final;

-- First, I have set up the average_price_previous_year column and then year-to-year difference column called YOY_difference.

SELECT 
    year_from,
    AVG(average_price) AS average_price,
    product_name,
    LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) AS average_price_previous_year,
    AVG(average_price) - LAG(AVG(average_price)) OVER (PARTITION BY category_code ORDER BY year_from) AS YOY_difference
FROM t_Monika_Lawson_project_SQL_primary_final
GROUP BY year_from, 
		 category_code 
ORDER BY year_from,
		product_name;

-- Then, I created a calculated column 'YOY_percentage_increase' = 'YOY_difference'/'average_price_previous_year'*100
   
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
GROUP BY 
    year_from, 
    category_code, 
    product_name
ORDER BY 
    year_from,
    product_name;

