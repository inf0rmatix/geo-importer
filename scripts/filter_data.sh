#!/bin/bash
set -e

cd /data

# Konfigurierbare Filter
LANG_FILTER="${GEONAMES_LANG:-de}"
FEATURE_CLASS_FILTER="${GEONAMES_FEATURE_CLASS:-P|A|L}"

ADMIN_FILTER="ADM1|ADM2|ADMD"
LOCATION_FILTER="AMUS|CMN|CTRB|PRK"
POPULATED_PLACE_FILTER="PPLC|PPLA|PPL|PPLR"

FEATURE_CODES="${GEONAMES_FEATURE_CODES:-${ADMIN_FILTER}|${LOCATION_FILTER}|${POPULATED_PLACE_FILTER}}"

echo "Filtering data with the following criteria:"
echo "Language: $LANG_FILTER"
echo "Feature class: $FEATURE_CLASS_FILTER"
echo "Feature codes: $FEATURE_CODES"

# Filter für allCountries.txt: feature_class = 'P' oder 'A', feature_code in Liste, immer 19 Spalten, numerische Felder auf \N
awk -F'\t' '($7 ~ /^('"$FEATURE_CLASS_FILTER"')$/) && ($8 ~ /^('"$FEATURE_CODES"')$/) {
  for(i=NF+1;i<=19;i++) $i="";
  for(i=1;i<=19;i++) if((i==1||i==5||i==6||i==15||i==16||i==17)&&$i=="") $i="\\N";
  OFS="\t";
  print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19
}' allCountries.txt > filtered_all.txt


# GeonameIDs extrahieren
awk -F'\t' '{print $1}' filtered_all.txt | sort -u > filtered_geonameids.txt

# Filter für alternateNamesV2.txt: nur deutsche Sprache und passende geonameid, auf 11 Spalten auffüllen, boolsche Felder und Datumsfelder robust für Postgres
awk '
  BEGIN { FS = "\t"; OFS = "|" }
  NR==FNR { ids[$1]; next }
  $3=="de" && ($2 in ids) {
    # Auf genau 11 Felder auffüllen
    for(i=NF+1; i<=11; i++) $i = "\\N"
    NF = 11

    # Boolean-Felder 5–8
    for(i=5; i<=8; i++){
      $i = ($i=="1" ? "true" : ($i=="0" ? "false" : "\\N"))
    }

    # Datumsfelder 9=from_, 10=to_
    for(i=9; i<=10; i++){
      # 1) Versteckte CRs entfernen
      gsub(/\r/, "", $i)
      # 2) führende/trailende Spaces/Tabs entfernen
      gsub(/^[ \t]+|[ \t]+$/, "", $i)
      # 3) Umwandlung: reines Jahr → YYYY-01-01
      if ($i ~ /^[0-9][0-9][0-9][0-9]$/) {
        $i = $i "-01-01"
      }
      # 4) leere Felder oder "\N" bleiben \N
      else if ($i == "" || $i == "\\N") {
        $i = "\\N"
      }
      # sonst (z.B. schon YYYY-MM-DD) unverändert lassen
    }

    print
  }
' filtered_geonameids.txt alternateNamesV2.txt > filtered_alt.psv
