  
   
Vytvoření sekundární tabulky t_{jmeno}_{prijmeni}_project_SQL_secondary_final, která obsahuje dodatečná data o dalších evropských státech, budu potřebovat spojit tabulky economies a countries a filtrovat data pouze pro evropské země.

   
CREATE TABLE t_hana_plichtova_project_SQL_secondary_final AS
SELECT
    e.country,
    e.year,
    e.GDP,
    e.population,
    e.gini,
    c.continent
FROM
    economies AS e
    JOIN countries AS c ON e.country = c.country
WHERE
    c.continent = 'Europe'
    AND e.year >= 2006
    AND e.year <= 2018;


