--Otázka č. 2 Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

 
--Vytvoření pohledu s průměrnými cenami mléka, chleba a průměrnou mzdou pro každý rok

 CREATE VIEW milk_and_bread_view AS
  SELECT
    year,
    AVG(CASE WHEN category_code = 114201 THEN avg_price_value END) AS avg_milk_price,
    AVG(CASE WHEN category_code = 111301 THEN avg_price_value END) AS avg_bread_price,
    AVG(avg_payroll_value) AS avg_payroll
  FROM
    t_hana_plichtova_project_SQL_primary_final
  GROUP BY
    year;
   
--Výpočet litrů mléka a kilogramů chleba, které je možné si koupit v prvním a posledním srovnatelném období, pomocí vytvořeného pohledu:

SELECT
  year,
  round(avg_payroll / avg_milk_price)  AS liters_of_milk,
  round(avg_payroll / avg_bread_price)  AS kg_of_bread
FROM
  milk_and_bread_view
WHERE
  year IN (2006, 2018);


