#!/bin/bash
echo 'Dropping/creating schema, user, tables, etc.'
psql -e -f recreate.sql -U postgres harbinger
export PGPASSWORD=r3sr3v13w!!
psql -e -f examtracker-schema.sql -U examtracker harbinger
psql -e -f examtracker-data.sql -U examtracker harbinger
