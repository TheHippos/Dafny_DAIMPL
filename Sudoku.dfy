import opened Datatypes
import opened SudokuSolver
method {:main} Main()
{
        var board1: Board := CreateBoardFromSeq([
        [5,3,4, 6,7,8, 9,1,2],
        [6,7,2, 1,9,5, 3,4,8],
        [1,9,8, 3,4,2, 5,6,7],
        [8,5,9, 7,6,1, 4,2,3],
        [4,2,6, 8,5,3, 7,9,1],
        [7,1,3, 9,2,4, 8,5,6],
        [9,6,1, 5,3,7, 2,8,4],
        [2,8,7, 4,1,9, 6,3,5],
        [3,4,5, 2,8,6, 1,7,9]
    ]);

    var veryHardBoard: Board := CreateBoardFromSeq([
        [0,0,0, 0,0,0, 0,0,0],
        [0,0,0, 0,0,3, 0,8,5],
        [0,0,1, 0,2,0, 0,0,0],
        [0,0,0, 5,0,7, 0,0,0],
        [0,0,4, 0,0,0, 1,0,0],
        [0,9,0, 0,0,0, 0,0,0],
        [5,0,0, 0,0,0, 0,7,3],
        [0,0,2, 0,1,0, 0,0,0],
        [0,0,0, 0,4,0, 0,0,9]
    ]);

    var boards := new Board[2][veryHardBoard, board1];
    var solvable := Run(boards);
    for i:= 0 to boards.Length
        invariant forall i :: 0 <= i < boards.Length ==> is9x9(boards[i])
    {
        PrintBoard(boards[i]);
    }
}
method CreateBoardFromSeq(initialState: seq<seq<sValue>>) returns (board: Board)
    requires |initialState| == 9
    requires forall i:uint8 :: 0 <= i < |initialState| as uint8 ==> |initialState[i]| == 9
    ensures is9x9(board)
    ensures fresh(board)
{

    board := new sValue[9,9];
    for i:uint8:= 0 to 9{
        for j:uint8:= 0 to 9 {
            board[i,j] := initialState[i][j];
        }
        
    }
}
predicate isSValue(val: uint8){
    0<=val<=9
}
method PrintBoard(board: Board)
    requires is9x9(board)
{
    for r := 0 to 9 {
        if r % 3 == 0 { print "-------------------------\n"; }
        for c := 0 to 9 {
        if c % 3 == 0 { print "| "; }
        if board[r, c] == 0 { print ". "; } else { print board[r, c], " "; }
        }
        print "|\n";
    }
    print "-------------------------\n";
}

module Datatypes {
    // A newtype that maps to C#'s 8-bit sbyte (System.sbyte).
    newtype {:nativeType "byte"} uint8 = x: int | 0 <= x < 256
    newtype {:nativeType "byte"} sValue = x: int | 0 <= x <= 9 
    datatype Option<T> = None | Some(value: T)
    type Board = array2<sValue>
}

module SudokuSolver{
    import opened Datatypes
    method Run(boards: array<Board>) returns(solvable: array<bool>)
        modifies boards[..]
        requires forall i :: 0 <= i < boards.Length ==> is9x9(boards[i])
        ensures boards.Length == solvable.Length
        ensures forall i :: 0 <= i < boards.Length ==> is9x9(boards[i])
    {
        solvable := new bool[boards.Length];
        for i:=0 to boards.Length
            invariant forall j :: 0 <= j < boards.Length ==> is9x9(boards[j])
            invariant forall j :: i <= j < boards.Length ==> boards[j] == old(boards[j])
        {
            var result:= Solve(boards[i]);
            solvable[i] := result.Some?;
        }
    }

    method Solve(board: Board) returns(result: Option<Board>)
        modifies board
        requires is9x9(board)
    {
        if (!is9x9(board))
        {
            return None;
        }
        if (!isValidBoard(board))
        {
            return None;
        }
        result:= Solving(board);
    }

