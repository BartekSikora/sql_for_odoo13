-- Executing the query will return a CSV file with a list of product stock necessary to process waiting warehouse orders.

SELECT
product_template.name AS "Product",
product_product.default_code AS "SKU",
ROUND(SUM(stock_move.product_uom_qty), 2) AS "Qty"
FROM sale_order

LEFT JOIN stock_picking ON sale_order.name = stock_picking.origin
LEFT JOIN stock_move ON stock_picking.id = stock_move.picking_id
LEFT JOIN product_product ON stock_move.product_id = product_product.id
LEFT JOIN product_template ON product_product."product_tmpl_id" = product_template.id

WHERE stock_move.state = 'confirmed'

GROUP BY product_template.name, product_product.default_code

ORDER BY product_template.name ASC, product_product.default_code ASC
