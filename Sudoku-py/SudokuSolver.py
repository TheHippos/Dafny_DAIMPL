import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_ as module_
import _dafny as _dafny
import System_ as System_
import Datatypes as Datatypes

# Module: SudokuSolver

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def Run(boards):
        solvable: _dafny.Array = _dafny.Array(None, 0)
        def lambda0_(d_0_i_):
            return False

        init0_ = lambda0_
        nw0_ = _dafny.Array(None, (boards).length(0))
        for i0_0_ in range(nw0_.length(0)):
            nw0_[i0_0_] = init0_(i0_0_)
        solvable = nw0_
        hi0_ = (boards).length(0)
        for d_1_i_ in range(0, hi0_):
            d_2_result_: Datatypes.Option
            out0_: Datatypes.Option
            out0_ = default__.Solve((boards)[d_1_i_])
            d_2_result_ = out0_
            (solvable)[(d_1_i_)] = (d_2_result_).is_Some
        return solvable

    @staticmethod
    def Solve(board):
        result: Datatypes.Option = Datatypes.Option.default()()
        if not(default__.is9x9(board)):
            result = Datatypes.Option_None()
            return result
        d_0_isValid_: bool
        out0_: bool
        out0_ = default__.isValidBoardMethod(board)
        d_0_isValid_ = out0_
        if not(d_0_isValid_):
            result = Datatypes.Option_None()
            return result
        out1_: Datatypes.Option
        out1_ = default__.Solving(board)
        result = out1_
        return result

    @staticmethod
    def Solving(board):
        result: Datatypes.Option = Datatypes.Option.default()()
        d_0_empty_: Datatypes.Option
        out0_: Datatypes.Option
        out0_ = default__.FindEmptySlot(board)
        d_0_empty_ = out0_
        if (d_0_empty_).is_None:
            result = Datatypes.Option_Some(board)
            return result
        d_1_r_: int
        d_1_r_ = ((d_0_empty_).value)[0]
        d_2_c_: int
        d_2_c_ = ((d_0_empty_).value)[1]
        hi0_ = 10
        for d_3_digit_ in range(1, hi0_):
            d_4_isValid_: bool
            out1_: bool
            out1_ = default__.isValidDigitMethod(board, d_1_r_, d_2_c_, d_3_digit_)
            d_4_isValid_ = out1_
            if d_4_isValid_:
                default__.changeToSValue(board, d_1_r_, d_2_c_, d_3_digit_)
                d_5_recursiveResult_: Datatypes.Option
                out2_: Datatypes.Option
                out2_ = default__.Solving(board)
                d_5_recursiveResult_ = out2_
                if (d_5_recursiveResult_).is_Some:
                    result = d_5_recursiveResult_
                    return result
                default__.changeToZero(board, d_1_r_, d_2_c_)
        result = Datatypes.Option_None()
        return result
        return result

    @staticmethod
    def copy(board):
        boardCopy: _dafny.Array = _dafny.Array(None, 0, 0)
        def lambda0_(d_0_i_, d_1_j_):
            return 0

        init0_ = lambda0_
        nw0_ = _dafny.Array(None, 9, 9)
        for i0_0_ in range(nw0_.length(0)):
            for i1_0_ in range(nw0_.length(1)):
                nw0_[i0_0_, i1_0_] = init0_(i0_0_, i1_0_)
        boardCopy = nw0_
        hi0_ = 9
        for d_2_r_ in range(0, hi0_):
            hi1_ = 9
            for d_3_c_ in range(0, hi1_):
                (boardCopy)[(d_2_r_), (d_3_c_)] = (board)[d_2_r_, d_3_c_]
        return boardCopy

    @staticmethod
    def BoardsEqualUpTo(b1, b2, r, c):
        def lambda0_(forall_var_0_):
            def lambda1_(forall_var_1_):
                d_1_j_: int = forall_var_1_
                if True:
                    return not (((((d_0_i_) < (r)) or (((d_0_i_) == (r)) and ((d_1_j_) <= (c)))) and (((0) <= (d_0_i_)) and ((d_0_i_) < (9)))) and (((0) <= (d_1_j_)) and ((d_1_j_) < (9)))) or (((b1)[d_0_i_, d_1_j_]) == ((b2)[d_0_i_, d_1_j_]))
                elif True:
                    return True

            d_0_i_: int = forall_var_0_
            if True:
                return _dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda1_)
            elif True:
                return True

        return _dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda0_)

    @staticmethod
    def BoardsEqualFrom(b1, b2, r, c):
        def lambda0_(forall_var_0_):
            def lambda1_(forall_var_1_):
                d_1_j_: int = forall_var_1_
                if True:
                    return not (((((d_0_i_) > (r)) or (((d_0_i_) == (r)) and ((d_1_j_) >= (c)))) and (((0) <= (d_0_i_)) and ((d_0_i_) < (9)))) and (((0) <= (d_1_j_)) and ((d_1_j_) < (9)))) or (((b1)[d_0_i_, d_1_j_]) == ((b2)[d_0_i_, d_1_j_]))
                elif True:
                    return True

            d_0_i_: int = forall_var_0_
            if True:
                return _dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda1_)
            elif True:
                return True

        return _dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda0_)

    @staticmethod
    def changeToZero(board, row, column):
        (board)[(row), (column)] = 0

    @staticmethod
    def changeToSValue(board, r, c, digit):
        (board)[(r), (c)] = digit

    @staticmethod
    def nextRow(row, column):
        if (column) == (8):
            return (row) + (1)
        elif True:
            return row

    @staticmethod
    def nextColumn(row, column):
        if (column) == (8):
            return 0
        elif True:
            return (column) + (1)

    @staticmethod
    def prevRow(row, column):
        if (column) == (0):
            return (row) - (1)
        elif True:
            return row

    @staticmethod
    def prevColumn(row, column):
        if (column) == (0):
            return 8
        elif True:
            return (column) - (1)

    @staticmethod
    def FindEmptySlot(board):
        slot: Datatypes.Option = Datatypes.Option.default()()
        hi0_ = 9
        for d_0_i_ in range(0, hi0_):
            hi1_ = 9
            for d_1_j_ in range(0, hi1_):
                if ((board)[d_0_i_, d_1_j_]) == (0):
                    slot = Datatypes.Option_Some((d_0_i_, d_1_j_))
                    return slot
        slot = Datatypes.Option_None()
        return slot
        return slot

    @staticmethod
    def EmptySlotCountRecursiveUpwards(board, r, c):
        d_0_current__cell__val_ = (1 if ((board)[r, c]) == (0) else 0)
        if ((r) == (8)) and ((c) == (8)):
            return d_0_current__cell__val_
        elif True:
            d_1_nextRow_ = default__.nextRow(r, c)
            d_2_nextColumn_ = default__.nextColumn(r, c)
            d_3_recursiveResult_ = default__.EmptySlotCountRecursiveUpwards(board, d_1_nextRow_, d_2_nextColumn_)
            return (d_0_current__cell__val_) + (d_3_recursiveResult_)

    @staticmethod
    def EmptySlotCountRecursiveDownwards(board, r, c):
        d_0_current__cell__val_ = (1 if ((board)[r, c]) == (0) else 0)
        if ((r) == (0)) and ((c) == (0)):
            return d_0_current__cell__val_
        elif True:
            d_1_prev__r_ = default__.prevRow(r, c)
            d_2_prev__c_ = default__.prevColumn(r, c)
            d_3_recursiveResult_ = default__.EmptySlotCountRecursiveDownwards(board, d_1_prev__r_, d_2_prev__c_)
            return (d_0_current__cell__val_) + (d_3_recursiveResult_)

    @staticmethod
    def EmptySlotCount(board):
        return default__.EmptySlotCountRecursiveDownwards(board, 8, 8)

    @staticmethod
    def is9x9(board):
        return (((board).length(0)) == (9)) and (((board).length(1)) == (9))

    @staticmethod
    def isValidDigitMethod(board, row, column, digit):
        isValid: bool = False
        if (digit) == (0):
            isValid = True
            return isValid
        hi0_ = 9
        for d_0_i_ in range(0, hi0_):
            if ((d_0_i_) != (column)) and (((board)[row, d_0_i_]) == (digit)):
                isValid = False
                return isValid
            if ((d_0_i_) != (row)) and (((board)[d_0_i_, column]) == (digit)):
                isValid = False
                return isValid
        d_1_box__row_: int
        d_1_box__row_ = (_dafny.euclidian_division(row, 3)) * (3)
        d_2_box__col_: int
        d_2_box__col_ = (_dafny.euclidian_division(column, 3)) * (3)
        hi1_ = (d_1_box__row_) + (3)
        for d_3_r_ in range(d_1_box__row_, hi1_):
            hi2_ = (d_2_box__col_) + (3)
            for d_4_c_ in range(d_2_box__col_, hi2_):
                if (((d_3_r_) != (row)) or ((d_4_c_) != (column))) and (((board)[d_3_r_, d_4_c_]) == (digit)):
                    isValid = False
                    return isValid
        isValid = True
        return isValid
        return isValid

    @staticmethod
    def isValidDigit(board, row, column, digit):
        return ((default__.isValidInRow(board, row, column, digit)) and (default__.isValidInColumn(board, row, column, digit))) and (default__.isValidIn3x3(board, row, column, digit))

    @staticmethod
    def isValidInRow(board, row, column, digit):
        def lambda0_(forall_var_0_):
            d_0_c_: int = forall_var_0_
            if True:
                return not (((0) <= (d_0_c_)) and ((d_0_c_) < (9))) or (((d_0_c_) == (column)) or (((board)[row, d_0_c_]) != (digit)))
            elif True:
                return True

        return ((digit) == (0)) or (_dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda0_))

    @staticmethod
    def isValidInColumn(board, row, column, digit):
        def lambda0_(forall_var_0_):
            d_0_r_: int = forall_var_0_
            if True:
                return not (((0) <= (d_0_r_)) and ((d_0_r_) < (9))) or (((d_0_r_) == (row)) or (((board)[d_0_r_, column]) != (digit)))
            elif True:
                return True

        return ((digit) == (0)) or (_dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda0_))

    @staticmethod
    def isValidIn3x3(board, row, column, digit):
        d_0_box__row_ = (_dafny.euclidian_division(row, 3)) * (3)
        d_1_box__col_ = (_dafny.euclidian_division(column, 3)) * (3)
        def lambda0_(forall_var_0_):
            def lambda1_(forall_var_1_):
                d_3_c_: int = forall_var_1_
                if True:
                    return not ((((d_0_box__row_) <= (d_2_r_)) and ((d_2_r_) < ((d_0_box__row_) + (3)))) and (((d_1_box__col_) <= (d_3_c_)) and ((d_3_c_) < ((d_1_box__col_) + (3))))) or ((((d_2_r_) == (row)) and ((d_3_c_) == (column))) or (((board)[d_2_r_, d_3_c_]) != (digit)))
                elif True:
                    return True

            d_2_r_: int = forall_var_0_
            if True:
                return _dafny.quantifier(_dafny.IntegerRange(0, 256), True, lambda1_)
            elif True:
                return True

        return ((digit) == (0)) or (_dafny.quantifier(_dafny.IntegerRange(0, 256), True, lambda0_))

    @staticmethod
    def isValidBoardMethod(board):
        isValid: bool = False
        hi0_ = 9
        for d_0_r_ in range(0, hi0_):
            hi1_ = 9
            for d_1_c_ in range(0, hi1_):
                d_2_isValidDigit_: bool
                out0_: bool
                out0_ = default__.isValidDigitMethod(board, d_0_r_, d_1_c_, (board)[d_0_r_, d_1_c_])
                d_2_isValidDigit_ = out0_
                if not(d_2_isValidDigit_):
                    isValid = False
                    return isValid
        isValid = True
        return isValid
        return isValid

    @staticmethod
    def isValidBoard(board):
        def lambda0_(forall_var_0_):
            def lambda1_(forall_var_1_):
                d_1_c_: int = forall_var_1_
                if True:
                    return not ((((0) <= (d_0_r_)) and ((d_0_r_) < (9))) and (((0) <= (d_1_c_)) and ((d_1_c_) < (9)))) or (default__.isValidDigit(board, d_0_r_, d_1_c_, (board)[d_0_r_, d_1_c_]))
                elif True:
                    return True

            d_0_r_: int = forall_var_0_
            if True:
                return _dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda1_)
            elif True:
                return True

        return _dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda0_)

    @staticmethod
    def isFullBoard(board):
        def lambda0_(forall_var_0_):
            def lambda1_(forall_var_1_):
                d_1_c_: int = forall_var_1_
                if True:
                    return not ((((0) <= (d_0_r_)) and ((d_0_r_) < (9))) and (((0) <= (d_1_c_)) and ((d_1_c_) < (9)))) or (((1) <= ((board)[d_0_r_, d_1_c_])) and (((board)[d_0_r_, d_1_c_]) <= (9)))
                elif True:
                    return True

            d_0_r_: int = forall_var_0_
            if True:
                return _dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda1_)
            elif True:
                return True

        return _dafny.quantifier(_dafny.IntegerRange(0, 9), True, lambda0_)

