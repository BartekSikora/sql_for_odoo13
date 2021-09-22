SELECT
res_partner.id AS "ID",

CASE WHEN res_partner.active = 't' THEN 'Tak'
WHEN res_partner.active = 'f' THEN 'Nie'
ELSE 'BŁĄD'
END AS "Aktywny",

CASE WHEN res_partner.is_company = 't' THEN 'Tak'
WHEN res_partner.is_company = 'f' THEN 'Nie'
ELSE 'BŁĄD'
END AS "Firma",

CASE WHEN res_partner.supplier_rank = 0 THEN 'Nie'
WHEN res_partner.supplier_rank >= 1 THEN 'Tak'
ELSE 'BŁĄD'
END AS "Dostawca",

CASE WHEN res_partner.customer_rank = 0 THEN 'Nie'
WHEN res_partner.customer_rank >= 1 THEN 'Tak'
ELSE 'BŁĄD'
END AS "Klient",

CASE WHEN res_partner.type = 'contact' THEN 'Kontakt'
WHEN res_partner.type = 'delivery' THEN 'Adres dostawy'
WHEN res_partner.type = 'invoice' THEN 'Adres rozliczeniowy'
ELSE 'Inny'
END AS "Typ",

res_partner.parent_id AS "ID kontaktu nadrzędnego",
res_partner.name AS "Nazwa",
res_partner.vat AS "NIP",
res_partner.regon AS "REGON",
res_partner.krs AS "KRS",
res_partner.street AS "Ulica",
res_partner.street2 AS "Ulica cd.",
res_partner.zip AS "Kod pocztowy",
res_partner.city AS "Miasto",
res_country.code AS "Kraj",
res_partner.lang AS "Język",
res_partner.email AS "Email",
res_partner.phone AS "Telefon stacjonarny",
res_partner.mobile AS "Telefon komórkowy"
FROM res_partner

LEFT JOIN res_country ON res_country.id = res_partner.country_id

ORDER BY res_partner.id ASC
