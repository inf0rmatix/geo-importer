#!/bin/bash
set -e

psql -f /sql/init_schema.sql