    method Solving(board: Board) returns(result: Option<Board>)
        modifies board
        requires is9x9(board)
        requires isValidBoard(board)
        ensures match result
            case Some(resultBoard) => is9x9(resultBoard) && isValidBoard(resultBoard) && isFullBoard(resultBoard)
            case None => forall r: uint8 ,c:uint8 :: 0 <= r < 9 && 0 <= c < 9 ==> board[r,c] == old(board[r,c]) && EmptySlotCount(board) == old(EmptySlotCount(board))
        decreases EmptySlotCount(board)
    {
        var empty := FindEmptySlot(board);
        if (empty.None?)
        {
            return Some(board);
        }
        var r := empty.value.0;
        var c := empty.value.1;
        for digit:uint8:= 1 to 10
            invariant board[r,c] == 0
            invariant forall r':uint8, c':uint8 :: 0 <= r' < 9 && 0 <= c' < 9 ==> board[r',c'] == old(board[r',c'])
            invariant EmptySlotCount(board) == old(EmptySlotCount(board))
        {
            if (isValidDigit(board, r, c, digit as sValue)){
                changeToSValue(board, r,c, digit as sValue);
                var recursiveResult := Solving(board);
                if(recursiveResult.Some?)
                {
                    return recursiveResult;
                }
                changeToZero(board, r,c);
            }
        }
        
        return None;
    }

    method copy(board:Board) returns (boardCopy:Board)
        requires is9x9(board)
        ensures is9x9(boardCopy)
        ensures forall r:uint8, c:uint8 :: 0 <= r < 9 && 0 <= c < 9 ==> board[r,c] == boardCopy[r,c] && BoardsEqualUpTo(board, boardCopy, r, c) && BoardsEqualFrom(board, boardCopy, r, c)
        ensures EmptySlotCount(board) == EmptySlotCount(boardCopy)
        ensures board != boardCopy
    {
        boardCopy := new sValue[9,9];
        for r:= 0 to 9
            invariant forall i:uint8, j:uint8 :: 0 <= i < r && 0 <= j < 9 ==> boardCopy[i,j] == board[i,j]
            invariant r > 0 ==> EmptySlotCountRecursiveDownwards(board, r - 1, 8) == EmptySlotCountRecursiveDownwards(boardCopy, r-1, 8)
        {
            for c:= 0 to 9
                invariant forall j:uint8 :: 0 <= j < c ==> boardCopy[r,j] == board[r,j]
                invariant forall i:uint8, j:uint8 :: 0 <= i < r && 0 <= j < 9 ==> boardCopy[i,j] == board[i,j]
            {
                boardCopy[r,c] := board[r,c];
            }
            assert BoardsEqualUpTo(board, boardCopy, r, 8);
            lemma_EmptySlotCountRecursiveSameUpTo(board, boardCopy, r, 8);
        }
    }

    predicate BoardsEqualUpTo(b1: Board, b2: Board, r: uint8, c: uint8)
        reads b1, b2
        requires is9x9(b1) && is9x9(b2)
        requires 0 <= r < 9 && 0 <= c < 9
    {
        forall i: uint8, j: uint8 :: (i < r || (i == r && j <= c)) && 0 <= i < 9 && 0 <= j < 9 ==> b1[i,j] == b2[i,j]
    }

    predicate BoardsEqualFrom(b1: Board, b2: Board, r: uint8, c: uint8)
        reads b1, b2
        requires is9x9(b1) && is9x9(b2)
        requires 0 <= r < 9 && 0 <= c < 9
    {
        forall i: uint8, j: uint8 :: (i > r || (i == r && j >= c)) && 0 <= i < 9 && 0 <= j < 9 ==> b1[i,j] == b2[i,j]
    }

