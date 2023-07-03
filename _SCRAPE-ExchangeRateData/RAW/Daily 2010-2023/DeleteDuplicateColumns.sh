#!/bin/bash

input_file="input_col.csv"   # Specify the input file name
output_file="output_col.csv" # Specify the output file name

# Use awk to search for duplicate text in the first row and delete corresponding columns
awk -F',' '
NR == 1 {
  for (i=1; i<=NF; i++) {
    if (++seen[$i] > 1) {
      delete_col[i] = 1
    }
  }
}
{
  for (i=1; i<=NF; i++) {
    if (!(i in delete_col)) {
      printf "%s%s", $i, (i == NF ? RS : FS)
    }
  }
}' "$input_file" > "$output_file"

echo "Duplicate columns have been deleted. Output file: $output_file"
