# How to run the benchmark
- Install Dafny, Go, Java, Python and C\# and add all of them to your `PATH`
- Provide a csv file in the format quiz, solution with each sudoku board quiz being represented as 81 numbers. An example database (the one we used) can be downloaded from https://www.kaggle.com/datasets/bryanpark/sudoku
- Run `python benchmark.py` (additional args here https://github.com/TheHippos/Dafny_DAIMPL/blob/main/benchmark.py#L83)
    - The output will tell you how to name and where to put the Sudoku puzzles CSV file
- Results will be in `benchmark_results.csv`
