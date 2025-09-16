using System.Diagnostics;
using Board = byte[,];

public class SudokuProgram
{
    public static void Main(string[] args)
    {
        SudokuProgram.Test();
    }
    public static void Test()
    {
        byte[][,] boards1 = new byte[][,]
{
            new byte[,]
            {
                { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
                { 0, 0, 0, 0, 0, 3, 0, 8, 5 },
                { 0, 0, 1, 0, 2, 0, 0, 0, 0 },
                { 0, 0, 0, 5, 0, 7, 0, 0, 0 },
                { 0, 0, 4, 0, 0, 0, 1, 0, 0 },
                { 0, 9, 0, 0, 0, 0, 0, 0, 0 },
                { 5, 0, 0, 0, 0, 0, 0, 7, 3 },
                { 0, 0, 2, 0, 1, 0, 0, 0, 0 },
                { 0, 0, 0, 0, 4, 0, 0, 0, 9 },
            }
};
        byte[][,] boards2 = new byte[][,]
        {
            new byte[,]
            {
                { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
                { 0, 0, 0, 0, 0, 3, 0, 8, 5 },
                { 0, 0, 1, 0, 2, 0, 0, 0, 0 },
                { 0, 0, 0, 5, 0, 7, 0, 0, 0 },
                { 0, 0, 4, 0, 0, 0, 1, 0, 0 },
                { 0, 9, 0, 0, 0, 0, 0, 0, 0 },
                { 5, 0, 0, 0, 0, 0, 0, 7, 3 },
                { 0, 0, 2, 0, 1, 0, 0, 0, 0 },
                { 0, 0, 0, 0, 4, 0, 0, 0, 9 },
            }
        };
        var sw1 = Stopwatch.StartNew();
        var results1 = Run(boards1);
        sw1.Stop();
        Console.WriteLine($"SudokuProgram.Run took {sw1.ElapsedMilliseconds} ms");
        PrintResults(boards1, results1);
        var sw2 = Stopwatch.StartNew();
        var results2 = SudokuSolver.__default.Run(boards2);
        sw2.Stop();
        Console.WriteLine($"SudokuSolver.__default.Run took {sw2.ElapsedMilliseconds} ms");
        PrintResults(boards2, results2);
    }
    public static void PrintResults(Board[] boards, bool[] results)
    {
        Console.WriteLine("results:");
        for (int i = 0; i < results.Length; i++)
        {
            if (results[i])
            {
                Console.WriteLine($"Board {i} solvable:");
                PrintBoard(boards[i]);
            }
            else
            {

                Console.WriteLine($"Board {i} not solvable:");
            }
        }
    }
    public class Option<T>
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

    public static void PrintBoard(Board board)
    {
        for (int r = 0; r < 9; r++)
        {
            if (r % 3 == 0)
            { Console.WriteLine("-------------------------"); }
            for (int c = 0; c < 9; c++)
            {
                if (c % 3 == 0)
                { Console.Write("| "); }
                if (board[r,c] == 0)
                {
                    Console.Write(". ");
                }
                else
                {
                    Console.Write(board[r,c] + " ");
                }
            }
            Console.WriteLine("|");
        }
        Console.WriteLine("-------------------------");
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
        var r = empty.Value.Item1;
        var c = empty.Value.Item2;
        for(byte digit = 1; digit <= 9; digit++)
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

    private static Option<Tuple<byte,byte>> FindEmptySlot(byte[,] board)
    {
        for(byte r = 0; r < 9; r++)
        {
            for(byte c = 0; c < 9; c++)
            {
                if(board[r,c] == 0)
                    return Option<Tuple<byte,byte>>.Some(new(r,c));
            }
        }
        return Option<Tuple<byte, byte>>.None();
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