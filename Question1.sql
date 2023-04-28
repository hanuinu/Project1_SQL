
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?


----Pokud chceme porovnat všechny první a poslední rok

SELECT
    t_final.industry_branch_name,
    MIN(t_final.year) AS first_year,
    MAX(t_final.year) AS last_year,
    MIN(t_final.avg_payroll_value) AS first_year_payroll,
    MAX(t_final.avg_payroll_value) AS last_year_payroll,
    (MAX(t_final.avg_payroll_value) - MIN(t_final.avg_payroll_value)) AS payroll_difference,
    ((MAX(t_final.avg_payroll_value) - MIN(t_final.avg_payroll_value)) / MIN(t_final.avg_payroll_value)) * 100 AS payroll_growth_percentage
FROM t_hana_plichtova_project_SQL_primary_final AS t_final
GROUP BY t_final.industry_branch_name
ORDER BY payroll_growth_percentage DESC;

--Pokud chceme porovnat všechny roky


POMOCÍ VIEW: 

CREATE VIEW payroll_changes_view AS
SELECT
    thppf.year,
    thppf.industry_branch_code,
    thppf.industry_branch_name,
    thppf.avg_payroll_value - LAG(thppf.avg_payroll_value) OVER (PARTITION BY thppf.industry_branch_code ORDER BY thppf.year) AS payroll_difference
FROM t_hana_plichtova_project_SQL_primary_final thppf
WHERE thppf.year IN (2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018);


SELECT DISTINCT
    year,
    industry_branch_name,
    CASE 
        WHEN SUM(payroll_difference) > 0 THEN 'Růst'
        WHEN SUM(payroll_difference) < 0 THEN 'Pokles'
        ELSE 'Beze změny'
    END AS payroll_trend
FROM payroll_changes_view
WHERE payroll_difference IS NOT NULL
GROUP BY year, industry_branch_name
ORDER BY year, industry_branch_name;
