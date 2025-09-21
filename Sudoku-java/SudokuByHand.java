import java.io.IOException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.stream.Stream;

public class SudokuByHand {

    public record Option<T>(T value, boolean isSome) {
        public T getValue() {
            if (!isSome) {
                throw new IllegalStateException("Cannot access the value of a None option.");
            }
            return value;
        }

        public static <T> Option<T> some(T value) {
            return new Option<>(value, true);
        }

        public static <T> Option<T> none() {
            return new Option<>(null, false);
        }
    }

    public record Coordinate(byte r, byte c) {}

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java SudokuByHand <puzzle_file>");
            return;
        }
        String puzzleFile = args[0];
        try {
            var puzzles = SudokuParser.loadPuzzlesFromFile(puzzleFile);
            if (puzzles == null || puzzles.boards1() == null || puzzles.boards2() == null) {
                System.out.println("Something went wrong when reading the file, results are null");
                return;
            }
            SudokuByHand.test(puzzles.boards1(), puzzles.boards2());
        } catch (IOException e) {
            System.err.println(e.getMessage());
        }
    }

    public static void test(byte[][][] boards1, byte[][][] boards2) {
        long startTime1 = System.nanoTime();
        run(boards1);
        long endTime1 = System.nanoTime();
        System.out.printf("java_handwritten,%d,%d%n", boards1.length, (endTime1 - startTime1) / 1_000_000);


        dafny.Array2<Byte>[] dBoards2 = new dafny.Array2[boards2.length];
        for (int i = 0; i < boards2.length; i++) {
        	dBoards2[i] = new dafny.Array2(Datatypes.sValue._typeDescriptor(), 9, 9, boards2[i]);
        }

        long startTime2 = System.nanoTime();
        SudokuSolver.__default.Run(dBoards2);
        long endTime2 = System.nanoTime();
        System.out.printf("java_dafny,%d,%d%n", boards2.length, (endTime2 - startTime2) / 1_000_000);
    }

    public static boolean[] run(byte[][][] boards) {
        var results = new boolean[boards.length];
        for (int i = 0; i < boards.length; i++) {
            byte[][] board = boards[i];
            var result = solve(board);
            results[i] = result.isSome();
        }
        return results;
    }

    public static Option<byte[][]> solve(byte[][] board) {
        if (!is9x9(board)) {
            return Option.none();
        }
        if (!isValidBoard(board)) {
            return Option.none();
        }
        return solving(board);
    }

    public static Option<byte[][]> solving(byte[][] board) {
        var empty = findEmptySlot(board);
        if (!empty.isSome()) {
            return Option.some(board);
        }
        Coordinate coord = empty.getValue();
        byte r = coord.r();
        byte c = coord.c();

        for (byte digit = 1; digit <= 9; digit++) {
            if (isValidDigit(board, r, c, digit)) {
                board[r][c] = digit;
                var recursiveResult = solving(board);
                if (recursiveResult.isSome()) {
                    return recursiveResult;
                }
                board[r][c] = 0; // Backtrack
            }
        }
        return Option.none();
    }

    private static Option<Coordinate> findEmptySlot(byte[][] board) {
        for (byte r = 0; r < 9; r++) {
            for (byte c = 0; c < 9; c++) {
                if (board[r][c] == 0) {
                    return Option.some(new Coordinate(r, c));
                }
            }
        }
        return Option.none();
    }

    public static boolean is9x9(byte[][] board) {
        return board.length == 9 && board[0].length == 9;
    }

    public static boolean isValidBoard(byte[][] board) {
        for (byte r = 0; r < board.length; r++) {
            for (byte c = 0; c < board[0].length; c++) {
                if (board[r][c] != 0 && !isValidDigit(board, r, c, board[r][c])) {
                    return false;
                }
            }
        }
        return true;
    }

    public static boolean isValidDigit(byte[][] board, byte row, byte column, byte digit) {
        return isValidInRowAndColumn(board, row, column, digit) && isValidIn3x3(board, row, column, digit);
    }

    public static boolean isValidInRowAndColumn(byte[][] board, byte row, byte column, byte digit) {
        if (digit == 0) {
            return true;
        }
        for (byte b = 0; b < 9; b++) {
            if (b != column && board[row][b] == digit) {
                return false;
            }
            if (b != row && board[b][column] == digit) {
                return false;
            }
        }
        return true;
    }

    public static boolean isValidIn3x3(byte[][] board, byte row, byte column, byte digit) {
        if (digit == 0) {
            return true;
        }
        byte boxRowStart = (byte) (row / 3 * 3);
        byte boxColStart = (byte) (column / 3 * 3);

        for (byte r = boxRowStart; r < boxRowStart + 3; r++) {
            for (byte c = boxColStart; c < boxColStart + 3; c++) {
                if (r == row && c == column) {
                    continue;
                }
                if (board[r][c] == digit) {
                    return false;
                }
            }
        }
        return true;
    }
}

class SudokuParser {
    private static final int GRID_SIZE = 9;
    private static final int TOTAL_CELLS = GRID_SIZE * GRID_SIZE;

    private SudokuParser() {}

    public record PuzzleCollection(byte[][][] boards1, byte[][][] boards2) {}

    public static PuzzleCollection loadPuzzlesFromFile(String filePath) throws IOException {
        if (!Files.exists(Paths.get(filePath))) {
            throw new IOException("Error: The file '" + filePath + "' was not found.");
        }

        var boards1 = new ConcurrentLinkedQueue<byte[][]>();
        var boards2 = new ConcurrentLinkedQueue<byte[][]>();

        try (Stream<String> lines = Files.lines(Paths.get(filePath)).parallel()) {
            lines.forEach(line -> {
                byte[][] board = tryParseBoard(line);
                if (board != null) {
                    boards1.add(board);

                    // Create a deep copy for the second collection
                    var boardCopy = new byte[GRID_SIZE][GRID_SIZE];
                    for (int i = 0; i < GRID_SIZE; i++) {
                        System.arraycopy(board[i], 0, boardCopy[i], 0, GRID_SIZE);
                    }
                    boards2.add(boardCopy);
                }
            });
        }

        return new PuzzleCollection(
            boards1.toArray(new byte[0][][]),
            boards2.toArray(new byte[0][][])
        );
    }

    private static byte[][] tryParseBoard(String puzzleString) {
        if (puzzleString == null || puzzleString.isBlank() || puzzleString.length() != TOTAL_CELLS) {
            return null;
        }

        var board = new byte[GRID_SIZE][GRID_SIZE];
        for (int i = 0; i < TOTAL_CELLS; i++) {
            char cellChar = puzzleString.charAt(i);
            if (!Character.isDigit(cellChar)) {
                return null;
            }

            int row = i / GRID_SIZE;
            int col = i % GRID_SIZE;
            board[row][col] = (byte) (cellChar - '0');
        }

        return board;
    }
}