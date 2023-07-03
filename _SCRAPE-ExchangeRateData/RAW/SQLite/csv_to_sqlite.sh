#!/bin/bash

# Check if the CSV file argument is provided
if [ $# -eq 0 ]; then
  echo "Please provide the path to the CSV file as an argument."
  exit 1
fi

# CSV file path
csv_file=$1

# SQLite database path
db_file="${csv_file%.*}.db"

# Create a new SQLite database file
sqlite3 $db_file <<EOF
.mode csv
.import $csv_file exchange_rates
.quit
EOF

# Display success message
echo "Conversion complete. SQLite database created at: $db_file"