    lemma lemma_EmptySlotCountRecursiveSameUpTo(b1: Board, b2: Board, r: uint8, c: uint8)
        requires is9x9(b1) && is9x9(b2)
        requires 0 <= r < 9 && 0 <= c < 9
        requires BoardsEqualUpTo(b1, b2, r, c)
        ensures EmptySlotCountRecursiveDownwards(b1, r, c) == EmptySlotCountRecursiveDownwards(b2, r, c)
        decreases 9 * r + c
    {
        if r == 0 && c == 0 {
        } else {
            var prev_r := prevRow(r,c);
            var prev_c := prevColumn(r,c);
            assert BoardsEqualUpTo(b1, b2, prev_r, prev_c);
            lemma_EmptySlotCountRecursiveSameUpTo(b1, b2, prev_r, prev_c);
        }
    }

    lemma lemma_EmptySlotCountRecursiveSameFrom(b1: Board, b2: Board, r: uint8, c: uint8)
        requires is9x9(b1) && is9x9(b2)
        requires 0 <= r < 9 && 0 <= c < 9
        requires BoardsEqualFrom(b1, b2, r, c)
        ensures EmptySlotCountRecursiveUpwards(b1, r, c) == EmptySlotCountRecursiveUpwards(b2, r, c)
        decreases 81 - (9 * r + c)
    {
        if r == 8 && c == 8 {
        } else {
            var next_r := nextRow(r,c);
            var next_c := nextColumn(r,c);
            assert BoardsEqualFrom(b1, b2, next_r, next_c);
            lemma_EmptySlotCountRecursiveSameFrom(b1, b2, next_r, next_c);
        }
    }
    method changeToZero(board: Board, row: uint8, column: uint8)
        modifies board
        requires is9x9(board)
        requires 0 <= row < 9
        requires 0 <= column < 9
        requires board[row, column] != 0
        ensures is9x9(board)
        ensures board[row, column] == 0
        ensures forall r:uint8, c:uint8 :: 0 <= r < 9 && 0 <= c < 9 ==> (r == row && c == column) || old(board[r,c]) == board[r,c]
        ensures EmptySlotCount(board) == old(EmptySlotCount(board)) + 1
    {
        ghost var board' := copy(board);
        board[row, column] := 0;
        lemma_updatingBoardIncreasesEmptyCount(board, board', row, column);
    }


    method changeToSValue(board: Board, row: uint8, column: uint8, digit: sValue)
        modifies board
        requires is9x9(board)
        requires 0 <= row < 9
        requires 0 <= column < 9
        requires board[row, column] == 0
        requires EmptySlotCount(board) > 0
        requires digit != 0
        ensures is9x9(board)
        ensures board[row, column] == digit
        ensures forall r:uint8, c:uint8 :: 0 <= r < 9 && 0 <= c < 9 ==> (r == row && c == column) || old(board[r,c]) == board[r,c]
        ensures EmptySlotCount(board) == old(EmptySlotCount(board)) - 1
    {
        ghost var board' := copy(board);
        board[row, column] := digit;
        lemma_updatingBoardReducesEmptyCount(board, board', row, column, digit);
    }

    lemma lemma_emptyCountIsSplitByCell(board: Board, r: uint8, c: uint8)
        requires is9x9(board)
        requires 0 <= r < 9 && 0 <= c < 9
        ensures EmptySlotCount(board) ==
            (if r == 0 && c == 0 then 0 else EmptySlotCountRecursiveDownwards(board, prevRow(r, c), prevColumn(r, c))) +
            (if board[r, c] == 0 then 1 else 0) +
            (if r == 8 && c == 8 then 0 else EmptySlotCountRecursiveUpwards(board, nextRow(r, c), nextColumn(r, c)))
    {
        lemma_count_split(board, r, c);
    }

    lemma lemma_updatingBoardIncreasesEmptyCount(board: Board, oldBoard: Board, r: uint8, c: uint8)
        requires is9x9(board)
        requires is9x9(oldBoard)
        requires 0 <= r < 9
        requires 0 <= c < 9
        requires oldBoard[r, c] != 0
        requires board[r, c] == 0
        requires EmptySlotCount(board) > 0
        requires forall i:uint8, j:uint8 :: 0 <= i < 9 && 0 <= j < 9 ==> 
        (i==r && j == c && oldBoard[i,j] != 0 && board[i, j] == 0) ||
        board[i, j] == oldBoard[i,j]
        ensures EmptySlotCount(board) == EmptySlotCount(oldBoard) + 1
    {
        lemma_emptyCountIsSplitByCell(oldBoard, r, c);
        var count_before_old := if (r == 0 && c == 0) then 0 else EmptySlotCountRecursiveDownwards(oldBoard, prevRow(r,c), prevColumn(r,c));
        var count_after_old := if (r == 8 && c == 8) then 0 else EmptySlotCountRecursiveUpwards(oldBoard, nextRow(r,c), nextColumn(r,c));

        lemma_emptyCountIsSplitByCell(board, r, c);
        var count_before_new := if (r == 0 && c == 0) then 0 else EmptySlotCountRecursiveDownwards(board, prevRow(r,c), prevColumn(r,c));
        var count_after_new := if (r == 8 && c == 8) then 0 else EmptySlotCountRecursiveUpwards(board, nextRow(r,c), nextColumn(r,c));

        if (r > 0 || c > 0) {
            var prev_r := prevRow(r, c); var prev_c := prevColumn(r, c);
            lemma_EmptySlotCountRecursiveSameUpTo(board, oldBoard, prev_r, prev_c);
        }

        if (r < 8 || c < 8) {
            var next_r := nextRow(r, c); var next_c := nextColumn(r, c);
            lemma_EmptySlotCountRecursiveSameFrom(board, oldBoard, next_r, next_c);
        }
    }

    lemma lemma_updatingBoardReducesEmptyCount(board: Board, oldBoard: Board, r: uint8, c: uint8, digit: sValue)
        requires is9x9(board)
        requires is9x9(oldBoard)
        requires 0 <= r < 9
        requires 0 <= c < 9
        requires oldBoard[r, c] == 0
        requires board[r, c] == digit
        requires EmptySlotCount(oldBoard) > 0
        requires digit != 0
        requires forall i:uint8, j:uint8 :: 0 <= i < 9 && 0 <= j < 9 ==> 
        (i==r && j == c && oldBoard[i,j] == 0 && board[i, j] == digit) ||
        board[i, j] == oldBoard[i,j]
        ensures EmptySlotCount(board) == EmptySlotCount(oldBoard) - 1
    {
        lemma_emptyCountIsSplitByCell(oldBoard, r, c);
        var count_before_old := if (r == 0 && c == 0) then 0 else EmptySlotCountRecursiveDownwards(oldBoard, prevRow(r,c), prevColumn(r,c));
        var count_after_old := if (r == 8 && c == 8) then 0 else EmptySlotCountRecursiveUpwards(oldBoard, nextRow(r,c), nextColumn(r,c));

        lemma_emptyCountIsSplitByCell(board, r, c);
        var count_before_new := if (r == 0 && c == 0) then 0 else EmptySlotCountRecursiveDownwards(board, prevRow(r,c), prevColumn(r,c));
        var count_after_new := if (r == 8 && c == 8) then 0 else EmptySlotCountRecursiveUpwards(board, nextRow(r,c), nextColumn(r,c));

        if (r > 0 || c > 0) {
            var prev_r := prevRow(r, c); var prev_c := prevColumn(r, c);
            lemma_EmptySlotCountRecursiveSameUpTo(board, oldBoard, prev_r, prev_c);
        }

        if (r < 8 || c < 8) {
            var next_r := nextRow(r, c); var next_c := nextColumn(r, c);
            lemma_EmptySlotCountRecursiveSameFrom(board, oldBoard, next_r, next_c);
        }
    }

    function nextRow(row: uint8, column: uint8) : (next_row: uint8)
        requires 0 <= row < 9
        requires 0 <= column < 9
        requires row < 8 || column < 8
        ensures 0 <= next_row < 9
    {
        if column == 8 then row + 1 else row
    }
    function nextColumn(row: uint8, column: uint8) : (next_column: uint8)
        requires 0 <= row < 9
        requires 0 <= column < 9
        requires row < 8 || column < 8
        ensures 0 <= next_column < 9
    {
        if column == 8 then 0 else column + 1
    }
    function prevRow(row: uint8, column: uint8) : (prev_row: uint8)
        requires 0 <= row < 9
        requires 0 <= column < 9
        requires row > 0 || column > 0
        ensures 0 <= prev_row < 9
    {
        if column == 0 then row - 1 else row
    }
    function prevColumn(row: uint8, column: uint8) : (prev_column: uint8)
        requires 0 <= row < 9
        requires 0 <= column < 9
        requires row > 0 || column > 0
        ensures 0 <= prev_column < 9
    {
        if column == 0 then 8 else column - 1
    }
    method FindEmptySlot(board: Board) returns(slot:Option<(uint8,uint8)>)
        requires is9x9(board)
        ensures match slot
                case Some(coords) => 0 <= coords.0 < 9 && 0 <= coords.1 < 9 && board[coords.0 ,coords.1] == 0 && EmptySlotCount(board) > 0
                case None => forall r:uint8, c: uint8 :: 0 <= r < 9 && 0 <= c < 9 ==> board[r,c] != 0 && EmptySlotCount(board) == 0
    {
        for i:uint8:=0 to 9
            invariant forall r: uint8, c: uint8 :: 0 <= r < i && 0 <= c < 9 ==> board[r,c] != 0 
            invariant i > 0 ==> EmptySlotCountRecursiveDownwards(board, i - 1, 8) == 0
        {
            for j:uint8:=0 to 9
                invariant forall c: uint8 :: 0 <= c < j ==> board[i,c] != 0
                invariant i > 0 && j > 0 ==> EmptySlotCountRecursiveDownwards(board, i - 1, j - 1) == 0
            {
                if(board[i,j] == 0){
                    return Some((i,j));
                }
            }
        }
        return None;
    }
    function EmptySlotCountRecursiveUpwards(board: Board, r: uint8, c: uint8) : (count: uint8)
        reads board
        requires is9x9(board)
        requires 0 <= r < 9
        requires 0 <= c < 9
        ensures 0 <= count <= (9 * 9) - (9 * r + c)
        ensures count == 0 <==> (forall i: uint8, j:uint8 :: (i > r || (i == r && j >= c)) && 0 <= i < 9 && 0 <= j < 9 ==> board[i, j] != 0)
        ensures count > 0 <==> (exists i: uint8, j:uint8 :: (i > r || (i == r && j >= c)) && 0 <= i < 9 && 0 <= j < 9 && board[i, j] == 0)
        decreases (board.Length0 * board.Length1) as uint8 - (board.Length1 as uint8 * r + c)
    {
        var current_cell_val := if board[r, c] == 0 then 1 else 0;

        if r == 8 && c == 8 then
            current_cell_val
        else
            var nextRow := nextRow(r,c);
            var nextColumn := nextColumn(r,c);
            var recursiveResult := EmptySlotCountRecursiveUpwards(board, nextRow, nextColumn);
            current_cell_val + recursiveResult
    } 

    function EmptySlotCountRecursiveDownwards(board: Board, r: uint8, c: uint8) : (count: uint8)
        reads board
        requires is9x9(board)
        requires 0 <= r < 9
        requires 0 <= c < 9
        ensures 0 <= count <= (9 * r + c) + 1 <= 81
        ensures count == 0 <==> (forall i: uint8, j: uint8 :: (i < r || (i == r && j <= c)) && 0 <= i < 9 && 0 <= j < 9 ==> board[i, j] != 0)
        ensures count > 0 <==> (exists i: uint8, j: uint8 :: (i < r || (i == r && j <= c)) && 0 <= i < 9 && 0 <= j < 9 && board[i, j] == 0)
        decreases 9 * r + c
    {
        var current_cell_val: uint8 := if board[r, c] == 0 then 1 else 0;

        if r == 0 && c == 0 then
            current_cell_val
        else
            var prev_r := prevRow(r,c);
            var prev_c := prevColumn(r,c);

            var recursiveResult := EmptySlotCountRecursiveDownwards(board, prev_r, prev_c);
            
            current_cell_val + recursiveResult
    }

    function EmptySlotCount(board:Board) : (count:uint8)
        reads board
        requires is9x9(board)
        ensures 0 <= count <= (board.Length0 * board.Length1) as uint8
        ensures count == 0 <==> (forall r: uint8, c:uint8 :: 0 <= r < 9 && 0 <= c < 9 ==> board[r,c] != 0)
        ensures count > 0 <==> (exists r: uint8, c:uint8 :: 0 <= r < 9 && 0 <= c < 9 && board[r,c] == 0)
        ensures count == EmptySlotCountRecursiveDownwards(board, 8, 8)
        ensures count == EmptySlotCountRecursiveUpwards(board, 0, 0)
    {
        lemma_upwardsAndDownwardsCountingSame(board);
        EmptySlotCountRecursiveDownwards(board, 8, 8)
    }
    lemma lemma_upwardsAndDownwardsCountingSame(board: Board)
        requires is9x9(board)
        ensures EmptySlotCountRecursiveDownwards(board, 8, 8) == EmptySlotCountRecursiveUpwards(board, 0, 0)
    {
        lemma_count_split(board, 8, 8);
    }
    lemma lemma_count_split(board: Board, r: uint8, c: uint8)
        requires is9x9(board)
        requires 0 <= r < 9 && 0 <= c < 9
        ensures EmptySlotCountRecursiveUpwards(board, 0, 0) == 
                EmptySlotCountRecursiveDownwards(board, r, c) + 
                (if r == 8 && c == 8 then 0 
                    else EmptySlotCountRecursiveUpwards(board, nextRow(r,c), nextColumn(r,c)))
        decreases 9 * r + c
    {
        if r == 0 && c == 0 {
        } else {
            var prev_r := prevRow(r,c);
            var prev_c := prevColumn(r,c);
            lemma_count_split(board, prev_r, prev_c);
        }
    }


    predicate is9x9(board: Board)
    {
        board.Length0 == 9 && board.Length1 == 9
    }
    predicate isValidDigit(board: Board, row: uint8, column: uint8, digit: sValue)
        reads board
        requires is9x9(board)
        requires 0 <= row < 9
        requires 0 <= column < 9
    {
        validInRow(board, row, column, digit) && validInColumn(board, row, column, digit) && validIn3x3(board, row, column, digit)
    }
    predicate validInRow(board: Board, row: uint8, column: uint8, digit:sValue)
        reads board
        requires is9x9(board)
        requires 0 <= row < 9
    {
        digit == 0 || forall c:uint8 :: 0 <= c < 9 ==> c == column || board[row, c] != digit
    }
        
    predicate validInColumn(board: Board, row:uint8, column: uint8, digit:sValue)
        reads board
        requires is9x9(board)
        requires 0 <= column < 9
    {
        digit == 0 || forall r:uint8 :: 0 <= r < 9 ==> r == row || board[r, column] != digit
    }
        
    predicate validIn3x3(board: Board, row: uint8, column: uint8, digit:sValue)
        reads board
        requires is9x9(board)
        requires 0 <= row < 9
        requires 0 <= column < 9
    {
        var box_row := (row / 3) * 3;
        var box_col := (column / 3) * 3;
        digit == 0 || forall r: uint8, c:uint8 :: box_row <= r < box_row + 3 && box_col <= c < box_col + 3 ==> (r == row && c == column) || board[r,c] != digit
    }

    predicate isValidBoard(board:Board)
        reads board
        requires is9x9(board)
    {
        forall r:uint8, c:uint8 :: 0 <= r < 9 && 0 <= c < 9 ==> isValidDigit(board, r, c, board[r, c])
    }
    predicate isFullBoard(board:Board)
        reads board
        requires is9x9(board)
    {
        forall r:uint8, c:uint8 :: 0 <= r < 9 && 0 <= c < 9 ==> 1 <= board[r, c] <= 9
    }
}