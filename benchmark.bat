@echo off
setlocal

:: ============================================================================
:: Change directory to the script's location to ensure relative paths work.
:: This is crucial when running as administrator or from another location.
:: ============================================================================
cd /d "%~dp0"

:: ============================================================================
:: Benchmark Configuration
:: ============================================================================

:: --- Define the script's own directory ---
set "SCRIPT_DIR=%~dp0"

:: --- (EDIT THESE VALUES) ---
:: --- Language Project Directories ---
set "CSHARP_PROJECT_FOLDER=Sudoku-cs"
set "RUST_PROJECT_FOLDER=Sudoku-rust"
set "GO_PROJECT_FOLDER=Sudoku-go"
set "PYTHON_PROJECT_FOLDER=Sudoku-py"
set "JAVA_PROJECT_FOLDER=Sudoku-java"
set "JS_PROJECT_FOLDER=Sudoku-js"

:: --- General Settings ---
set "PUZZLE_FILENAME=sudoku.csv"
set "RESULTS_FILENAME=benchmark_results.csv"
set "PUZZLE_AMOUNTS=1000 5000 10000 25000 50000 100000 200000 500000"


:: --- (DO NOT EDIT BELOW) ---
:: --- Automatically create full, absolute paths ---
set "ABS_CSHARP_PATH=%SCRIPT_DIR%%CSHARP_PROJECT_FOLDER%"
set "ABS_RUST_PATH=%SCRIPT_DIR%%RUST_PROJECT_FOLDER%"
set "ABS_GO_PATH=%SCRIPT_DIR%%GO_PROJECT_FOLDER%"
set "ABS_PYTHON_PATH=%SCRIPT_DIR%%PYTHON_PROJECT_FOLDER%"
set "ABS_JAVA_PATH=%SCRIPT_DIR%%JAVA_PROJECT_FOLDER%"
set "ABS_JS_PATH=%SCRIPT_DIR%%JS_PROJECT_FOLDER%"

set "ABS_PUZZLE_FILE=%SCRIPT_DIR%%PUZZLE_FILENAME%"
set "ABS_RESULTS_FILE=%SCRIPT_DIR%%RESULTS_FILENAME%"

:: --- Automatically find the .sln file for the C# project ---
set "ABS_SOLUTION_PATH="
if exist "%ABS_CSHARP_PATH%" (
    for /f "delims=" %%f in ('dir /b /s "%ABS_CSHARP_PATH%\*.sln"') do (
        if not defined ABS_SOLUTION_PATH set "ABS_SOLUTION_PATH=%%f"
    )
)

:: ============================================================================
:: Pre-run Checks
:: ============================================================================
if not exist "%ABS_PUZZLE_FILE%" (
    echo ERROR: Puzzle file not found at '%ABS_PUZZLE_FILE%'.
    pause
    goto :eof
)

:: --- Setup Local Temp Folder ---
set "LOCAL_TEMP_DIR=%SCRIPT_DIR%TEMP"
if not exist "%LOCAL_TEMP_DIR%" mkdir "%LOCAL_TEMP_DIR%"
set "TEMP_PUZZLE_FILE=%LOCAL_TEMP_DIR%\sudoku_temp_puzzles.csv"

:: ============================================================================
:: --- 1. Build Step (Only builds projects that exist) ---
:: ============================================================================
echo.
echo --- Building all existing projects ---

:: --- C# Build ---
if exist "%ABS_CSHARP_PATH%" (
    if defined ABS_SOLUTION_PATH (
        echo Building C# project...
        dotnet build -c Release "%ABS_SOLUTION_PATH%"
    ) else (
        echo WARNING: C# project folder found, but no .sln file inside. Skipping build.
    )
)

:: --- Rust Build ---
if exist "%ABS_RUST_PATH%" (
    echo Building Rust project...
    cargo build --release --manifest-path "%ABS_RUST_PATH%\Cargo.toml"
)

:: --- Go Build ---
if exist "%ABS_GO_PATH%" (
    echo Building Go project...
    go build -o "%ABS_GO_PATH%\sudoku_bench_go.exe" "%ABS_GO_PATH%"
)

:: --- Java Build ---
if exist "%ABS_JAVA_PATH%" (
    echo Building Java project (compiling .java files)...
    javac -d "%ABS_JAVA_PATH%" "%ABS_JAVA_PATH%\*.java"
)

:: ============================================================================
:: --- 2. Setup and Main Loop ---
:: ============================================================================
echo.
echo --- Starting Benchmarks ---

:: Create a new results file and add the header row.
echo language,puzzle_count,time_ms > "%ABS_RESULTS_FILE%"

:: Loop through each of the puzzle amounts defined above.
for %%a in (%PUZZLE_AMOUNTS%) do (
    echo.
    echo --- Testing with %%a puzzles ---
    
    :: Create the temporary puzzle file for this specific run.
    echo Creating temporary puzzle file...
    powershell -Command "Get-Content '%ABS_PUZZLE_FILE%' | Select-Object -First %%a | Set-Content -Path '%TEMP_PUZZLE_FILE%' -Encoding UTF8"
    
    :: --- C# Run ---
    if exist "%ABS_CSHARP_PATH%" (
        echo Running C# benchmark...
        dotnet run --configuration Release --project "%ABS_CSHARP_PATH%" -- "%TEMP_PUZZLE_FILE%" >> "%ABS_RESULTS_FILE%"
    )
    
    :: --- Rust Run ---
    if exist "%ABS_RUST_PATH%\target\release\%RUST_PROJECT_FOLDER%.exe" (
        echo Running Rust benchmark...
        "%ABS_RUST_PATH%\target\release\%RUST_PROJECT_FOLDER%.exe" "%TEMP_PUZZLE_FILE%" >> "%ABS_RESULTS_FILE%"
    )
    
    :: --- Go Run ---
    if exist "%ABS_GO_PATH%\sudoku_bench_go.exe" (
        echo Running Go benchmark...
        "%ABS_GO_PATH%\sudoku_bench_go.exe" "%TEMP_PUZzLE_FILE%" >> "%ABS_RESULTS_FILE%"
    )

    :: --- Python Run ---
    if exist "%ABS_PYTHON_PATH%" (
        echo Running Python benchmark...
        python "%ABS_PYTHON_PATH%\sudoku_bench.py" "%TEMP_PUZZLE_FILE%" >> "%ABS_RESULTS_FILE%"
    )
    
    :: --- Java Run ---
    if exist "%ABS_JAVA_PATH%" (
        echo Running Java benchmark...
        java -cp "%ABS_JAVA_PATH%" SudokuBench "%TEMP_PUZZLE_FILE%" >> "%ABS_RESULTS_FILE%"
    )

    :: --- JavaScript (Node.js) Run ---
    if exist "%ABS_JS_PATH%" (
        echo Running JavaScript benchmark...
        node "%ABS_JS_PATH%\sudoku_bench.js" "%TEMP_PUZZLE_FILE%" >> "%ABS_RESULTS_FILE%"
    )
)

:: ============================================================================
:: --- 3. Cleanup ---
:: ============================================================================
echo.
echo --- Benchmark Complete ---
if exist "%LOCAL_TEMP_DIR%" (
    echo Cleaning up temporary files...
    rmdir /s /q "%LOCAL_TEMP_DIR%"
)
echo Results have been saved to %ABS_RESULTS_FILE%

pause
endlocal
goto :eof

