#!/usr/bin/env python3

from pathlib import Path
import subprocess
import sys
import os
import shutil
import argparse
import csv

# --- Project Folder Configuration ---
CSHARP_PROJECT_FOLDER = "Sudoku-cs"
GO_PROJECT_FOLDER = "Sudoku-go"
PYTHON_PROJECT_FOLDER = "Sudoku-py"
JAVA_PROJECT_FOLDER = "Sudoku-java"

# --- General Settings ---
DAFNY_SOURCE_FILE = "Sudoku.dfy"
PUZZLE_FILENAME = "sudoku.csv"
RESULTS_FILENAME = "benchmark_results.csv"


# ============================
# Do not edit below unless you know what you're doing
# ============================

def run_command_and_append(cmd, results_path, cwd=None, env={}):
    """
    Runs a command, prints its full output (stdout/stderr) to the console,
    and appends the output to the specified results file.
    """
    print("    running:", " ".join(map(str, cmd)))
    results_path = Path(results_path)
    results_path.parent.mkdir(parents=True, exist_ok=True)

    try:
        # Use capture_output=True to get stdout/stderr.
        # text=True decodes them as text.
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            encoding='utf-8',
            errors='replace',
            cwd=cwd,
            env={**os.environ.copy(), **env}
        )

        # Combine stdout and stderr to show all output.
        combined_output = ""
        if result.stdout:
            combined_output += result.stdout
        if result.stderr:
            combined_output += result.stderr

        # --- Print to Console ---
        if combined_output.strip():
            print("      --- Command Output ---")
            # Indent the output for readability in the console
            for line in combined_output.strip().split('\n'):
                print(f"      | {line}")
            print("      ----------------------")

        if result.returncode != 0:
            # Use a more visible error message in the console
            print(f"    ERROR: Command failed with exit code {result.returncode}.")

        # --- Append to File ---
        with results_path.open("a", encoding="utf-8", errors="replace") as f:
            # Add a header for context in the log file
            f.write(combined_output)

    except FileNotFoundError:
        error_msg = f"# ERROR: Command not found: {cmd[0]}\n"
        print(f"      ERROR: Command not found: {cmd[0]}")
        with results_path.open("a", encoding="utf-8", errors="replace") as f:
            f.write(error_msg)


