-- Wykonanie zapytania pobierze plik CSV zawierający listę wartości dokumentów sprzedaży i powiązanych przesunięć magazynowych oraz wyliczoną z ich różnicy marżę.
-- Do otwarcia pliku sugerujemy OpenOffice Calc z zestawem znaków UTF-8. W Excel przy domyślnych ustawieniach mogą wystąpić problemy z formatowaniem liczb i polskich znaków.

SELECT 
subquery.invoice_date AS "Data wystawienia",
subquery.team_name AS "Kanał",
subquery.name AS "Numer", 
subquery.amount_total AS "Suma brutto",
subquery.amount_tax AS "Suma podatku",
subquery.amount_untaxed AS "Suma netto", 
ROUND(sum(subquery.value), 2) AS "Wartość przesunięć",
ROUND(sum(subquery.margin), 2) AS "Marża"
FROM 
(
SELECT 
account_move.state AS "state", 
account_move.name AS "name", 
account_move.invoice_date AS "invoice_date", 
account_move.invoice_type AS "invoice_type",
account_move.type AS "type",
account_move.amount_total AS "amount_total", 
account_move.amount_untaxed AS "amount_untaxed", 
account_move.amount_tax AS "amount_tax",
account_move_line.exclude_from_invoice_tab AS "exclude_from_invoice_tab", 
account_move_line.invoice_line_net AS "Account Move Line__invoice_line_net", 
account_move_line.invoice_line_net + stock_valuation_layer.value AS "margin", 
stock_valuation_layer.value AS "value",
crm_team.name AS "team_name"
FROM account_move

LEFT JOIN account_move_line ON account_move.id = account_move_line .move_id
LEFT JOIN product_product ON account_move_line .product_id = product_product .id
LEFT JOIN product_template ON product_product .product_tmpl_id = product_template .id
LEFT JOIN stock_move_invoice_line_rel ON account_move_line .id = stock_move_invoice_line_rel.invoice_line_id
LEFT JOIN stock_valuation_layer ON stock_move_invoice_line_rel.move_id = stock_valuation_layer.stock_move_id
LEFT JOIN crm_team ON crm_team.id = account_move.team_id) AS subquery

WHERE subquery.invoice_type IN ('invoice', 'receipt', 'name_invoice')
AND subquery.type = 'out_invoice'
AND subquery.exclude_from_invoice_tab = FALSE 
AND subquery.state = 'posted'

GROUP BY 
subquery.invoice_date, 
subquery.team_name, 
subquery.name, 
subquery.amount_total, 
subquery.amount_untaxed, 
subquery.amount_tax

ORDER BY subquery.invoice_date
