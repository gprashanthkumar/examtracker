#!/bin/bash
echo 'Dumping data tables...'
pg_dump -U examtracker harbinger -a --column-inserts \
 -t examtracker_demo_items > examtracker-data.sql