def main():
    # --- Argument Parsing ---
    parser = argparse.ArgumentParser(
        description="Run Sudoku benchmarks for different language implementations generated from Dafny.")
    parser.add_argument("--clean-translate", action="store_true",
                        help="Perform cleanup and a fresh Dafny translation before running benchmarks.")
    parser.add_argument("--puzzle-amounts", type=str, default="1000",
                        help="A space-separated string of puzzle counts to run (e.g., '1000 5000 10000').")
    parser.add_argument("--languages", type=str.lower, default='csharp go python java',
                        help="A space-separated list of languages to benchmark (e.g., 'csharp python'). "
                             "If not provided, all available languages are run.")
    parser.add_argument("--runs", type=int, default=1,
                        help="The number of runs.")
    args = parser.parse_args()

    # Change working dir to script directory (like cd /d "%~dp0")
    script_dir = Path(__file__).resolve().parent
    os.chdir(script_dir)
    print("Working directory:", script_dir)

    # --- Absolute Paths ---
    abs_script_dir = script_dir
    abs_csharp_path = abs_script_dir / CSHARP_PROJECT_FOLDER
    abs_go_path = abs_script_dir / GO_PROJECT_FOLDER
    abs_python_path = abs_script_dir / PYTHON_PROJECT_FOLDER
    abs_java_path = abs_script_dir / JAVA_PROJECT_FOLDER

    abs_puzzle_file = abs_script_dir / PUZZLE_FILENAME
    abs_results_file = abs_script_dir / RESULTS_FILENAME
    abs_dafny_source = abs_script_dir / DAFNY_SOURCE_FILE

    # --- Local Temp Folder (created early for potential backup) ---
    local_temp_dir = abs_script_dir / "TEMP"
    # Clean up temp dir from previous failed runs before starting
    if local_temp_dir.exists():
        shutil.rmtree(local_temp_dir)
    local_temp_dir.mkdir(parents=True, exist_ok=True)
    temp_puzzle_file = local_temp_dir / "sudoku_temp_puzzles.csv"

    # --- Pre-run Checks ---
    if not abs_puzzle_file.exists():
        print(f"ERROR: Puzzle file not found at '{abs_puzzle_file}'.")
        input("Press ENTER to exit...")
        return

    # Check and clean sudoku.csv if it contains multiple columns
    print(f"\n--- Checking puzzle file format ({PUZZLE_FILENAME}) ---")
    is_cleaned = True
    try:
        with abs_puzzle_file.open("r", encoding="utf-8") as f:
            first_line = f.readline()
            if "," in first_line:
                is_cleaned = False

        if not is_cleaned:
            print(" Puzzle file appears to have multiple columns. Cleaning to keep only the first column...")
            # Read and process rows
            with abs_puzzle_file.open(newline="", encoding="utf-8") as infile:
                reader = csv.reader(infile)
                next(reader)  # skip header
                rows = [[row[0]] for row in reader]  # keep only first column

            # Overwrite the same file
            with abs_puzzle_file.open("w", newline="", encoding="utf-8") as outfile:
                writer = csv.writer(outfile)
                writer.writerows(rows)
            print(" Puzzle file has been cleaned.")
        else:
            print(" Puzzle file is already in the correct format (single column).")

    except (IOError, csv.Error) as e:
        print(f"ERROR: Could not read or process puzzle file: {e}")
        input("Press ENTER to exit...")
        return

    # Conditionally check for Dafny source only if we are translating
    if args.clean_translate and not abs_dafny_source.exists():
        print(f"ERROR: Dafny source file '{DAFNY_SOURCE_FILE}' not found at '{abs_dafny_source}'.")
        input("Press ENTER to exit...")
        return

    languages = [x for x in args.languages.split()]
    # --- 0) Cleanup and Dafny Translation ---
    if args.clean_translate:
        print("\n--- Cleaning old project folders and translating Dafny code ---")

        preserve_map = {}
        if not languages or 'csharp' in languages:
            preserve_map[abs_csharp_path] = ["SudokuByHand.cs", "Sudoku.csproj"]
        if not languages or 'go' in languages:
            preserve_map[abs_go_path] = ["src/SudokuByHand.go"]
        if not languages or 'java' in languages:
            preserve_map[abs_java_path] = ["SudokuByHand.java"]
        if not languages or 'python' in languages:
            preserve_map[abs_python_path] = ["SudokuByHand.py"]

        # Step 1: Move preserved files to TEMP and delete old directories
        print(" Backing up essential files...")
        backup_dir = local_temp_dir / "backup"
        backup_dir.mkdir()

        for folder, items_to_keep in preserve_map.items():
            if folder.is_dir():
                for item_rel_path_str in items_to_keep:
                    source_path = folder / item_rel_path_str
                    dest_path = backup_dir / item_rel_path_str
                    if source_path.exists():
                        print(f"  - Moving {source_path.relative_to(script_dir)} to backup")
                        dest_path.parent.mkdir(parents=True, exist_ok=True)
                        shutil.move(str(source_path), str(dest_path))

                print(f"  - Removing old directory: {folder.relative_to(script_dir)}")
                shutil.rmtree(folder)

        # Step 2: Run Dafny Translate (This will recreate the project folders)
        print("\n Translating Dafny source...")
        # Keys are lowercase to match argparse choices
        dafny_commands = {
            "csharp": ["dafny", "translate", "cs", str(abs_dafny_source), "-o", str(abs_csharp_path / "Sudoku"),
                       "--include-runtime"],
            "go": ["dafny", "translate", "go", str(abs_dafny_source), "-o", "Sudoku", "--include-runtime"],
            "python": ["dafny", "translate", "py", str(abs_dafny_source), "-o", "Sudoku", "--include-runtime"],
            "java": ["dafny", "translate", "java", str(abs_dafny_source), "-o", "Sudoku", "--include-runtime"]
        }

        for lang, cmd in dafny_commands.items():
            # Only run translation if no specific languages were chosen, or if this language was chosen
            if not languages or lang in languages:
                print(f" Translating Dafny to {lang.capitalize()}...")
                run_command_and_append(cmd, abs_results_file)

        # Step 3: Move preserved files back
        print("\n Restoring essential files...")
        for folder, items_to_keep in preserve_map.items():
            for item_rel_path_str in items_to_keep:
                source_path = backup_dir / item_rel_path_str
                dest_path = folder / item_rel_path_str
                if source_path.exists():
                    print(f"  - Moving file back to {dest_path.relative_to(script_dir)}")
                    dest_path.parent.mkdir(parents=True, exist_ok=True)
                    shutil.move(str(source_path), str(dest_path))

    else:
        print("\n--- Skipping cleanup and Dafny translation (use --clean-translate to enable) ---")

    # --- 1) Build step (only if project exists) ---
    print("\n--- Building all existing projects ---")
    # C# (dotnet)
    if (not languages or 'csharp' in languages) and abs_csharp_path.exists():
        print(" Building C# project...")
        run_command_and_append(["dotnet", "build", "-c", "Release", str(abs_csharp_path)], abs_results_file)

    # Go
    if (not languages or 'go' in languages) and abs_go_path.exists():
        print(" Building Go project...")
        out_exe = str(abs_go_path / "sudoku_bench_go.exe")
        run_command_and_append(["go", "build", "-o", out_exe, str(abs_go_path / "src" / "SudokuByHand.go")],
                               abs_results_file, env={"GOPATH": str(abs_go_path), "GO111MODULE": "off"})

    # Java (javac)
    if (not languages or 'java' in languages) and abs_java_path.exists():
        java_files = list(abs_java_path.rglob("*.java"))
        if java_files:
            print(" Building Java project (compiling .java files)...")
            cmd = ["javac", "-d", str(abs_java_path)] + [str(p) for p in java_files]
            run_command_and_append(cmd, abs_results_file)
        else:
            print(" Java folder exists but no .java files found; skipping javac.")

    # --- 2) Setup and main loop ---
    print("\n--- Starting Benchmarks ---")
    # Create results file and header (truncate)
    with abs_results_file.open("w", encoding="utf-8") as f:
        f.write("language,puzzle_count,time_ms\n")

    amounts = [int(x) for x in args.puzzle_amounts.split() if x.strip().isdigit()]
    run_count = args.runs
    for run in range(run_count):
        print(f"\n--- Run #{run + 1}/{run_count} ---")
        for amount in amounts:
            print(f"\n--- Testing with {amount} puzzles ---")
            # Create the temporary puzzle file with first `amount` lines
            print(" Creating temporary puzzle file...")
            # Efficient streaming copy of first N lines
            with abs_puzzle_file.open("r", encoding="utf-8", errors="replace") as src, \
                    temp_puzzle_file.open("w", encoding="utf-8", errors="replace") as dst:
                for i, line in enumerate(src):
                    if i >= amount:
                        break
                    dst.write(line)

            # --- C# Run ---
            if (not languages or 'csharp' in languages) and abs_csharp_path.exists():
                print(" Running C# benchmark...")
                cmd = ["dotnet", "run", "--configuration", "Release", "--project", str(abs_csharp_path), "--",
                       str(temp_puzzle_file)]
                run_command_and_append(cmd, abs_results_file)

            # --- Go Run ---
            go_exe = abs_go_path / "sudoku_bench_go.exe"
            if (not languages or 'go' in languages) and go_exe.exists():
                print(" Running Go benchmark...")
                run_command_and_append([str(go_exe), str(temp_puzzle_file)], abs_results_file)

            # --- Python Run ---
            python_main = abs_python_path / "SudokuByHand.py"
            if (not languages or 'python' in languages) and python_main.exists():
                print(" Running Python benchmark...")
                # Use the same Python interpreter that runs this script
                run_command_and_append([sys.executable, str(python_main), str(temp_puzzle_file)], abs_results_file)

            # --- Java Run ---
            if (not languages or 'java' in languages) and abs_java_path.exists():
                print(" Running Java benchmark...")
                # Build classpath: folder + folder/* (match original .bat which used jar wildcard)
                classpath = f"{abs_java_path}{os.pathsep}{abs_java_path}{os.sep}*"
                run_command_and_append(["java", "-cp", classpath, "SudokuByHand", str(temp_puzzle_file)], abs_results_file)

    # --- 3) Cleanup ---
    print("\n--- Benchmark Complete ---")
    if local_temp_dir.exists():
        print(" Cleaning up temporary files...")
        try:
            shutil.rmtree(local_temp_dir)
        except Exception as e:
            print(f"  Could not remove temp dir: {e}")

    print("Results have been saved to", abs_results_file)
    input("Press ENTER to exit...")


if __name__ == "__main__":
    main()