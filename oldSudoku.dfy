module DafnyInt32 {
  // A newtype that maps to C#'s 32-bit integer (System.Int32).
  newtype {:nativeType "sbyte"} int32 = x: int | -128 <= x < 128
 
  // Define the required constants. Their values now match a 32-bit integer.
  // The 'as int32' cast is not needed here because the literal values
  // satisfy the newtype's constraint.
  const MinValue: int32 := -128 
  const MaxValue: int32 := 127
}
// module DafnyInt32 {
//   type int32 = int
// }
method Main()
{
  var board1: seq<seq<DafnyInt32.int32>> := [
    [5,3,4, 6,7,8, 9,1,2],
    [6,7,2, 1,9,5, 3,4,8],
    [1,9,8, 3,4,2, 5,6,7],
    [8,5,9, 7,6,1, 4,2,3],
    [4,2,6, 8,5,3, 7,9,1],
    [7,1,3, 9,2,4, 8,5,6],
    [9,6,1, 5,3,7, 2,8,4],
    [2,8,7, 4,1,9, 6,3,5],
    [3,4,5, 2,8,6, 1,7,9]
  ];
  var veryHardBoard: seq<seq<DafnyInt32.int32>> := [
    [0,0,0, 0,0,0, 0,0,0],
    [0,0,0, 0,0,3, 0,8,5],
    [0,0,1, 0,2,0, 0,0,0],
    [0,0,0, 5,0,7, 0,0,0],
    [0,0,4, 0,0,0, 1,0,0],
    [0,9,0, 0,0,0, 0,0,0],
    [5,0,0, 0,0,0, 0,7,3],
    [0,0,2, 0,1,0, 0,0,0],
    [0,0,0, 0,4,0, 0,0,9]
  ];
  
  print "veryHardBoard:\n";
  PrintBoard(veryHardBoard);
  print "solved_veryHardBoard:\n";
  var solved_veryHardBoard := sudokuSolver(veryHardBoard);
  {match solved_veryHardBoard
    case Some(solution) => PrintBoard(solution);
    case None => print "unsolvable";}
}

method PrintBoard(board: seq<seq<DafnyInt32.int32>>)
  requires is9x9(board)
{
  for r := 0 to 9 {
    if r % 3 == 0 { print "-------------------------\n"; }
    for c := 0 to 9 {
      if c % 3 == 0 { print "| "; }
      if board[r][c] == 0 { print ". "; } else { print board[r][c], " "; }
    }
    print "|\n";
  }
  print "-------------------------\n";
}


datatype Option<T> = None | Some(value: T)

method sudokuSolver(board: seq<seq<DafnyInt32.int32>>) returns (result: Option<seq<seq<DafnyInt32.int32>>>)
  requires is9x9(board)
  ensures result.Some? ==> isCompleteAndValid(result.value) && isSolutionOf(result.value, board)
  decreases numberOfEmptySpaces(board)
{
  var is_valid := sudokuTester(board);
  if !is_valid 
  {
    return None;
  }
  var empty := findEmpty(board);
  if empty.None?
  {
    assert isCompleteAndValid(board);
    return Some(board);
  } else {
    var row := empty.value.0;
    var column := empty.value.1;
    for n := 1 to 10 // n is int, from 1 to 9
    {
      var n32 := n as DafnyInt32.int32;
      var newBoard := board[row := board[row][column := n32]];
      lemma_UpdateDecreasesEmptySpaces(board, row, column, n32); 
      if isValidSudokuBoard(newBoard)
      {
        var recursiveResult := sudokuSolver(newBoard);
        if recursiveResult.Some?
        {
          return recursiveResult;
        }
      }
    }
    return None;
  }
}

method findEmpty(board: seq<seq<DafnyInt32.int32>>) returns (result: Option<(int, int)>)
  requires is9x9(board)
  ensures match result 
    case Some(tuple) => 0 <= tuple.0 < 9 && 0 <= tuple.1 < 9 && board[tuple.0][tuple.1] == 0
    case None => numberOfEmptySpaces(board) == 0
{
  for rid := 0 to 9 
  invariant forall i, j :: 0 <= i < rid && 0 <= j < 9 ==> board[i][j] != 0
  {
    for cid := 0 to 9 
    invariant forall i :: 0 <= i < cid ==> board[rid][i] != 0
    {
      if board[rid][cid] == 0 {
        return Some((rid,cid));
      }
    }
  }
  LemmaNumberOfEmptySpacesIsCorrect(board);
  return None;
}

