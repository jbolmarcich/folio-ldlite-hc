-- New script in ldplite.
-- Date: Feb 1, 2024
-- Time: 10:10:24 AM
with holdings_note as (
	select 
		distinct hrtn.id as "holdings uuid",
		string_agg(
			hrtn.notes__note,
			' | '
		) as holdings_notes
	from
		inventory.holdings_record__t__notes hrtn
	group by
		hrtn.id
),
holdings_statement as (
	select
		distinct hrts.id as "holdings uuid",
		string_agg(
			hrts.holdings_statements__statement,
			' | '
		) as holdings_statements,
		string_agg(
			hrts.holdings_statements__note,
			' | '
		) as holdings_statements_notes
	from
		inventory.holdings_record__t__holdings_statements hrts
	group by
		hrts.id
)
select
	distinct hrt.id as "holdings uuid",
	m.instance_id,
	m.instance_hrid,
	hrt.hrid as "holdings hrid",
	hstm.holdings_statements,
	hstm.holdings_statements_notes,
	hono.holdings_notes
from
	folio_source_record.marctab m
left join inventory.instance__t it on
	it.id::uuid = m.instance_id::uuid
left join inventory.holdings_record__t hrt on
	hrt.instance_id::uuid = m.instance_id::uuid
left join inventory.location__t lt on
	lt.id = hrt.permanent_location_id
left join holdings_note hono on
	hono."holdings uuid" = hrt.id
left join holdings_statement hstm on
	hstm."holdings uuid" = hrt.id
where
	m.field = '000'
	and 
    substring(
		m.CONTENT,
		8,
		1
	) = 's'
	and 
    lt.code in (
		'UMGEN', 'USGEN', 'USPER', 'UEA', 'UNEA', 'UMPER'
	)
	and 
    (
		it.discovery_suppress is false
			or it.discovery_suppress is null
	)
group by
	hrt.id,
	m.instance_id,
	m.instance_hrid,
	hrt.hrid,
	hstm.holdings_statements,
	hstm.holdings_statements_notes,
	hono.holdings_notes;