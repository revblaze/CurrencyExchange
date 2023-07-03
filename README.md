# CurrencyExchange
Calculate international exchange rates using local resources and SQLite

`currency > USD > currency`

## Source Route

Download the latest unorganized exchange rate data from source: `https://www.bis.org/statistics/full_xru_d_csv_row.zip`

The resulting CSV data will be formatted accordingly (sample from 2010):

<img width="1194" alt="Screenshot 2023-07-03 at 1 37 19 PM" src="https://github.com/revblaze/CurrencyExchange/assets/1476332/6c2042ee-7578-4564-8cfa-00bf14d892d4">


### Initial thoughts
- Table reformatting: Currency Code (row A to Z*+), Date (column A: 10 to n)
- Rows pending deletion (unnecessary information): `1, 2, 4-9`
- Reformat row "Currency": for each entry, remove all text including and after the `:` colon
  - This will provide us with accruate currency codes

### Data notes
- Some values are either missing or `NaN`
  - This is due to either a weekend, extended holiday or other possible reasons yet to be explored
  - Most purchases are registered as 'pending' until the next available business day
  - Thus, currencies conversions may not to be conditioned for the next available rate
- Some results are of the same value throughout (see column B, UAE currency `AED`)
  - This is due to the value being pegged to the US dollar, which we are comparing against
- The Euro (`EUR`) has multiple identical columns

### Parsing with bash

Traverse CSV data format, removing instances of `:*` (elongated: `/:.*/, "", $i)`)
```bash
awk 'BEGIN{FS=OFS=","} {for (i=1; i<=NF; i++) sub(/:.*/, "", $i)} 1' "$input_file" > "$output_file"
```

Removing duplicate columns
```bash
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
```

### SQLite conversion

```bash
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
```

with command: `./csv_to_sqlite.sh path/to/your/csv_file.csv`