// --- Start of new recursive functions for numberOfEmptySpaces ---

// Helper to count zeros in a row recursively.
function rowZeroCountRecursive(row: seq<DafnyInt32.int32>, cols_to_check: int): (count: DafnyInt32.int32)
  requires |row| == 9
  requires 0 <= cols_to_check <= |row|
  ensures 0 <= count <= cols_to_check as DafnyInt32.int32
  decreases cols_to_check
{
  if cols_to_check == 0 then 0
  else
    (if row[cols_to_check - 1] == 0 then 1 else 0) + 
    rowZeroCountRecursive(row, cols_to_check - 1)
}

// Counts zeros in a single row.
function rowZeroCount(row: seq<DafnyInt32.int32>): (count: DafnyInt32.int32)
  requires |row| == 9
  ensures 0 <= count <= 9
{
  rowZeroCountRecursive(row, |row|)
}

// Helper to count empty spaces on the board recursively.
function numberOfEmptySpacesRecursive(board: seq<seq<DafnyInt32.int32>>, rows_to_check: int): (count: DafnyInt32.int32)
  requires is9x9(board)
  requires 0 <= rows_to_check <= |board|
  ensures 0 <= count <= (rows_to_check * 9) as DafnyInt32.int32
  decreases rows_to_check
{
  if rows_to_check == 0 then 0
  else
    rowZeroCount(board[rows_to_check - 1]) + 
    numberOfEmptySpacesRecursive(board, rows_to_check - 1)
}

// Main function, replacing the unverifiable set-comprehension version.
function numberOfEmptySpaces(board: seq<seq<DafnyInt32.int32>>): (count: DafnyInt32.int32)
  requires is9x9(board)
  ensures 0 <= count <= 81
{
  numberOfEmptySpacesRecursive(board, |board|)
}

// --- End of new recursive functions ---

// --- Start of Equivalence Lemmas ---
// These lemmas prove that the recursive functions are equivalent to a set-based definition.

