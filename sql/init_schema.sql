-- Temporäre Tabellen für Rohdaten (angepasste Spaltentypen nach GeoNames)
CREATE TABLE IF NOT EXISTS raw_all (
    geonameid INTEGER,
    name TEXT,
    asciiname TEXT,
    alternatenames TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    feature_class CHAR(1),
    feature_code VARCHAR(10),
    country_code CHAR(2),
    cc2 VARCHAR(60),
    admin1_code VARCHAR(20),
    admin2_code VARCHAR(80),
    admin3_code VARCHAR(20),
    admin4_code VARCHAR(20),
    population BIGINT,
    elevation INTEGER,
    dem INTEGER,
    timezone VARCHAR(40),
    modification_date DATE
);
CREATE TABLE IF NOT EXISTS raw_alt (
    alternateNameId INTEGER,
    geonameid INTEGER,
    isoLanguage VARCHAR(7),
    alternateName TEXT,
    isPreferredName BOOLEAN,
    isShortName BOOLEAN,
    isColloquial BOOLEAN,
    isHistoric BOOLEAN,
    from_ DATE NULL,
    to_ DATE NULL,
    entityType TEXT
);
CREATE TABLE IF NOT EXISTS location (
    geonameid INTEGER PRIMARY KEY,
    name TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    feature_class CHAR(1),
    feature_code VARCHAR(10),
    country_code CHAR(2),
    type VARCHAR(10) -- 'place' or 'region'
);
CREATE TABLE IF NOT EXISTS name_translation (
    id SERIAL PRIMARY KEY,
    geonameid INTEGER NOT NULL,
    language VARCHAR(7) NOT NULL,
    name TEXT NOT NULL,
    is_preferred BOOLEAN,
    is_short BOOLEAN,
    is_colloquial BOOLEAN,
    is_historic BOOLEAN,
    from_ DATE NULL,
    to_ DATE NULL,
    entity_type TEXT,
    FOREIGN KEY (geonameid) REFERENCES location(geonameid) ON DELETE CASCADE
);