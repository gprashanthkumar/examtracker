#!/bin/bash
echo 'Dumping schema structure...'
apgdiff --ignore-start-with /dev/null <(pg_dump -O -s -x -n examtracker -U postgres harbinger) > examtracker-schema.sql
