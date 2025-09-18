use std::env;
use std::error::Error;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::time::Instant;
use rayon::prelude::*;

// Include the Dafny-generated module.
// This requires the `Sudoko.rs` file to be in the `src` directory.
mod Sudoko;

// Import necessary types from the Dafny runtime and the generated module.
use dafny_runtime::{Array2, DafnyUsize, Object};
use Sudoko::SudokuSolver;


// Type alias for the Sudoku board for better readability.
type Board = [[u8; 9]; 9];

// Parses a single line from the puzzle file into a Board.
// Returns an Option<Board>, which will be None if the line is invalid.
fn parse_board(line: &str) -> Option<Board> {
    if line.len() != 81 {
        return None;
    }

    let mut board = [[0u8; 9]; 9];
    let mut chars = line.chars();

    for r in 0..9 {
        for c in 0..9 {
            // Get the next character, or return None if the iterator is exhausted.
            let char = chars.next()?;
            // Convert character to a digit (0-9).
            let digit = char.to_digit(10)? as u8;
            board[r][c] = digit;
        }
    }
    Some(board)
}

// Loads puzzles from a file path. It uses Rayon for parallel processing.
fn load_puzzles_from_file(file_path: &str) -> Result<Vec<Board>, Box<dyn Error>> {
    let path = Path::new(file_path);
    let file = File::open(&path)?;
    let reader = io::BufReader::new(file);

    // Use Rayon's parallel iterator to process lines concurrently.
    let boards: Vec<Board> = reader
        .lines()
        .par_bridge() // Switch to a parallel iterator
        .filter_map(|line_result| line_result.ok()) // Filter out lines with read errors
        .filter_map(|line| parse_board(&line))    // Parse each line into a board
        .collect(); // Collect the valid boards into a Vec

    Ok(boards)
}

// Finds the next empty slot (cell with '0') on the board.
fn find_empty_slot(board: &Board) -> Option<(usize, usize)> {
    for r in 0..9 {
        for c in 0..9 {
            if board[r][c] == 0 {
                return Some((r, c));
            }
        }
    }
    None
}

// Checks if the digit at a given position is valid against other digits in the same
// row, column, and 3x3 subgrid. This is used for validating the initial board state.
fn is_valid_for_initial_board(board: &Board, row: usize, col: usize, digit: u8) -> bool {
    if digit == 0 {
        return true;
    }

    // Check row and column for duplicates, excluding the position itself.
    for i in 0..9 {
        if i != col && board[row][i] == digit {
            return false;
        }
        if i != row && board[i][col] == digit {
            return false;
        }
    }

    // Check 3x3 subgrid for duplicates, excluding the position itself.
    let start_row = row - row % 3;
    let start_col = col - col % 3;
    for r in 0..3 {
        for c in 0..3 {
            let (check_r, check_c) = (start_row + r, start_col + c);
            if (check_r != row || check_c != col) && board[check_r][check_c] == digit {
                return false;
            }
        }
    }

    true
}

// Checks if the initial board configuration is valid by checking every pre-filled cell.
fn is_valid_board(board: &Board) -> bool {
    for r in 0..9 {
        for c in 0..9 {
            if !is_valid_for_initial_board(board, r, c, board[r][c]) {
                return false;
            }
        }
    }
    true
}

// Checks if placing a digit at a given position is valid.
fn is_valid_digit(board: &Board, row: usize, col: usize, digit: u8) -> bool {
    // Check row and column
    for i in 0..9 {
        if board[row][i] == digit || board[i][col] == digit {
            return false;
        }
    }

    // Check 3x3 subgrid
    let start_row = row - row % 3;
    let start_col = col - col % 3;
    for r in 0..3 {
        for c in 0..3 {
            if board[start_row + r][start_col + c] == digit {
                return false;
            }
        }
    }

    true
}

// The main recursive backtracking solver function.
fn solve_board(board: &mut Board) -> bool {
    if let Some((row, col)) = find_empty_slot(board) {
        for digit in 1..=9 {
            if is_valid_digit(board, row, col, digit) {
                board[row][col] = digit;
                if solve_board(board) {
                    return true;
                }
                // Backtrack
                board[row][col] = 0;
            }
        }
        false
    } else {
        // No empty slot found, puzzle is solved.
        true
    }
}

// Runs the solver for a vector of boards.
fn run(boards: &mut [Board]) -> Vec<bool> {
    boards.iter_mut().map(|board| {
        if is_valid_board(board) {
            solve_board(board)
        } else {
            false
        }
    }).collect()
}

// Converts the native Rust boards to the format expected by the Dafny-generated code.
fn convert_boards_to_dafny_format(boards: &[Board]) -> Object<Vec<Object<Array2<u8>>>> {
    let dafny_boards: Vec<_> = boards
        .iter()
        .map(|rust_board| {
            // FIX: Changed `new_init` to `init` to match the dafny-runtime API v1.2.0
            let arr = Array2::init(DafnyUsize(9), DafnyUsize(9), |i, j| {
                rust_board[i.0 as usize][j.0 as usize]
            });
            Object::new(arr)
        })
        .collect();
    // FIX: Return an Object wrapping a Vec. Rust's Deref coercions will allow this
    // to be passed to the `Run` function which expects a reference to a slice type.
    Object::new(dafny_boards)
}


fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: {} <puzzle_file>", args[0]);
        return;
    }

    let puzzle_file = &args[1];

    // Load puzzles
    let mut boards1 = match load_puzzles_from_file(puzzle_file) {
        Ok(b) => b,
        Err(e) => {
            eprintln!("Error loading puzzles: {}", e);
            return;
        }
    };

    // Create a second copy for the dafny solver, as in the original C# code.
    let boards2 = boards1.clone();
    let num_puzzles = boards1.len();

    // --- Run handwritten solver ---
    let start1 = Instant::now();
    run(&mut boards1);
    let duration1 = start1.elapsed();

    println!(
        "rust_handwritten,{},{}",
        num_puzzles,
        duration1.as_millis()
    );

    // --- Run Dafny-generated solver ---
    let start2 = Instant::now();
    let dafny_boards = convert_boards_to_dafny_format(&boards2);
    // This call now works due to the corrected types.
    SudokuSolver::_default::Run(&dafny_boards);
    let duration2 = start2.elapsed();

    println!(
        "rust_dafny,{},{}",
        num_puzzles,
        duration2.as_millis()
    );
}

