#!/bin/bash
set -e

# Optional: Sprache und Feature-Codes für Filterung setzen
# GEONAMES_LANG (z.B. de, en, fr)
# GEONAMES_FEATURE_CODES (z.B. PPLC|PPLA|PPL|ADM1|ADM2)

# Warten bis die DB bereit ist
until pg_isready -h "$PGHOST" -U "$PGUSER"; do
  echo "Warte auf Datenbank..."
  sleep 2
done

echo "Starte Schema-Initialisierung..."
./scripts/init_schema.sh

echo "Starte Download und Entpacken..."
./scripts/download_and_extract.sh

echo "Starte Filterung..."
./scripts/filter_data.sh

echo "Starte Import..."
./scripts/import_data.sh

echo "Import abgeschlossen."
exit 0
