#!/bin/bash
set -e

cd /data

# allCountries.zip
if [ ! -f allCountries.zip ]; then
  wget --progress=dot:mega -O allCountries.zip "$GEONAMES_URL_ALL"
else
  wget --progress=dot:mega -N "$GEONAMES_URL_ALL"
fi

# alternateNamesV2.zip
if [ ! -f alternateNamesV2.zip ]; then
  wget --progress=dot:mega -O alternateNamesV2.zip "$GEONAMES_URL_ALT"
else
  wget --progress=dot:mega -N "$GEONAMES_URL_ALT"
fi

unzip -o allCountries.zip
unzip -o alternateNamesV2.zip
