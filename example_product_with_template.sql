-- This example shows how to connect product.product with its product.template. 
-- The query will return list of products with their codes (SKU).
-- Use OpenOffice Calc with UTF-8 encoding to avoid formatting problems.

SELECT 
product_template.name AS "Produkt", 
product_product.default_code AS "SKU" 
FROM product_product

LEFT JOIN product_template ON product_product.product_tmpl_id = product_template.id
