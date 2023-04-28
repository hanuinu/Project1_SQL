--Otázka č.3 Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 
 
--Vytvoření dočasné tabulky s průměrnými cenami pro každý rok a kategorii napříč odvětvími

 CREATE TEMPORARY TABLE temp_avg_prices_by_year_category AS
SELECT
    year,
    category_code,
    category_name,
    AVG(avg_price_value) AS avg_price_value
FROM
    t_hana_plichtova_project_SQL_primary_final
GROUP BY
    year,
    category_code,
    category_name;
   
   SELECT * FROM temp_avg_prices_by_year_category;


  
--Vytvoření dočasné tabulky s meziročními změnami cen

CREATE TEMPORARY TABLE temp_year_over_year_changes AS
SELECT
    t1.year AS year,
    t1.category_code AS category_code,
    t1.category_name AS category_name,
    (t1.avg_price_value - t2.avg_price_value) / t2.avg_price_value * 100 AS yearly_percentage_change
FROM
    temp_avg_prices_by_year_category t1
JOIN
    temp_avg_prices_by_year_category t2 ON t1.category_code = t2.category_code AND t1.year = t2.year + 1;

   SELECT * FROM temp_year_over_year_changes; 
   
  
  
--Vytvoření dočasné tabulky s průměrnou meziroční změnou cen pro každou kategorii

  CREATE TEMPORARY TABLE temp_average_yearly_changes AS
SELECT
    category_code,
    category_name,
    AVG(yearly_percentage_change) AS avg_yearly_percentage_change
FROM
    temp_year_over_year_changes
GROUP BY
    category_code,
    category_name;
   
   SELECT * FROM temp_average_yearly_changes;
  
  
--Zjištění kategorie s nejnižším průměrným meziročním nárůstem cen
 
SELECT
    category_code,
    category_name,
    avg_yearly_percentage_change
FROM
    temp_average_yearly_changes
ORDER BY
    avg_yearly_percentage_change ASC
LIMIT 1;
