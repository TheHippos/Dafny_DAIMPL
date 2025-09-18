import csv

input_file = "sudoku.csv"

# Read and process rows
with open(input_file, newline="", encoding="utf-8") as infile:
    reader = csv.reader(infile)
    next(reader)  # skip header
    rows = [[row[0]] for row in reader]  # keep only first column

# Overwrite the same file
with open(input_file, "w", newline="", encoding="utf-8") as outfile:
    writer = csv.writer(outfile)
    writer.writerows(rows)