lemma LemmaCardinalityOfLiftedSet(k: int, S: set<int>)
  ensures |S| == |set s | s in S :: (k, s)|
  decreases |S|
{
  var T := set s | s in S :: (k, s);
  if |S| > 0 {
    var s :| s in S;
    LemmaCardinalityOfLiftedSet(k, S - {s});
    var T_prime := set s' | s' in S - {s} :: (k, s');
    assert |S - {s}| == |T_prime|;

    // Explicitly prove the membership property for T_prime
    forall x | (k, x) in T_prime
        ensures x in S - {s}
    { }
    assert s !in (S - {s});
    assert (k,s) !in T_prime;
    
    assert T == T_prime + {(k,s)};
  }
}

lemma LemmaRowZeroCountRecursiveIsCorrect(row: seq<DafnyInt32.int32>, cols_to_check: int)
  requires |row| == 9
  requires 0 <= cols_to_check <= 9
  ensures rowZeroCountRecursive(row, cols_to_check) as int == |set c | 0 <= c < cols_to_check && row[c] == 0 :: c|
  decreases cols_to_check
{
  if cols_to_check > 0 {
    LemmaRowZeroCountRecursiveIsCorrect(row, cols_to_check - 1);
    var S_prev := set c | 0 <= c < cols_to_check - 1 && row[c] == 0 :: c;
    var S_curr := set c | 0 <= c < cols_to_check && row[c] == 0 :: c;
    if row[cols_to_check - 1] == 0 {
      assert S_curr == S_prev + {cols_to_check - 1};
    } else {
      assert S_curr == S_prev;
    }
  }
}

lemma LemmaRowZeroCountIsCorrect(row: seq<DafnyInt32.int32>)
  requires |row| == 9
  ensures rowZeroCount(row) as int == |set c | 0 <= c < 9 && row[c] == 0 :: c|
{
  LemmaRowZeroCountRecursiveIsCorrect(row, 9);
}

lemma LemmaSetEquivalence(row: seq<DafnyInt32.int32>, row_index: int, S_flat: set<int>, S_lifted: set<(int, int)>)
  requires |row| == 9
  requires S_flat == set c | 0 <= c < 9 && row[c] == 0 :: c
  requires S_lifted == set c | 0 <= c < 9 && row[c] == 0 :: (row_index, c)
  ensures S_lifted == set s | s in S_flat :: (row_index, s)
{
    var S_lifted_from_flat := set s | s in S_flat :: (row_index, s);
    
    // Prove S_lifted is a subset of S_lifted_from_flat
    forall t | t in S_lifted
        ensures t in S_lifted_from_flat
    {
        var c :| 0 <= c < 9 && row[c] == 0 && t == (row_index, c);
        assert c in S_flat;
    }

    // Prove S_lifted_from_flat is a subset of S_lifted
    forall t | t in S_lifted_from_flat
        ensures t in S_lifted
    {
        var s :| s in S_flat && t == (row_index, s);
        assert 0 <= s < 9 && row[s] == 0;
    }
}

function Identity<T>(n: T) : T { n }
lemma LemmaNumberOfEmptySpacesRecursiveIsCorrect(board: seq<seq<DafnyInt32.int32>>, rows_to_check: int)
    requires is9x9(board)
    requires 0 <= rows_to_check <= 9
    ensures numberOfEmptySpacesRecursive(board, rows_to_check) as int == |set r,c | 0 <= r < rows_to_check && 0 <= c < 9 && board[r][c] == 0 :: (r,c)|
    decreases rows_to_check
{
    if rows_to_check > 0 {
        LemmaNumberOfEmptySpacesRecursiveIsCorrect(board, rows_to_check - 1);
        LemmaRowZeroCountIsCorrect(board[rows_to_check - 1]);
        
         var current_row := board[rows_to_check-1];
        var S_row_flat := set c | 0 <= c < 9 && current_row[c] == 0 :: c;
        var S_row_lifted := set c | 0 <= c < 9 && current_row[c] == 0 :: (rows_to_check-1, c);
        
        LemmaSetEquivalence(board[rows_to_check - 1], rows_to_check - 1, S_row_flat, S_row_lifted);
        var S_row_lifted_from_flat := set s | s in S_row_flat :: (rows_to_check-1, s);
        assert S_row_lifted == S_row_lifted_from_flat;

        LemmaCardinalityOfLiftedSet(rows_to_check - 1, S_row_flat);
        assert |S_row_flat| == |S_row_lifted_from_flat|; // From Lemma
        assert |S_row_flat| == |S_row_lifted|; // Should now hold

        var S_board_prev := set r,c | 0 <= r < rows_to_check - 1 && 0 <= c < 9 && board[r][c] == 0 :: (r,c);
        var S_board_curr := set r,c | 0 <= r < rows_to_check && 0 <= c < 9 && board[r][c] == 0 :: (r,c);
        
        assert S_board_curr == S_board_prev + S_row_lifted;
        assert S_board_prev * S_row_lifted == {};
    }
}

lemma LemmaNumberOfEmptySpacesIsCorrect(board: seq<seq<DafnyInt32.int32>>)
  requires is9x9(board)
  ensures numberOfEmptySpaces(board) as int == |set r, c | 0 <= r < 9 && 0 <= c < 9 && board[r][c] == 0 :: (r,c)|
{
    LemmaNumberOfEmptySpacesRecursiveIsCorrect(board, 9);
}

// --- End of Equivalence Lemmas ---

lemma lemma_UpdateDecreasesEmptySpaces(board: seq<seq<DafnyInt32.int32>>, r_update: int, c_update: int, n: DafnyInt32.int32)
  requires is9x9(board)
  requires 0 <= r_update < 9 && 0 <= c_update < 9
  requires board[r_update][c_update] == 0
  requires n != 0
  ensures numberOfEmptySpaces(board[r_update := board[r_update][c_update := n]]) == numberOfEmptySpaces(board) - 1
{
  var newBoard := board[r_update := board[r_update][c_update := n]];
  LemmaNumberOfEmptySpacesIsCorrect(board);
  LemmaNumberOfEmptySpacesIsCorrect(newBoard);

  var S_old := set r, c | 0 <= r < 9 && 0 <= c < 9 && board[r][c] == 0 :: (r,c);
  var S_new := set r, c | 0 <= r < 9 && 0 <= c < 9 && newBoard[r][c] == 0 :: (r,c);

  forall r, c | 0 <= r < 9 && 0 <= c < 9
    ensures ((r, c) in S_old) <==> ((r, c) in S_new || (r, c) == (r_update, c_update))
  {
    if (r, c) == (r_update, c_update) {
      assert newBoard[r][c] != 0;
    } else {
      assert newBoard[r][c] == board[r][c];
    }
  }
  assert S_old == S_new + {(r_update, c_update)};
  assert (r_update, c_update) !in S_new;
  assert |S_old| == |S_new| + 1;
}

predicate isSolutionOf(solution: seq<seq<DafnyInt32.int32>>, problem: seq<seq<DafnyInt32.int32>>)
{
  is9x9(solution) && is9x9(problem) &&
  forall i, j :: 0 <= i < 9 && 0 <= j < 9 ==>
    problem[i][j] != 0 ==> solution[i][j] == problem[i][j]
}

predicate isComplete(board: seq<seq<DafnyInt32.int32>>)
{
  is9x9(board) && numberOfEmptySpaces(board) == 0
}

predicate isCompleteAndValid(board: seq<seq<DafnyInt32.int32>>)
{
  isComplete(board) && isValidSudokuBoard(board)
}

method sudokuTester(board: seq<seq<DafnyInt32.int32>>) returns (result: bool)
  ensures result <==> isValidSudokuBoard(board)
{
  return is9x9(board) && hasOnlyAllowedValues(board) && rowsAreValid(board) && columnsAreValid(board) && subgridsAreValid(board);
}

function getColumn(board: seq<seq<DafnyInt32.int32>>, c: int) : (column: seq<DafnyInt32.int32>)
  requires is9x9(board)
  requires 0 <= c < 9
  ensures |column| == 9
  ensures forall i: int :: 0 <= i < 9 ==> column[i] == board[i][c]
{
  seq(9, i requires 0 <= i < 9 => board[i][c])
}

// Helper functions to make arithmetic bounds provable for the verifier.
function Div3(i: int): int
  requires 0 <= i < 9
  ensures 0 <= Div3(i) < 3
{ i / 3 }

function Mod3(i: int): int
  requires 0 <= i < 9
  ensures 0 <= Mod3(i) < 3
{ i % 3 }

function get3x3Subgrid(board:seq<seq<DafnyInt32.int32>>, subgridRow: int, subgridColumn: int) : (subgrid : seq<DafnyInt32.int32>)
  requires is9x9(board)
  requires 0 <= subgridRow < 3
  requires 0 <= subgridColumn < 3
  ensures |subgrid| == 9
  ensures forall i: int :: 0 <= i < 9 ==> subgrid[i] == board[subgridRow * 3 + Div3(i)][subgridColumn * 3 + Mod3(i)]
{
  seq(9, i requires 0 <= i < 9 => board[subgridRow * 3 + Div3(i)][subgridColumn * 3 + Mod3(i)])
}

predicate isValidSudokuBoard(board: seq<seq<DafnyInt32.int32>>)
{
  is9x9(board) &&
  hasOnlyAllowedValues(board) &&
  rowsAreValid(board) &&
  columnsAreValid(board) &&
  subgridsAreValid(board)
}

predicate is9x9(board: seq<seq<DafnyInt32.int32>>)
{
  |board| == 9 && forall i: int :: 0 <= i < |board| ==> |board[i]| == 9
}

predicate rowsAreValid(board: seq<seq<DafnyInt32.int32>>)
{
  forall i: int :: 0 <= i < |board| ==> lineHasUniqueValues(board[i])
}

predicate columnsAreValid(board: seq<seq<DafnyInt32.int32>>)
  requires is9x9(board)
{
  forall j: int :: 0 <= j < 9 ==> lineHasUniqueValues(getColumn(board, j))
}

predicate subgridsAreValid(board: seq<seq<DafnyInt32.int32>>)
  requires is9x9(board)
{
  forall subgridRow: int, subgridColumn: int :: 0 <= subgridRow < 3 && 0 <= subgridColumn < 3 ==> lineHasUniqueValues(get3x3Subgrid(board, subgridRow, subgridColumn))
}

predicate lineHasUniqueValues(line: seq<DafnyInt32.int32>)
{
  forall i: int, j: int :: 0 <= i < j < |line| ==> line[i] == 0 || line[j] == 0 || line[i] != line[j]
}

predicate hasOnlyAllowedValues(board: seq<seq<DafnyInt32.int32>>)
{
  forall i: int, j: int:: 0 <= i < |board| && 0 <= j < |board[i]| ==> isAllowedValue(board[i][j])
}

predicate isAllowedValue(i: DafnyInt32.int32)
{
  0 <= i <= 9
}
