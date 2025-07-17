# Dockerfile für GeoNames-Importer (ARM-kompatibel)
FROM postgres:15

# Installiere benötigte Tools (ARM-kompatibel)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        unzip \
        grep \
        pv \
    && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Skripte kopieren und ausführbar machen
COPY entrypoint.sh ./
COPY scripts/ ./scripts/
RUN chmod +x ./entrypoint.sh ./scripts/*.sh

# Entry-Point setzen
ENTRYPOINT ["./entrypoint.sh"]
