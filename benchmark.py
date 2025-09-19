#!/usr/bin/env python3

from pathlib import Path
import subprocess
import sys
import os
import shutil

CSHARP_PROJECT_FOLDER = "Sudoku-cs"
GO_PROJECT_FOLDER = "Sudoku-go"
PYTHON_PROJECT_FOLDER = "Sudoku-py"
JAVA_PROJECT_FOLDER = "Sudoku-java"

#CSHARP_PROJECT_FOLDER = "adfasdf"
#GO_PROJECT_FOLDER = "asdfasdfasfd"
#PYTHON_PROJECT_FOLDER = "asdfasdfasdf"
#JAVA_PROJECT_FOLDER = "asdfasdfa"

# General settings
PUZZLE_FILENAME = "sudoku.csv"
RESULTS_FILENAME = "benchmark_results.csv"
#PUZZLE_AMOUNTS = "1000 5000 10000 25000 50000 100000 200000 500000 1000000"
PUZZLE_AMOUNTS = "1000"

# ============================
# Do not edit below unless you know what you're doing
# ============================

def run_command_and_append(cmd, results_path, cwd=None, env={}):
    """
    Runs command (list) and appends stdout+stderr to results_path.
    Similar to using `>> resultsfile` in batch files.
    """
    print("    running:", " ".join(map(str, cmd)))
    # Ensure parent exists for results_path
    results_path = Path(results_path)
    results_path.parent.mkdir(parents=True, exist_ok=True)
    with results_path.open("a", encoding="utf-8", errors="replace") as f:
        try:
            # Redirect both stdout and stderr into the file (so we capture all output).
            # This mirrors batch's redirection behavior in a robust way.
            subprocess.run(cmd, stdout=f, stderr=subprocess.STDOUT, cwd=cwd, text=True, check=False, env={**os.environ.copy(),**env})
        except FileNotFoundError:
            msg = f"# ERROR: command not found: {cmd[0]}\n"
            print("      Command not found:", cmd[0])
            f.write(msg)


def main():
    # Change working dir to script directory (like cd /d "%~dp0")
    script_dir = Path(__file__).resolve().parent
    os.chdir(script_dir)
    print("Working directory:", script_dir)

    # Absolute paths
    abs_script_dir = script_dir
    abs_csharp_path = abs_script_dir / CSHARP_PROJECT_FOLDER
    abs_go_path = abs_script_dir / GO_PROJECT_FOLDER
    abs_python_path = abs_script_dir / PYTHON_PROJECT_FOLDER
    abs_java_path = abs_script_dir / JAVA_PROJECT_FOLDER

    abs_puzzle_file = abs_script_dir / PUZZLE_FILENAME
    abs_results_file = abs_script_dir / RESULTS_FILENAME

    # Pre-run checks
    if not abs_puzzle_file.exists():
        print(f"ERROR: Puzzle file not found at '{abs_puzzle_file}'.")
        input("Press ENTER to exit...")
        return

    # Local temp folder
    local_temp_dir = abs_script_dir / "TEMP"
    local_temp_dir.mkdir(parents=True, exist_ok=True)
    temp_puzzle_file = local_temp_dir / "sudoku_temp_puzzles.csv"

    # 1) Build step (only if project exists)
    print("\n--- Building all existing projects ---")
    # C# (dotnet)
    if abs_csharp_path.exists():
        print(" Building C# project...")
        run_command_and_append(["dotnet", "build", "-c", "Release", str(abs_csharp_path)], abs_results_file)

    # Go
    if abs_go_path.exists():
        print(" Building Go project...")
        out_exe = str(abs_go_path / "sudoku_bench_go.exe")
        run_command_and_append(["go", "build", "-o", out_exe, str(abs_go_path / "src" / "SudokuByHand.go")], abs_results_file, env={"GOPATH": abs_go_path, "GO111MODULE": "off"})

    # Java (javac)
    if abs_java_path.exists():
        java_files = list(abs_java_path.rglob("*.java"))
        if java_files:
            print(" Building Java project (compiling .java files)...")
            cmd = ["javac", "-d", str(abs_java_path)] + [str(p) for p in java_files]
            run_command_and_append(cmd, abs_results_file)
        else:
            print(" Java folder exists but no .java files found; skipping javac.")


        # 2) Setup and main loop
    print("\n--- Starting Benchmarks ---")
    # Create results file and header (truncate)
    with abs_results_file.open("w", encoding="utf-8") as f:
        f.write("language,puzzle_count,time_ms\n")

    amounts = [int(x) for x in PUZZLE_AMOUNTS.split() if x.strip().isdigit()]

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
        if abs_csharp_path.exists():
            print(" Running C# benchmark...")
            cmd = ["dotnet", "run", "--configuration", "Release", "--project", str(abs_csharp_path), "--", str(temp_puzzle_file)]
            run_command_and_append(cmd, abs_results_file)

        # --- Go Run ---
        go_exe = abs_go_path / "sudoku_bench_go.exe"
        if go_exe.exists():
            print(" Running Go benchmark...")
            run_command_and_append([str(go_exe), str(temp_puzzle_file)], abs_results_file)

        # --- Python Run ---
        python_main = abs_python_path / "SudokuByHand.py"
        if python_main.exists():
            print(" Running Python benchmark...")
            # Use the same Python interpreter that runs this script
            run_command_and_append([sys.executable, str(python_main), str(temp_puzzle_file)], abs_results_file)

        # --- Java Run ---
        if abs_java_path.exists():
            print(" Running Java benchmark...")
            # Build classpath: folder + folder/* (match original .bat which used jar wildcard)
            classpath = f"{abs_java_path}{os.pathsep}{abs_java_path}{os.sep}*"
            run_command_and_append(["java", "-cp", classpath, "SudokuByHand", str(temp_puzzle_file)], abs_results_file)

    # 3) Cleanup
    print("\n--- Benchmark Complete ---")
    if local_temp_dir.exists():
        print(" Cleaning up temporary files...")
        try:
            shutil.rmtree(local_temp_dir)
        except Exception as e:
            print("  Could not remove temp dir:", e)

    print("Results have been saved to", abs_results_file)
    input("Press ENTER to exit...")


if __name__ == "__main__":
    main()
