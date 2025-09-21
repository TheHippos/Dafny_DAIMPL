using System.Collections.Concurrent;
using System.Diagnostics;
using Board = byte[,];

public static class SudokuParser
{
    private const int GridSize = 9;
    private const int TotalCells = GridSize * GridSize;

    /// <summary>
    /// Loads Sudoku puzzles from a file in parallel, returning two identical arrays of boards.
    /// This method is optimized for speed on multi-core systems.
    /// Each line in the file is expected to be an 81-digit string representing a puzzle.
    /// </summary>
    /// <param name="filePath">The path to the puzzle file.</param>
    /// <returns>A tuple containing two identical arrays of populated Board objects (byte[,]).</returns>
    /// <exception cref="FileNotFoundException">Thrown if the specified file does not exist.</exception>
    public static (Board[], Board[]) LoadPuzzlesFromFile(string filePath)
    {
        if (!File.Exists(filePath))
        {
            throw new FileNotFoundException($"Error: The file '{filePath}' was not found.", filePath);
        }

        var boards1 = new ConcurrentBag<Board>();
        var boards2 = new ConcurrentBag<Board>();

        Parallel.ForEach(File.ReadLines(filePath), line =>
        {
            Board? board = TryParseBoard(line);
            if (board != null)
            {
                boards1.Add(board);

                var boardCopy = new byte[GridSize, GridSize];
                Array.Copy(board, boardCopy, board.Length);
                boards2.Add(boardCopy);
            }
        });

        return (boards1.ToArray(), boards2.ToArray());
    }

    /// <summary>
    /// Attempts to parse a single string into a Board object.
    /// </summary>
    /// <param name="puzzleString">The 81-character string representing the puzzle.</param>
    /// <returns>A new Board (byte[,]) if parsing is successful; otherwise, null.</returns>
    private static Board? TryParseBoard(string puzzleString)
    {
        if (string.IsNullOrWhiteSpace(puzzleString) || puzzleString.Length != TotalCells)
        {
            return null;
        }

        var board = new byte[GridSize, GridSize];
        for (int i = 0; i < TotalCells; i++)
        {
            char cellChar = puzzleString[i];
            if (!char.IsDigit(cellChar))
            {
                // Note: For extreme performance, this check could be removed if the input
                // file is guaranteed to be 100% valid. However, it's safer to keep it.
                return null;
            }

            int row = i / GridSize;
            int col = i % GridSize;
            board[row, col] = (byte)(cellChar - '0');
        }

        return board;
    }
}

public class SudokuByHand
{
    public static void Main(string[] args)
    {
        if (args.Length != 1)
        {
            Console.WriteLine("Usage: SudokuByHand <puzzle_file>");
            return;
        }
        string puzzleFile = args[0];
        var (boards1, boards2) = SudokuParser.LoadPuzzlesFromFile(puzzleFile);
        if (boards1 == null || boards2 == null)
        {
            Console.WriteLine("Something went wrong when reading the file, results are null");
            return;
        }
        SudokuByHand.Test(boards1, boards2);
    }
    public static void Test(Board[] boards1, Board[] boards2)
    {
        var sw1 = Stopwatch.StartNew();
        Run(boards1);
        sw1.Stop();
        Console.WriteLine($"csharp_handwritten,{boards1.Length},{sw1.ElapsedMilliseconds}");

        var sw2 = Stopwatch.StartNew();
        SudokuSolver.__default.Run(boards2);
        sw2.Stop();
        Console.WriteLine($"csharp_dafny,{boards2.Length},{sw2.ElapsedMilliseconds}");
    }

    public ref struct Option<T>
    {
        public bool IsSome { get; }
        private readonly T _value;

        public T Value
        {
            get
            {
                if (!IsSome)
                {
                    throw new InvalidOperationException("Cannot access the value of a None option.");
                }
                return _value;
            }
        }

        private Option(T value, bool isSome)
        {
            _value = value;
            IsSome = isSome;
        }

        public static Option<T> Some(T value) => new Option<T>(value, true);
        public static Option<T> None() => new Option<T>(default(T), false);
    }

    public static bool[] Run(Board[] boards)
    {
        var results = new bool[boards.Length];
        for (int i = 0; i < boards.Length; i++)
        {
            byte[,] board = boards[i];
            var result = Solve(board);
            results[i] = result.IsSome;
        }
        return results;
    }
    public static Option<Board> Solve(Board board)
    {
        if (!Is9x9(board))
        {
            return Option<Board>.None();
        }
        if (!IsValidBoard(board))
        {
            return Option<Board>.None();
        }
        return Solving(board);
    }
    public static Option<Board> Solving(Board board)
    {
        var empty = FindEmptySlot(board);
        if (!empty.IsSome)
        {
            return Option<Board>.Some(board);
        }
        var (r, c) = empty.Value;
        for (byte digit = 1; digit <= 9; digit++)
        {
            if(IsValidDigit(board, r, c, digit))
            {
                board[r, c] = digit;
                var recursiveResult = Solving(board);
                if (recursiveResult.IsSome)
                {
                    return recursiveResult;
                }
                board[r, c] = 0;
            }
        }
        return Option<Board>.None();
    }

    private static Option<(byte,byte)> FindEmptySlot(byte[,] board)
    {
        for(byte r = 0; r < 9; r++)
        {
            for(byte c = 0; c < 9; c++)
            {
                if(board[r,c] == 0)
                    return Option<(byte,byte)>.Some(new(r,c));
            }
        }
        return Option<(byte, byte)>.None();
    }

    public static bool Is9x9(Board board)
    {
        return board.GetLength(0) == 9 && board.GetLength(1) == 9;
    }
    public static bool IsValidBoard(Board board)
    {
        for (byte r = 0; r < board.GetLength(0); r++)
        {
            for (byte c = 0; c < board.GetLength(1); c++)
            {
                if (!IsValidDigit(board, r, c, board[r,c]))
                    return false;
            }
        }
        return true;
    }
    public static bool IsValidDigit(Board board, byte row, byte column, byte digit)
    {
        return IsValidInRowAndColumn(board, row, column, digit) && IsValidIn3x3(board,row, column, digit);
    }

    public static bool IsValidInRowAndColumn(Board board, byte row, byte column, byte digit)
    {
        if (digit == 0)
            return true;
        for (byte b = 0;b < 9; b++)
        {
            if (b != column && board[row, b] == digit)
            {
                return false;
            }
            if (b != row && board[b, column] == digit)
            {
                return false;
            }
        }
        return true;
    }
    
    public static bool IsValidIn3x3(Board board, byte row, byte column, byte digit)
    {
        byte box_row = (byte)(row / 3 * 3);
        byte box_column = (byte)(column / 3 * 3);
        if (digit == 0)
            return true;

        for (byte r = box_row; r < box_row + 3; r++)
        {
            for(byte c = box_column; c < box_column + 3; c++)
            {
                if (r == row && c == column)
                    continue;
                if (board[r, c] == digit)
                    return false;
            }
        }
        return true;
    }
}