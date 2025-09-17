using System.Diagnostics;
using Board = byte[,];

public enum PuzzleDifficulty
{
    Easy,
    Medium,
    Hard
}

public class SudokuParser
{
    static Dictionary<string, Dictionary<PuzzleDifficulty, List<Board>>> cachedResults = new();
    public static Dictionary<PuzzleDifficulty, List<Board>> LoadAndClassifyPuzzlesFromFile(string filePath)
    {
        if (cachedResults.ContainsKey(filePath)) return cachedResults[filePath];
        const int EASY_THRESHOLD_ZEROS = 45;
        const int MEDIUM_THRESHOLD_ZEROS = 54;

        if (!File.Exists(filePath))
        {
            Console.WriteLine($"Error: The file '{filePath}' was not found.");
            return null;
        }

        var classifiedPuzzles = new Dictionary<PuzzleDifficulty, List<Board>>
    {
        { PuzzleDifficulty.Easy, new List<Board>() },
        { PuzzleDifficulty.Medium, new List<Board>() },
        { PuzzleDifficulty.Hard, new List<Board>() }
    };

        string[] lines = File.ReadAllLines(filePath);

        for (int i1 = 0; i1 < lines.Length - 1; i1++)
        {
            string line = lines[i1 + 1]; // Skipping the header line

            if (string.IsNullOrWhiteSpace(line))
                continue;

            string puzzleString = line.Split(',')[0];

            //if (puzzleString.Length != 81)
            //{
            //    Console.WriteLine($"Warning: Skipping malformed line {i1 + 2}. Puzzle data length is not 81: '{puzzleString}'");
            //    continue;
            //}


            Board currentBoard = new byte[9, 9];
            int zeroCount = 0;

            for (int i = 0; i < puzzleString.Length; i++)
            {
                int row = i / 9;
                int col = i % 9;
                byte cellValue = (byte)(puzzleString[i] - '0');
                if (cellValue == 0)
                {
                    zeroCount++;
                }
                currentBoard[row, col] = cellValue;
            }

            if (zeroCount <= EASY_THRESHOLD_ZEROS)
            {
                classifiedPuzzles[PuzzleDifficulty.Easy].Add(currentBoard);
            }
            else if (zeroCount <= MEDIUM_THRESHOLD_ZEROS)
            {
                classifiedPuzzles[PuzzleDifficulty.Medium].Add(currentBoard);
            }
            else
            {
                classifiedPuzzles[PuzzleDifficulty.Hard].Add(currentBoard);
            }
        }
        cachedResults[filePath] = classifiedPuzzles;
        return classifiedPuzzles;
    }
    /// <summary>
    /// Loads puzzles from a file and returns a flat array containing a random selection from each difficulty class.
    /// </summary>
    /// <param name="fileName">The path to the CSV file.</param>
    /// <param name="amountForEachClass">The number of puzzles to select from each difficulty (Easy, Medium, Hard).</param>
    /// <returns>An array of boards containing the selected puzzles.</returns>
    public static Board[] CreateASelectionOfPuzzlesFromFile(string fileName, int amountForEachClass)
    {
        var dict = LoadAndClassifyPuzzlesFromFile(fileName);

        if (dict == null)
        {
            return Array.Empty<Board>();
        }

        var selectedPuzzles = new List<Board>();
        Dictionary<PuzzleDifficulty, int> amountChosenPer = new Dictionary<PuzzleDifficulty, int>();
        foreach (PuzzleDifficulty difficulty in Enum.GetValues(typeof(PuzzleDifficulty)))
        {
            var puzzlesInClass = dict[difficulty];

            var randomSelection = puzzlesInClass
                //.OrderBy(p => Guid.NewGuid())
                .Take(amountForEachClass);
            selectedPuzzles.AddRange(randomSelection);
            amountChosenPer[difficulty] = randomSelection.Count();
        }
        return selectedPuzzles.ToArray();
    }
}

public class SudokuProgram
{
    public static void Main(string[] args)
    {
        SudokuProgram.Test();
    }
    public static void Test()
    {
        const string puzzleFile = "sudoku.csv";

        Console.WriteLine($"Loading and classifying puzzles from '{puzzleFile}'...");
        var puzzleDict = SudokuParser.LoadAndClassifyPuzzlesFromFile(puzzleFile);
        if (puzzleDict == null)
        {
            Console.WriteLine("Could not load puzzles. Aborting test.");
            return;
        }
        Console.WriteLine("Puzzles loaded successfully.");

        for (int amount = 100; amount <= 5000; amount += 100)
        {
            Console.WriteLine($"\n--- Testing with up to {amount} puzzles per class ---");

            Board[] boards1 = SudokuParser.CreateASelectionOfPuzzlesFromFile(puzzleFile, amount);
            if (boards1.Length == 0)
            {
                Console.WriteLine("Warning: No puzzles were selected for this run.");
                continue;
            }

            Board[] boards2 = new Board[boards1.Length];
            for (int i = 0; i < boards1.Length; i++)
            {
                boards2[i] = (byte[,])boards1[i].Clone();
            }

            var sw1 = Stopwatch.StartNew();
            Run(boards1);
            sw1.Stop();
            Console.WriteLine($"SudokuProgram.Run took {sw1.ElapsedMilliseconds} ms");

            var sw2 = Stopwatch.StartNew();
            SudokuSolver.__default.Run(boards2);
            sw2.Stop();
            Console.WriteLine($"SudokuSolver.__default.Run took {sw2.ElapsedMilliseconds} ms");
        }
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
        return IsValidInRow(board, row, column, digit) && IsValidInColumn(board, row, column, digit) && IsValidIn3x3(board,row, column, digit);
    }

    public static bool IsValidInRow(Board board, byte row, byte column, byte digit)
    {
        if (digit == 0)
            return true;
        for (byte c = 0;c < 9; c++)
        {
            if (c == column)
                continue;
            if (board[row, c] == digit)
            {
                return false;
            }
        }
        return true;
    }
    public static bool IsValidInColumn(Board board, byte row, byte column, byte digit)
    {
        if (digit == 0)
            return true;
        for (byte r = 0; r < 9; r++)
        {
            if (r == row)
                continue;
            if (board[r, column] == digit)
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