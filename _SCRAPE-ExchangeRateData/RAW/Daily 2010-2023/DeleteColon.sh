#!/bin/bash

input_file="input.csv"   # Specify the input file name
output_file="output.csv" # Specify the output file name

# Use awk to search each entry and delete text after the colon
awk 'BEGIN{FS=OFS=","} {for (i=1; i<=NF; i++) sub(/:.*/, "", $i)} 1' "$input_file" > "$output_file"

echo "Text after the colon has been deleted from each entry. Output file: $output_file"
