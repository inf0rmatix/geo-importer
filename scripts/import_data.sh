#!/bin/bash
set -e

cd /data

psql -f /sql/import_settings.sql

# Temporäre Tabellen leeren
psql -c "TRUNCATE raw_all;"
psql -c "TRUNCATE raw_alt;"

# Importiere gefilterte Daten
pv filtered_all.txt | psql -c "COPY raw_all FROM STDIN WITH (FORMAT text, DELIMITER E'\t', NULL '\\N');"
# pv filtered_alt.txt | psql -c "COPY raw_alt FROM STDIN WITH (FORMAT text, DELIMITER E'\t', NULL '\\N');"
pv filtered_alt.psv \
  | psql -c "COPY raw_alt
              FROM STDIN
              WITH (
                FORMAT text,
                DELIMITER '|',
                NULL '\\N'
              );"

# Importiere Daten in location und name_translation
psql -f /sql/import_location.sql
psql -f /sql/import_name_translation.sql
