package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sync"
	"time"
	"unicode"
	dafnySolver "SudokuSolver"
	"dafny"
)

const (
	gridSize   = 9
	totalCells = gridSize * gridSize
)

type Board [gridSize][gridSize]byte

func loadPuzzlesFromFile(filePath string) ([]Board, []Board, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, nil, fmt.Errorf("error: the file '%s' was not found: %w", filePath, err)
	}
	defer file.Close()

	boards1Chan := make(chan Board)
	boards2Chan := make(chan Board)
	var wg sync.WaitGroup

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		wg.Add(1)
		go func(l string) {
			defer wg.Done()
			if board, ok := tryParseBoard(l); ok {
				boards1Chan <- board
				boards2Chan <- board
			}
		}(line)
	}

	go func() {
		wg.Wait()
		close(boards1Chan)
		close(boards2Chan)
	}()

	var boards1, boards2 []Board
	var collectionWg sync.WaitGroup
	collectionWg.Add(2)
	go func() {
		defer collectionWg.Done()
		for board := range boards1Chan {
			boards1 = append(boards1, board)
		}
	}()
	go func() {
		defer collectionWg.Done()
		for board := range boards2Chan {
			boards2 = append(boards2, board)
		}
	}()
	collectionWg.Wait()


	if err := scanner.Err(); err != nil {
		return nil, nil, fmt.Errorf("error reading file: %w", err)
	}

	return boards1, boards2, nil
}

func tryParseBoard(puzzleString string) (Board, bool) {
	if len(puzzleString) != totalCells {
		return Board{}, false
	}

	var board Board
	for i := 0; i < totalCells; i++ {
		cellChar := rune(puzzleString[i])
		if !unicode.IsDigit(cellChar) {
			return Board{}, false
		}
		row := i / gridSize
		col := i % gridSize
		// Conversion from char to byte digit.
		board[row][col] = byte(cellChar - '0')
	}
	return board, true
}

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: go run main.go <puzzle_file>")
		return
	}
	puzzleFile := os.Args[1]

	boards1, boards2, err := loadPuzzlesFromFile(puzzleFile)
	if err != nil {
		log.Fatalf("Failed to load puzzles: %v", err)
	}
	
	if boards1 == nil || boards2 == nil {
        fmt.Println("Something went wrong when reading the file, results are null")
        return
    }

	test(boards1, boards2)
}

func test(boards1, boards2 []Board) {
	start1 := time.Now()
	run(boards1)
	duration1 := time.Since(start1)
	fmt.Printf("go_handwritten,%d,%d\n", len(boards1), duration1.Milliseconds())

	start2 := time.Now()
	dafnySolver.Companion_Default___.Run(convertToGoDafnyArrays(boards2))
	duration2 := time.Since(start2)
	fmt.Printf("go_dafny,%d,%d\n", len(boards2), duration2.Milliseconds())
}

func convertToGoDafnyArrays(boards []Board) dafny.Array {
	dafnyBoards := dafny.NewArray(dafny.IntOf(len(boards)))

	dim := dafny.IntOf(gridSize)

	for i, goBoard := range boards {
		dafnyBoard := dafny.NewArrayFromExample(byte(0), nil, dim, dim)

		for r := 0; r < gridSize; r++ {
			for c := 0; c < gridSize; c++ {
				flatIndex := r*gridSize + c
				value := goBoard[r][c]

				dafnyBoard.ArraySet1Byte(value, flatIndex)
			}
		}
		dafnyBoards.ArraySet1(dafnyBoard, i)
	}

	return dafnyBoards
}

func run(boards []Board) []bool {
	results := make([]bool, len(boards))
	for i := range boards {
		_, ok := solve(&boards[i])
		results[i] = ok
	}
	return results
}

func solve(board *Board) (*Board, bool) {
	if !isValidBoard(board) {
		return nil, false
	}
	return solving(board)
}

func solving(board *Board) (*Board, bool) {
	r, c, ok := findEmptySlot(board)
	if !ok {
		return board, true
	}

	for digit := byte(1); digit <= 9; digit++ {
		if isValidDigit(board, r, c, digit) {
			board[r][c] = digit
			if solvedBoard, ok := solving(board); ok {
				return solvedBoard, true
			}
			board[r][c] = 0
		}
	}

	return nil, false
}

func findEmptySlot(board *Board) (row, col byte, ok bool) {
	for r := byte(0); r < gridSize; r++ {
		for c := byte(0); c < gridSize; c++ {
			if board[r][c] == 0 {
				return r, c, true
			}
		}
	}
	return 0, 0, false
}

func isValidBoard(board *Board) bool {
	for r := byte(0); r < gridSize; r++ {
		for c := byte(0); c < gridSize; c++ {
			if !isValidDigit(board, r, c, board[r][c]) {
				return false
			}
		}
	}
	return true
}

func isValidDigit(board *Board, row, col, digit byte) bool {
	return isValidInRowAndColumn(board, row, col, digit) && isValidIn3x3(board, row, col, digit)
}

func isValidInRowAndColumn(board *Board, row, col, digit byte) bool {
	if digit == 0 {
		return true
	}
	for b := byte(0); b < gridSize; b++ {
		if b != col && board[row][b] == digit {
			return false
		}
		if b != row && board[b][col] == digit {
			return false
		}
	}
	return true
}

func isValidIn3x3(board *Board, row, col, digit byte) bool {
	if digit == 0 {
		return true
	}
	boxRowStart := row / 3 * 3
	boxColStart := col / 3 * 3

	for r := boxRowStart; r < boxRowStart+3; r++ {
		for c := boxColStart; c < boxColStart+3; c++ {
			if r == row && c == col {
				continue
			}
			if board[r][c] == digit {
				return false
			}
		}
	}
	return true
}