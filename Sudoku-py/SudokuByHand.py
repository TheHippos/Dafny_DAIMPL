import sys
import os
import time
import copy
from enum import Enum
from typing import Optional, List, Tuple
from concurrent.futures import ProcessPoolExecutor
from SudokuSolver import default__
import _dafny

Board = List[List[int]]

GRID_SIZE = 9
TOTAL_CELLS = GRID_SIZE * GRID_SIZE

def try_parse_board(puzzle_string: str) -> Optional[Board]:
    if not puzzle_string or len(puzzle_string) != TOTAL_CELLS:
        return None

    board = [[0] * GRID_SIZE for _ in range(GRID_SIZE)]
    for i in range(TOTAL_CELLS):
        cell_char = puzzle_string[i]
        if not cell_char.isdigit():
            return None
        
        row = i // GRID_SIZE
        col = i % GRID_SIZE
        board[row][col] = int(cell_char)
        
    return board

def load_puzzles_from_file(file_path: str) -> Tuple[List[Board], List[Board]]:
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Error: The file '{file_path}' was not found.")

    boards1 = []
    
    with open(file_path, 'r') as f, ProcessPoolExecutor() as executor:
        lines_generator = (line.strip() for line in f if line.strip())
        
        results = executor.map(try_parse_board, lines_generator, chunksize=100)
        
        boards1 = [board for board in results if board is not None]

    boards2 = copy.deepcopy(boards1)
    
    return boards1, boards2


class Option:
    def __init__(self, value, is_some: bool):
        self._value = value
        self.is_some = is_some

    @property
    def value(self):
        if not self.is_some:
            raise ValueError("Cannot access the value of a None option.")
        return self._value

    @staticmethod
    def Some(value):
        return Option(value, True)

    @staticmethod
    def None_():
        return Option(None, False)

def is_9x9(board: Board) -> bool:
    return len(board) == 9 and all(len(row) == 9 for row in board)

def is_valid_in_row_and_column(board: Board, row: int, column: int, digit: int) -> bool:
    if digit == 0:
        return True
    for i in range(9):
        if i != column and board[row][i] == digit:
            return False
        if i != row and board[i][column] == digit:
            return False
    return True

def is_valid_in_3x3(board: Board, row: int, column: int, digit: int) -> bool:
    if digit == 0:
        return True
    box_row_start = (row // 3) * 3
    box_col_start = (column // 3) * 3
    
    for r in range(box_row_start, box_row_start + 3):
        for c in range(box_col_start, box_col_start + 3):
            if r == row and c == column:
                continue
            if board[r][c] == digit:
                return False
    return True

def is_valid_digit(board: Board, row: int, column: int, digit: int) -> bool:
    return is_valid_in_row_and_column(board, row, column, digit) and is_valid_in_3x3(board, row, column, digit)

def is_valid_board(board: Board) -> bool:
    for r in range(len(board)):
        for c in range(len(board[0])):
            digit = board[r][c]
            board[r][c] = 0
            if not is_valid_digit(board, r, c, digit):
                board[r][c] = digit 
                return False
            board[r][c] = digit
    return True

def find_empty_slot(board: Board) -> Option:
    for r in range(9):
        for c in range(9):
            if board[r][c] == 0:
                return Option.Some((r, c))
    return Option.None_()

def _solving(board: Board) -> Option:
    empty = find_empty_slot(board)
    if not empty.is_some:
        return Option.Some(board)
    
    r, c = empty.value
    
    for digit in range(1, 10):
        if is_valid_digit(board, r, c, digit):
            board[r][c] = digit
            
            recursive_result = _solving(board)
            if recursive_result.is_some:
                return recursive_result
            
            board[r][c] = 0
            
    return Option.None_()

def solve(board: Board) -> Option:
    if not is_9x9(board):
        return Option.None_()
    
    if not is_valid_board(board):
        return Option.None_()

    return _solving(board)

def run(boards: List[Board]) -> List[bool]:
    results = []
    for board in boards:
        result = solve(board)
        results.append(result.is_some)
    return results



def convert_to_dafny_array(python_boards: List[Board]) -> _dafny.Array:
    num_boards = len(python_boards)
    dafny_boards = _dafny.Array(None, num_boards, GRID_SIZE, GRID_SIZE)

    for i in range(num_boards):
        dafny_boards[i] = _dafny.Array(None, GRID_SIZE, GRID_SIZE)
        for j in range(GRID_SIZE):
            for k in range(GRID_SIZE):
                dafny_boards[i, j, k] = python_boards[i][j][k]
    
    return dafny_boards

def test(boards1: List[Board], boards2: List[Board]):
    """ Times the execution of the solver. """
    sw1_start = time.perf_counter()
    run(boards1)
    sw1_stop = time.perf_counter()
    elapsed_ms1 = (sw1_stop - sw1_start) * 1000
    print(f"python_handwritten,{len(boards1)},{int(elapsed_ms1)}")

    sw2_start = time.perf_counter()
    default__.Run(convert_to_dafny_array(boards2))
    sw2_stop = time.perf_counter()
    elapsed_ms2 = (sw2_stop - sw2_start) * 1000
    print(f"python_dafny,{len(boards2)},{int(elapsed_ms2)}")


def main():
    if len(sys.argv) != 2:
        print("Usage: python your_script_name.py <puzzle_file>")
        return

    puzzle_file = sys.argv[1]
    
    boards1, boards2 = load_puzzles_from_file(puzzle_file)
    if boards1 is None or boards2 is None:
        print("Something went wrong when reading the file, results are null")
        return
    test(boards1, boards2)

if __name__ == "__main__":
    main()