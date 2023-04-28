--Otázka č. 5 Má výška HDP vliv na změny ve mzdách a cenách potravin? 
Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na 
cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?


--Vytvoříme VIEW pro průměrné mzdy a ceny potravin s informacemi o 
HDP pro každý rok v České republice v období 2006-2018

CREATE VIEW temp_avg_wages_prices_with_gdp AS
SELECT
    t.year,
    AVG(t.avg_payroll_value) AS avg_payroll_value,
    AVG(t.avg_price_value) AS avg_price_value,
    e.GDP
FROM
    t_hana_plichtova_project_SQL_primary_final AS t
    JOIN economies AS e ON t.year = e.year AND e.country = 'Czech Republic'
WHERE
    t.year >= 2006 AND t.year <= 2018
GROUP BY
    t.year, e.GDP;
   
  --Použijeme LAG funkci, abychom získali procentuální změny HDP, mezd a cen potravin pro každý rok
  
  SELECT
    year,
    (GDP - LAG(GDP) OVER (ORDER BY year)) / LAG(GDP) OVER (ORDER BY year) * 100 AS yearly_gdp_percentage_change,
    (avg_payroll_value - LAG(avg_payroll_value) OVER (ORDER BY year)) / LAG(avg_payroll_value) OVER (ORDER BY year) * 100 AS yearly_wage_percentage_change,
    (avg_price_value - LAG(avg_price_value) OVER (ORDER BY year)) / LAG(avg_price_value) OVER (ORDER BY year) * 100 AS yearly_food_price_percentage_change
FROM
    temp_avg_wages_prices_with_gdp;

