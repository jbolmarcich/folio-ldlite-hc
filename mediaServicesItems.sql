-- This query returns the holdings UUID and HRID, the instance UUID and HRID, instance title --
-- the instance identifiers only for the Previous Aleph System number, item barcode, item --
-- material type, item note only for type Legacy Circ Count, item status, and item loan --
-- type for any barcodes in the FOLIO Location of HC Media Services Equipment --

SELECT 
	hrt.id AS holdings_uuid,
	hrt.hrid AS holdings_hrid,
	hrt.instance_id AS instance_uuid,
	it2.hrid AS instance_hrid,
	it2.title AS instance_title,
	it.barcode,
	iti.identifiers__value AS identifier,
	mtt.name AS item_material_type_name,
	itn.notes__note AS item_circ,
	lo.name AS loan_name,
	it.status__name AS item_status
	
FROM 
	inventory.holdings_record__t AS hrt
	LEFT JOIN inventory.item__t AS it ON it.holdings_record_id = hrt.id
	LEFT JOIN inventory.instance__t AS it2 ON it2.id = hrt.instance_id 
	LEFT JOIN inventory.material_type__t AS mtt ON mtt.id = it.material_type_id 
	LEFT JOIN inventory.instance__t__identifiers AS iti ON iti.id = it2.id
	LEFT JOIN inventory.loan_type__t AS lo ON lo.id = it.permanent_loan_type_id
	LEFT JOIN inventory.item__t__notes AS itn ON itn.barcode = it.barcode
WHERE
	hrt.permanent_location_id = 'dcfef97d-3340-4f48-a1bc-ac25fad65c6f'
AND 
	iti.identifiers__identifier_type_id = '11effde5-6bf4-49ac-b9a4-040ef765ed88'
AND 	
	itn.notes__item_note_type_id = 'f765f19f-9f1c-4688-8c79-ec366a730842'
