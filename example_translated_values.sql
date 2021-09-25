-- This example showcases how to export translations instead of base values. 
-- The query will return list of base names of countries (in english) as well as their polish equivalents.
-- Use OpenOffice Calc with UTF-8 encoding to avoid formatting problems.

SELECT 
translations.res_id AS "ID zasobu",
res_country.name AS "Nazwa bazowa",
translations.value AS "Nazwa polska"
FROM 
(
SELECT
res_id,
value
FROM ir_translation

WHERE name = 'res.country,name' AND lang = 'pl_PL') AS translations

LEFT JOIN res_country ON res_country.id = translations.res_id

ORDER BY translations.res_id
