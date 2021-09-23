-- Wykonanie zapytania pobierze plik CSV zawierający listę ilości i ceny jednostkowe produktów przesuniętych przez dokumenty danego typu w danym okresie. 
-- W Excelu może występować problem z formatem dat. W takim przypadku plik należy otworzyć przy użyciu darmowego OpenOffice Calc. 

SELECT 
DISTINCT(stock_move.id) AS "ID pozycji", 
stock_picking.name AS "Przesunięcie", 
stock_move.name AS "Produkt", 
stock_move.product_uom_qty AS "Ilość", 
stock_valuation_layer.unit_cost AS "Cena jednostkowa", 
stock_move.product_uom_qty * stock_valuation_layer.unit_cost AS "Suma" 
FROM stock_move

LEFT JOIN stock_picking ON stock_move.picking_id = stock_picking.id 
LEFT JOIN stock_valuation_layer ON stock_valuation_layer.product_id = stock_move.product_id 

-- W wierszu poniżej należy wprowadzić numerację przesunięć oraz zakres dat ich wykonania
WHERE stock_picking.name LIKE 'MG/WZ/%' AND stock_picking.date_done BETWEEN '2021-08-01 00:00:00' AND '2021-08-31 23:59:59'
