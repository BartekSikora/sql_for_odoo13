-- Wykonanie zapytania pobierze plik CSV z listą zamówień zakupu oraz powiązanych z nimi przesunięć magazynowych.
-- Eksport zawiera daty planowanego i faktycznego przyjęcia, a ostatnia kolumna informuje czy dostawa była terminowa.
-- Do otwarcia pliku sugerujemy OpenOffice Calc z zestawem znaków UTF-8. W Excel przy domyślnych ustawieniach mogą wystąpić problemy z formatowaniem liczb i polskich znaków.

SELECT
purchase_order.name AS "Numer zamówienia zakupu",
purchase_order.partner_ref AS "Numer dostawcy",
moves.partner_name AS "Dostawca",
DATE(purchase_order.date_order) AS "Data zamówienia",
DATE(purchase_order.date_approve) AS "Data potwierdzenia",
moves.picking_name AS "Numer przesunięcia",
DATE(moves.picking_scheduled_date) AS "Planowana data dostawy",
DATE(moves.picking_date_done) AS "Data przesunięcia",

CASE
WHEN (moves.picking_scheduled_date::date - moves.picking_date_done::date) > 0 THEN 'Przedwczesna'
WHEN (moves.picking_scheduled_date::date - moves.picking_date_done::date) = 0 THEN 'Terminowa'
WHEN (moves.picking_scheduled_date::date - moves.picking_date_done::date) < 0 THEN 'Opóźniona'
ELSE 'Oczekuje'
END AS "Terminowość"

FROM 
(
SELECT
procurement_group.id AS "procurement_group_id",
res_partner.name AS "partner_name",
stock_picking.name AS "picking_name",
stock_picking.scheduled_date AS "picking_scheduled_date",
stock_picking.date_done AS "picking_date_done"
FROM procurement_group

LEFT JOIN res_partner ON res_partner.id = procurement_group.partner_id
LEFT JOIN stock_picking ON stock_picking.group_id = procurement_group.id) AS "moves"

LEFT JOIN purchase_order ON purchase_order.group_id = moves.procurement_group_id

WHERE purchase_order.state IN ('purchase', 'done')

ORDER BY purchase_order.name
