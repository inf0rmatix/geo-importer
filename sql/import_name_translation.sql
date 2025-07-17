INSERT INTO name_translation (
        geonameid,
        language,
        name,
        is_preferred,
        is_short,
        is_colloquial,
        is_historic,
        from_,
        to_,
        entity_type
    )
SELECT a.geonameid,
    a.isoLanguage,
    a.alternateName,
    a.isPreferredName,
    a.isShortName,
    a.isColloquial,
    a.isHistoric,
    a.from_,
    a.to_,
    a.entityType
FROM raw_alt a
    JOIN location l ON a.geonameid = l.geonameid ON CONFLICT DO NOTHING;