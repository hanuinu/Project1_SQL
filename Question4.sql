--Otázka č.4 Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně 
vyšší než růst mezd (větší než 10 %)?


--Vytvoření dočasné tabulky s průměrnými cenami potravin a mezdami pro každý rok

CREATE TEMPORARY TABLE temp_avg_prices_and_wages_by_year AS
SELECT
    year,
    round(AVG(avg_payroll_value))  AS avg_payroll_value,
    round(AVG(avg_price_value),2)  AS avg_price_value
FROM
    t_hana_plichtova_project_SQL_primary_final
GROUP BY
    year;


--Vytvoření dočasné tabulky s meziročními změnami cen potravin a mezd

CREATE TEMPORARY TABLE temp_year_over_year_food_prices_wages_changes AS
SELECT
    t1.year AS year,
    (t1.avg_price_value - t2.avg_price_value) / t2.avg_price_value * 100 AS yearly_percentage_food_price_change,
    (t1.avg_payroll_value - t2.avg_payroll_value) / t2.avg_payroll_value * 100 AS yearly_percentage_wage_change
FROM
    temp_avg_prices_and_wages_by_year t1
JOIN
    temp_avg_prices_and_wages_by_year t2 ON t1.year = t2.year + 1;
   

 
--Zjištění, zda existuje rok, ve kterém byl meziroční nárůst cen 
potravin výrazně vyšší než růst mezd (větší než 10 %)


SELECT
    year,
    yearly_percentage_food_price_change,
    yearly_percentage_wage_change,
    yearly_percentage_food_price_change - yearly_percentage_wage_change AS difference
FROM
    temp_year_over_year_food_prices_wages_changes
WHERE
    yearly_percentage_food_price_change - yearly_percentage_wage_change > 10;