-- Import places
INSERT INTO location (
        geonameid,
        name,
        latitude,
        longitude,
        feature_class,
        feature_code,
        country_code,
        type
    )
SELECT r.geonameid,
    r.name,
    r.latitude,
    r.longitude,
    r.feature_class,
    r.feature_code,
    r.country_code,
    'place'
FROM raw_all r
WHERE r.feature_class = 'P'
    AND r.feature_code IN ('PPLC', 'PPLA', 'PPL') ON CONFLICT (geonameid) DO
UPDATE
SET name = EXCLUDED.name,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    feature_class = EXCLUDED.feature_class,
    feature_code = EXCLUDED.feature_code,
    country_code = EXCLUDED.country_code,
    type = EXCLUDED.type;
-- Import regions
INSERT INTO location (
        geonameid,
        name,
        latitude,
        longitude,
        feature_class,
        feature_code,
        country_code,
        type
    )
SELECT r.geonameid,
    r.name,
    r.latitude,
    r.longitude,
    r.feature_class,
    r.feature_code,
    r.country_code,
    'region'
FROM raw_all r
WHERE r.feature_class = 'A'
    AND r.feature_code IN ('ADM1', 'ADM2') ON CONFLICT (geonameid) DO
UPDATE
SET name = EXCLUDED.name,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    feature_class = EXCLUDED.feature_class,
    feature_code = EXCLUDED.feature_code,
    country_code = EXCLUDED.country_code,
    type = EXCLUDED.type;