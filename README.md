# GeoNames Importer

**Work in Progress:** This project is actively being developed, and contributions are highly encouraged! If you're interested in using or improving it, your input is more than welcome.

GeoNames Importer aims to build a powerful, containerized database solution based on the rich [GeoNames](https://www.geonames.org/) dataset. The primary goal is to make it easy to fetch and work with geographic entities such as regions, countries, and cities—especially those relevant for vacation destination searches. By focusing on places that matter most to travelers and vacation planners, this project seeks to provide a solid foundation for travel, tourism, and location-based applications.

Currently, the workflow automates the download, filtering, and import of GeoNames data into a PostgreSQL database, with an emphasis on German-language and administrative geodata. The architecture is designed for reproducibility, ARM compatibility, and script-driven extensibility, making it suitable for a wide range of environments and future enhancements.

## Features

- **Automated download** of GeoNames datasets (`allCountries.zip`, `alternateNamesV2.zip`)
- **Filtering** for relevant languages (default: German) and feature codes (administrative, populated places, etc.)
- **Data import** into a PostgreSQL database with a custom schema
- **Fully containerized** using Docker and Docker Compose

## Project Structure

- `Dockerfile`: Builds an ARM-compatible image with PostgreSQL and required tools.
- `docker-compose.yml`: Defines two services:
  - `db`: PostgreSQL 15 database with persistent storage.
  - `importer`: Runs the import scripts and loads data into the database.
- `scripts/`: Contains all shell scripts for downloading, filtering, and importing data.
- `sql/`: SQL files for schema initialization and data import.

## Quick Start

### Prerequisites

- [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) installed.

### Steps

1. **Clone the repository**  

   ```sh
   git clone <this-repo-url>
   cd geo-importer
   ```

2. **Start the database and run the importer**  

   ```sh
   docker-compose up --build
   ```

   This will:
   - Start a PostgreSQL database (`db` service)
   - Build and run the importer container, which will:
     - Download and extract the GeoNames data
     - Filter the data for relevant entries
     - Initialize the database schema
     - Import the filtered data

3. **Access the database**  
   The database will be available on `localhost:5432` with:
   - Database: `geonames`
   - User: `geo`
   - Password: `geo_pass`

   You can connect using any PostgreSQL client:

   ```sh
   psql -h localhost -U geo -d geonames
   ```

## Script Overview

- `scripts/download_and_extract.sh`: Downloads and unzips the required GeoNames datasets.
- `scripts/filter_data.sh`: Filters the raw data for German language and specific feature codes, preparing it for import.
- `scripts/init_schema.sh`: Initializes the database schema using the provided SQL.
- `scripts/import_data.sh`: Loads the filtered data into the database and populates the main tables.

## Customization

- You can adjust filtering by setting environment variables in `docker-compose.yml` (e.g., `GEONAMES_LANG`, `GEONAMES_FEATURE_CLASS`, `GEONAMES_FEATURE_CODES`).
- SQL schema and import logic can be modified in the `sql/` directory.

## Data Volumes

- `pgdata`: Persists PostgreSQL data between runs.
- `temp`: Used for temporary storage of downloaded and processed files.

## License

[MIT](LICENSE) or your preferred license.

## Copyright and Data Source

This product includes data from [GeoNames](https://www.geonames.org/), which is made available under the [Creative Commons Attribution 4.0 License](https://creativecommons.org/licenses/by/4.0/).

> "The GeoNames geographical database covers all countries and contains over eleven million placenames that are available for download free of charge." ([GeoNames.org](https://www.geonames.org/))
