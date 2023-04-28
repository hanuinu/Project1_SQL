--Vytvořím si dvě dočasné tabulky, jednu pro czechia_payroll 
a druhou pro czechia_price. Czechia payroll spojím s czechia_industry_branch 
pro zobrazení kódů odvětví
--Tabulka czechia_payroll obsahuje data z let 2000-2021 a tabulka czechia_price 2006-2018, 
Nejlepší je řešit rozdíly v letech už v dočasných tabulkách tak, abychom měli přehlednější 
a čistější finální tabulku.
Pro dočasnou tabulku temp_czechia_price i temp_czechia_payroll upravím SQL dotaz tak, 
aby obsahoval pouze data z let 2006-2018:
--chci získat co nejpřesnější a spolehlivé výsledky, zaměřím se tedy pouze na 
fyzické hodnoty mezd (code = 100)
--u tabulky czechia payroll jsou nějaké nulové hodnoty ve sloupci industry_branch_code, použijeme tedy LEFT JOIN, abychom neztratily některé informace
--ve sloupci value máme nulové hodnoty, vypočítáme tedy průměrný plat za každý rok
--ve sloupci industry_branch_code máme NULL hodnoty, ty tedy eliminujeme - cp.industry_branch_code IS NOT NULL

CREATE TEMPORARY TABLE temp_czechia_payroll AS
    SELECT
        cp.payroll_year  AS 'year',
        cp.industry_branch_code,
        cpi.name  AS industry_branch_name,
        round(avg(cp.value))  AS avg_payroll_value
    FROM czechia_payroll cp
    LEFT JOIN czechia_payroll_industry_branch cpi
    ON cp.industry_branch_code  = cpi.code 
    WHERE cp.value_type_code  = 5958
    AND cp.calculation_code  = 100
    AND cp.payroll_year BETWEEN 2006 AND 2018
    AND cp.industry_branch_code IS NOT NULL
    GROUP BY cp.industry_branch_code, cp.payroll_year 
    ORDER BY cp.industry_branch_code, cp.payroll_year;
   
--Pro vytvoření dočasné tabulky temp_czechia_price  použiji  příkaz, který extrahuje rok z date_from a spojuje 
tabulky czechia_price a czechia_price_category podle category_code a vypočítá prměrnou cenu zboží za rok pro jednotlivé kategoie zaokrouhlenou na dvě desetinná místa:
  
  
   
   CREATE TEMPORARY TABLE temp_czechia_price AS
    SELECT
        YEAR(cp.date_from) AS 'year',
        cp.category_code,
        cpc.name AS category_name,
        round(AVG(cp.value),2)  AS avg_price_value,
        cpc.price_unit
    FROM czechia_price cp
    JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code
    WHERE YEAR(cp.date_from) BETWEEN 2006 AND 2018
    GROUP BY YEAR(cp.date_from), cp.category_code;
   
--mám vytvořeny dvě dočasné tabulky   temp_czechia_price a temp_czechia_payroll
--nyní je spojím na základě let


   CREATE TABLE t_hana_plichtova_project_SQL_primary_final AS
SELECT
    tcpay.year,
    tcpay.industry_branch_code,
    tcpay.industry_branch_name,
    tcpay.avg_payroll_value,
    tcp.category_code,
    tcp.category_name,
    tcp.avg_price_value,
    tcp.price_unit
FROM temp_czechia_payroll tcpay
JOIN temp_czechia_price tcp
ON tcpay.year = tcp.year;


SELECT * FROM temp_czechia_price
WHERE category_code=118101;

SELECT * FROM temp_czechia_price
WHERE category_code=115201;
