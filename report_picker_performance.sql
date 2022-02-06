-- Executing the query will return a CSV file with a list of employees and a number of processed pick lists between the specified dates.
-- Report is not perfect due to model limitations. It would be best to show the number of retrieved products instead of pick lists.
-- This query uses custom model not available in standard inventory app. Executing without the right plugin will result in "relation does not exist" error.

SELECT
res_users.login AS "Employee",
COUNT(sale_order_package.id) AS "Number of pick lists"
FROM sale_order_package

LEFT JOIN res_users ON res_users.id = sale_order_package.collecting_user

-- Define dates below. Only pick lists with state done are taken into account.
WHERE sale_order_package.create_date BETWEEN '2022-01-01 00:00:00' AND '2022-01-31 23:59:59' AND sale_order_package.state = 'done'

GROUP BY res_users.login
