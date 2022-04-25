SELECT 
subquerry.product_name AS "Product",
subquerry.default_code AS "SKU",
subquerry.barcode AS "Barcode",
ROUND(stock_valuation_layer.remaining_qty, 0) AS "Remaining amount",
ROUND(stock_valuation_layer.unit_cost, 2) AS "Unit cost",
ROUND(stock_valuation_layer.remaining_value, 2) AS "Remaining value",
stock_valuation_layer.description AS "Source document"
FROM
(
SELECT
product_product.id AS "product_id",
product_template.name AS "product_name",
product_product.default_code AS "default_code" ,
product_product.barcode AS "barcode"
FROM product_product

LEFT JOIN product_template ON product_product.product_tmpl_id = product_template.id) AS subquerry

LEFT JOIN stock_valuation_layer ON stock_valuation_layer.product_id = subquerry.product_id

WHERE stock_valuation_layer.remaining_qty > 0

ORDER BY subquerry.default_code ASC
