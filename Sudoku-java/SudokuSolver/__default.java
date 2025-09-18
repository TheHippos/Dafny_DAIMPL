// Class __default
// Dafny class __default compiled into Java
package SudokuSolver;

@SuppressWarnings({"unchecked", "deprecation"})
public class __default {
  public __default() {
  }
  public static boolean[] Run(dafny.Array2<java.lang.Byte>[] boards)
  {
    boolean[] solvable = new boolean[0];
    if(true) {
      java.util.function.Function<java.math.BigInteger, Boolean> _init0 = ((java.util.function.Function<java.math.BigInteger, Boolean>)(_0_i_boxed0) -> {
        java.math.BigInteger _0_i = ((java.math.BigInteger)(java.lang.Object)(_0_i_boxed0));
        return false;
      });
      boolean[] _nw0 = (boolean[]) dafny.TypeDescriptor.BOOLEAN.newArray(dafny.Helpers.toIntChecked((java.math.BigInteger.valueOf(java.lang.reflect.Array.getLength((boards)))), "Java arrays may be no larger than the maximum 32-bit signed int"));
      for (java.math.BigInteger _i0_0 = java.math.BigInteger.ZERO; _i0_0.compareTo(java.math.BigInteger.valueOf(java.lang.reflect.Array.getLength(_nw0))) < 0; _i0_0 = _i0_0.add(java.math.BigInteger.ONE)) {
        _nw0[dafny.Helpers.toInt(_i0_0)] = ((boolean)(java.lang.Object)(_init0.apply(_i0_0)));
      }
      solvable = _nw0;
      int _hi0 = (boards).length;
      for (int _1_i = 0; java.lang.Integer.compareUnsigned(_1_i, _hi0) < 0; _1_i++) {
        Datatypes.Option<dafny.Array2<java.lang.Byte>> _2_result;
        Datatypes.Option<dafny.Array2<java.lang.Byte>> _out0;
        _out0 = __default.Solve((boards)[(_1_i)]);
        _2_result = _out0;
        (solvable)[dafny.Helpers.toInt((_1_i))] = (_2_result).is_Some();
      }
    }
    return solvable;
  }
  public static Datatypes.Option<dafny.Array2<java.lang.Byte>> Solve(dafny.Array2<java.lang.Byte> board)
  {
    Datatypes.Option<dafny.Array2<java.lang.Byte>> result = Datatypes.Option.<dafny.Array2<java.lang.Byte>>Default(dafny.Array2.<java.lang.Byte>_typeDescriptor());
    if(true) {
      if (!(__default.is9x9(board))) {
        result = Datatypes.Option.<dafny.Array2<java.lang.Byte>>create_None(dafny.Array2.<java.lang.Byte>_typeDescriptor());
        return result;
      }
      boolean _0_isValid;
      boolean _out0;
      _out0 = __default.isValidBoardMethod(board);
      _0_isValid = _out0;
      if (!(_0_isValid)) {
        result = Datatypes.Option.<dafny.Array2<java.lang.Byte>>create_None(dafny.Array2.<java.lang.Byte>_typeDescriptor());
        return result;
      }
      Datatypes.Option<dafny.Array2<java.lang.Byte>> _out1;
      _out1 = __default.Solving(board);
      result = _out1;
    }
    return result;
  }
  public static Datatypes.Option<dafny.Array2<java.lang.Byte>> Solving(dafny.Array2<java.lang.Byte> board)
  {
    Datatypes.Option<dafny.Array2<java.lang.Byte>> result = Datatypes.Option.<dafny.Array2<java.lang.Byte>>Default(dafny.Array2.<java.lang.Byte>_typeDescriptor());
    Datatypes.Option<dafny.Tuple2<java.lang.Byte, java.lang.Byte>> _0_empty;
    Datatypes.Option<dafny.Tuple2<java.lang.Byte, java.lang.Byte>> _out0;
    _out0 = __default.FindEmptySlot(board);
    _0_empty = _out0;
    if ((_0_empty).is_None()) {
      result = Datatypes.Option.<dafny.Array2<java.lang.Byte>>create_Some(dafny.Array2.<java.lang.Byte>_typeDescriptor(), board);
      return result;
    }
    byte _1_r;
    _1_r = ((_0_empty).dtor_value()).dtor__0();
    byte _2_c;
    _2_c = ((_0_empty).dtor_value()).dtor__1();
    byte _hi0 = (byte) 10;
    for (byte _3_digit = (byte) 1; java.lang.Integer.compareUnsigned(_3_digit, _hi0) < 0; _3_digit++) {
      boolean _4_isValid;
      boolean _out1;
      _out1 = __default.isValidDigitMethod(board, _1_r, _2_c, (_3_digit));
      _4_isValid = _out1;
      if (_4_isValid) {
        __default.changeToSValue(board, _1_r, _2_c, (_3_digit));
        Datatypes.Option<dafny.Array2<java.lang.Byte>> _5_recursiveResult;
        Datatypes.Option<dafny.Array2<java.lang.Byte>> _out2;
        _out2 = __default.Solving(board);
        _5_recursiveResult = _out2;
        if ((_5_recursiveResult).is_Some()) {
          result = _5_recursiveResult;
          return result;
        }
        __default.changeToZero(board, _1_r, _2_c);
      }
    }
    result = Datatypes.Option.<dafny.Array2<java.lang.Byte>>create_None(dafny.Array2.<java.lang.Byte>_typeDescriptor());
    return result;
  }
  public static dafny.Array2<java.lang.Byte> copy(dafny.Array2<java.lang.Byte> board)
  {
    dafny.Array2<java.lang.Byte> boardCopy = new dafny.Array2<>(Datatypes.sValue._typeDescriptor(), 0, 0, new byte[0][]);
    if(true) {
      dafny.Function2<java.math.BigInteger, java.math.BigInteger, java.lang.Byte> _init0 = ((dafny.Function2<java.math.BigInteger, java.math.BigInteger, java.lang.Byte>)(_0_i_boxed0, _1_j_boxed0) -> {
        java.math.BigInteger _0_i = ((java.math.BigInteger)(java.lang.Object)(_0_i_boxed0));
        java.math.BigInteger _1_j = ((java.math.BigInteger)(java.lang.Object)(_1_j_boxed0));
        return (byte) 0;
      });
      dafny.Array2<java.lang.Byte> _nw0 = new dafny.Array2<>(Datatypes.sValue._typeDescriptor(), dafny.Helpers.toIntChecked((java.math.BigInteger.valueOf(9L)), "Java arrays may be no larger than the maximum 32-bit signed int"), dafny.Helpers.toIntChecked((java.math.BigInteger.valueOf(9L)), "Java arrays may be no larger than the maximum 32-bit signed int"), (Object[]) Datatypes.sValue._typeDescriptor().newArray(dafny.Helpers.toIntChecked((java.math.BigInteger.valueOf(9L)), "Java arrays may be no larger than the maximum 32-bit signed int"), dafny.Helpers.toIntChecked((java.math.BigInteger.valueOf(9L)), "Java arrays may be no larger than the maximum 32-bit signed int")));
      for (java.math.BigInteger _i0_0 = java.math.BigInteger.ZERO; _i0_0.compareTo(java.math.BigInteger.valueOf(_nw0.dim0)) < 0; _i0_0 = _i0_0.add(java.math.BigInteger.ONE)) {
        for (java.math.BigInteger _i1_0 = java.math.BigInteger.ZERO; _i1_0.compareTo(java.math.BigInteger.valueOf(_nw0.dim1)) < 0; _i1_0 = _i1_0.add(java.math.BigInteger.ONE)) {
          ((byte[][]) (_nw0).elmts)[dafny.Helpers.toInt(_i0_0)][dafny.Helpers.toInt(_i1_0)] = ((byte)(java.lang.Object)(_init0.apply(_i0_0, _i1_0)));
        }
      }
      boardCopy = _nw0;
      byte _hi0 = (byte) 9;
      for (byte _2_r = (byte) 0; java.lang.Integer.compareUnsigned(_2_r, _hi0) < 0; _2_r++) {
        byte _hi1 = (byte) 9;
        for (byte _3_c = (byte) 0; java.lang.Integer.compareUnsigned(_3_c, _hi1) < 0; _3_c++) {
          ((byte[][]) ((boardCopy)).elmts)[dafny.Helpers.toInt(dafny.Helpers.unsignedToInt((_2_r)))][dafny.Helpers.toInt(dafny.Helpers.unsignedToInt((_3_c)))] = (byte)((byte[][]) (((board)).elmts))[(dafny.Helpers.unsignedToInt(_2_r))][(dafny.Helpers.unsignedToInt(_3_c))];
        }
      }
    }
    return boardCopy;
  }
  public static boolean BoardsEqualUpTo(dafny.Array2<java.lang.Byte> b1, dafny.Array2<java.lang.Byte> b2, byte r, byte c)
  {
    return ((dafny.Function4<java.lang.Byte, java.lang.Byte, dafny.Array2<java.lang.Byte>, dafny.Array2<java.lang.Byte>, Boolean>)(__0_r0, __1_c0, _2_b1, _3_b2) -> {byte _0_r = ((byte)(java.lang.Object)(__0_r0));
    byte _1_c = ((byte)(java.lang.Object)(__1_c0));
    return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_0_boxed0) -> {
      byte _forall_var_0 = ((byte)(java.lang.Object)(_forall_var_0_boxed0));
      byte _4_i = (byte)_forall_var_0;
      if (true) {
        return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_1_boxed0) -> {
          byte _forall_var_1 = ((byte)(java.lang.Object)(_forall_var_1_boxed0));
          byte _5_j = (byte)_forall_var_1;
          if (true) {
            return !((((java.lang.Integer.compareUnsigned(_4_i, _0_r) < 0) || (((_4_i) == (_0_r)) && (java.lang.Integer.compareUnsigned(_5_j, _1_c) <= 0))) && ((((_4_i) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_4_i, (byte) 9) < 0))) && ((((_5_j) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_5_j, (byte) 9) < 0))) || (((byte)((byte[][]) (((_2_b1)).elmts))[(dafny.Helpers.unsignedToInt(_4_i))][(dafny.Helpers.unsignedToInt(_5_j))]) == ((byte)((byte[][]) (((_3_b2)).elmts))[(dafny.Helpers.unsignedToInt(_4_i))][(dafny.Helpers.unsignedToInt(_5_j))]));
          } else {
            return true;
          }
        }));
      } else {
        return true;
      }
    }));}).apply(r, c, b1, b2);
  }
  public static boolean BoardsEqualFrom(dafny.Array2<java.lang.Byte> b1, dafny.Array2<java.lang.Byte> b2, byte r, byte c)
  {
    return ((dafny.Function4<java.lang.Byte, java.lang.Byte, dafny.Array2<java.lang.Byte>, dafny.Array2<java.lang.Byte>, Boolean>)(__0_r0, __1_c0, _2_b1, _3_b2) -> {byte _0_r = ((byte)(java.lang.Object)(__0_r0));
    byte _1_c = ((byte)(java.lang.Object)(__1_c0));
    return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_0_boxed0) -> {
      byte _forall_var_0 = ((byte)(java.lang.Object)(_forall_var_0_boxed0));
      byte _4_i = (byte)_forall_var_0;
      if (true) {
        return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_1_boxed0) -> {
          byte _forall_var_1 = ((byte)(java.lang.Object)(_forall_var_1_boxed0));
          byte _5_j = (byte)_forall_var_1;
          if (true) {
            return !((((java.lang.Integer.compareUnsigned(_4_i, _0_r) > 0) || (((_4_i) == (_0_r)) && (java.lang.Integer.compareUnsigned(_5_j, _1_c) >= 0))) && ((((_4_i) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_4_i, (byte) 9) < 0))) && ((((_5_j) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_5_j, (byte) 9) < 0))) || (((byte)((byte[][]) (((_2_b1)).elmts))[(dafny.Helpers.unsignedToInt(_4_i))][(dafny.Helpers.unsignedToInt(_5_j))]) == ((byte)((byte[][]) (((_3_b2)).elmts))[(dafny.Helpers.unsignedToInt(_4_i))][(dafny.Helpers.unsignedToInt(_5_j))]));
          } else {
            return true;
          }
        }));
      } else {
        return true;
      }
    }));}).apply(r, c, b1, b2);
  }
  public static void changeToZero(dafny.Array2<java.lang.Byte> board, byte row, byte column)
  {
    ((byte[][]) ((board)).elmts)[dafny.Helpers.toInt(dafny.Helpers.unsignedToInt((row)))][dafny.Helpers.toInt(dafny.Helpers.unsignedToInt((column)))] = (byte) 0;
  }
  public static void changeToSValue(dafny.Array2<java.lang.Byte> board, byte r, byte c, byte digit)
  {
    ((byte[][]) ((board)).elmts)[dafny.Helpers.toInt(dafny.Helpers.unsignedToInt((r)))][dafny.Helpers.toInt(dafny.Helpers.unsignedToInt((c)))] = digit;
  }
  public static byte nextRow(byte row, byte column)
  {
    if ((column) == ((byte) 8)) {
      return (byte) (byte) ((byte)((row) + ((byte) 1)));
    } else {
      return row;
    }
  }
  public static byte nextColumn(byte row, byte column)
  {
    if ((column) == ((byte) 8)) {
      return (byte) 0;
    } else {
      return (byte) (byte) ((byte)((column) + ((byte) 1)));
    }
  }
  public static byte prevRow(byte row, byte column)
  {
    if (((column) == 0 ? 0 : 1) == 0) {
      return (byte) (byte) ((byte)((row) - ((byte) 1)));
    } else {
      return row;
    }
  }
  public static byte prevColumn(byte row, byte column)
  {
    if (((column) == 0 ? 0 : 1) == 0) {
      return (byte) 8;
    } else {
      return (byte) (byte) ((byte)((column) - ((byte) 1)));
    }
  }
  public static Datatypes.Option<dafny.Tuple2<java.lang.Byte, java.lang.Byte>> FindEmptySlot(dafny.Array2<java.lang.Byte> board)
  {
    Datatypes.Option<dafny.Tuple2<java.lang.Byte, java.lang.Byte>> slot = Datatypes.Option.<dafny.Tuple2<java.lang.Byte, java.lang.Byte>>Default(dafny.Tuple2.<java.lang.Byte, java.lang.Byte>_typeDescriptor(Datatypes.uint8._typeDescriptor(), Datatypes.uint8._typeDescriptor()));
    byte _hi0 = (byte) 9;
    for (byte _0_i = (byte) 0; java.lang.Integer.compareUnsigned(_0_i, _hi0) < 0; _0_i++) {
      byte _hi1 = (byte) 9;
      for (byte _1_j = (byte) 0; java.lang.Integer.compareUnsigned(_1_j, _hi1) < 0; _1_j++) {
        if ((((byte)((byte[][]) (((board)).elmts))[(dafny.Helpers.unsignedToInt(_0_i))][(dafny.Helpers.unsignedToInt(_1_j))]) == 0 ? 0 : 1) == 0) {
          slot = Datatypes.Option.<dafny.Tuple2<java.lang.Byte, java.lang.Byte>>create_Some(dafny.Tuple2.<java.lang.Byte, java.lang.Byte>_typeDescriptor(Datatypes.uint8._typeDescriptor(), Datatypes.uint8._typeDescriptor()), dafny.Tuple2.<java.lang.Byte, java.lang.Byte>create(_0_i, _1_j));
          return slot;
        }
      }
    }
    slot = Datatypes.Option.<dafny.Tuple2<java.lang.Byte, java.lang.Byte>>create_None(dafny.Tuple2.<java.lang.Byte, java.lang.Byte>_typeDescriptor(Datatypes.uint8._typeDescriptor(), Datatypes.uint8._typeDescriptor()));
    return slot;
  }
  public static byte EmptySlotCountRecursiveUpwards(dafny.Array2<java.lang.Byte> board, byte r, byte c)
  {
    byte _0_current__cell__val = (((((byte)((byte[][]) (((board)).elmts))[(dafny.Helpers.unsignedToInt(r))][(dafny.Helpers.unsignedToInt(c))]) == 0 ? 0 : 1) == 0) ? ((byte) 1) : ((byte) 0));
    if (((r) == ((byte) 8)) && ((c) == ((byte) 8))) {
      return _0_current__cell__val;
    } else {
      byte _1_nextRow = __default.nextRow(r, c);
      byte _2_nextColumn = __default.nextColumn(r, c);
      byte _3_recursiveResult = __default.EmptySlotCountRecursiveUpwards(board, _1_nextRow, _2_nextColumn);
      return (byte) (byte) ((byte)((_0_current__cell__val) + (_3_recursiveResult)));
    }
  }
  public static byte EmptySlotCountRecursiveDownwards(dafny.Array2<java.lang.Byte> board, byte r, byte c)
  {
    byte _0_current__cell__val = (((((byte)((byte[][]) (((board)).elmts))[(dafny.Helpers.unsignedToInt(r))][(dafny.Helpers.unsignedToInt(c))]) == 0 ? 0 : 1) == 0) ? ((byte) 1) : ((byte) 0));
    if ((((r) == 0 ? 0 : 1) == 0) && (((c) == 0 ? 0 : 1) == 0)) {
      return _0_current__cell__val;
    } else {
      byte _1_prev__r = __default.prevRow(r, c);
      byte _2_prev__c = __default.prevColumn(r, c);
      byte _3_recursiveResult = __default.EmptySlotCountRecursiveDownwards(board, _1_prev__r, _2_prev__c);
      return (byte) (byte) ((byte)((_0_current__cell__val) + (_3_recursiveResult)));
    }
  }
  public static byte EmptySlotCount(dafny.Array2<java.lang.Byte> board) {
    return __default.EmptySlotCountRecursiveDownwards(board, (byte) 8, (byte) 8);
  }
  public static boolean is9x9(dafny.Array2<java.lang.Byte> board) {
    return (java.util.Objects.equals(java.math.BigInteger.valueOf((board).dim0), java.math.BigInteger.valueOf(9L))) && (java.util.Objects.equals(java.math.BigInteger.valueOf((board).dim1), java.math.BigInteger.valueOf(9L)));
  }
  public static boolean isValidDigitMethod(dafny.Array2<java.lang.Byte> board, byte row, byte column, byte digit)
  {
    boolean isValid = false;
    if (((digit) == 0 ? 0 : 1) == 0) {
      isValid = true;
      return isValid;
    }
    byte _hi0 = (byte) 9;
    for (byte _0_i = (byte) 0; java.lang.Integer.compareUnsigned(_0_i, _hi0) < 0; _0_i++) {
      if (((_0_i) != (column)) && (((byte)((byte[][]) (((board)).elmts))[(dafny.Helpers.unsignedToInt(row))][(dafny.Helpers.unsignedToInt(_0_i))]) == (digit))) {
        isValid = false;
        return isValid;
      }
      if (((_0_i) != (row)) && (((byte)((byte[][]) (((board)).elmts))[(dafny.Helpers.unsignedToInt(_0_i))][(dafny.Helpers.unsignedToInt(column))]) == (digit))) {
        isValid = false;
        return isValid;
      }
    }
    byte _1_box__row;
    _1_box__row = (byte) (byte) ((byte)((dafny.Helpers.divideUnsignedByte(row, (byte) 3)) * ((byte) 3)));
    byte _2_box__col;
    _2_box__col = (byte) (byte) ((byte)((dafny.Helpers.divideUnsignedByte(column, (byte) 3)) * ((byte) 3)));
    byte _hi1 = (byte) (byte) ((byte)((_1_box__row) + ((byte) 3)));
    for (byte _3_r = _1_box__row; java.lang.Integer.compareUnsigned(_3_r, _hi1) < 0; _3_r++) {
      byte _hi2 = (byte) (byte) ((byte)((_2_box__col) + ((byte) 3)));
      for (byte _4_c = _2_box__col; java.lang.Integer.compareUnsigned(_4_c, _hi2) < 0; _4_c++) {
        if ((((_3_r) != (row)) || ((_4_c) != (column))) && (((byte)((byte[][]) (((board)).elmts))[(dafny.Helpers.unsignedToInt(_3_r))][(dafny.Helpers.unsignedToInt(_4_c))]) == (digit))) {
          isValid = false;
          return isValid;
        }
      }
    }
    isValid = true;
    return isValid;
  }
  public static boolean isValidDigit(dafny.Array2<java.lang.Byte> board, byte row, byte column, byte digit)
  {
    return ((__default.isValidInRow(board, row, column, digit)) && (__default.isValidInColumn(board, row, column, digit))) && (__default.isValidIn3x3(board, row, column, digit));
  }
  public static boolean isValidInRow(dafny.Array2<java.lang.Byte> board, byte row, byte column, byte digit)
  {
    return (((digit) == 0 ? 0 : 1) == 0) || (((dafny.Function4<java.lang.Byte, dafny.Array2<java.lang.Byte>, java.lang.Byte, java.lang.Byte, Boolean>)(__0_column0, _1_board, __2_row0, __3_digit0) -> {byte _0_column = ((byte)(java.lang.Object)(__0_column0));
    byte _2_row = ((byte)(java.lang.Object)(__2_row0));
    byte _3_digit = ((byte)(java.lang.Object)(__3_digit0));
    return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_0_boxed0) -> {
      byte _forall_var_0 = ((byte)(java.lang.Object)(_forall_var_0_boxed0));
      byte _4_c = (byte)_forall_var_0;
      if (true) {
        return !((((_4_c) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_4_c, (byte) 9) < 0)) || (((_4_c) == (_0_column)) || (((byte)((byte[][]) (((_1_board)).elmts))[(dafny.Helpers.unsignedToInt(_2_row))][(dafny.Helpers.unsignedToInt(_4_c))]) != (_3_digit)));
      } else {
        return true;
      }
    }));}).apply(column, board, row, digit));
  }
  public static boolean isValidInColumn(dafny.Array2<java.lang.Byte> board, byte row, byte column, byte digit)
  {
    return (((digit) == 0 ? 0 : 1) == 0) || (((dafny.Function4<java.lang.Byte, dafny.Array2<java.lang.Byte>, java.lang.Byte, java.lang.Byte, Boolean>)(__0_row0, _1_board, __2_column0, __3_digit0) -> {byte _0_row = ((byte)(java.lang.Object)(__0_row0));
    byte _2_column = ((byte)(java.lang.Object)(__2_column0));
    byte _3_digit = ((byte)(java.lang.Object)(__3_digit0));
    return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_0_boxed0) -> {
      byte _forall_var_0 = ((byte)(java.lang.Object)(_forall_var_0_boxed0));
      byte _4_r = (byte)_forall_var_0;
      if (true) {
        return !((((_4_r) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_4_r, (byte) 9) < 0)) || (((_4_r) == (_0_row)) || (((byte)((byte[][]) (((_1_board)).elmts))[(dafny.Helpers.unsignedToInt(_4_r))][(dafny.Helpers.unsignedToInt(_2_column))]) != (_3_digit)));
      } else {
        return true;
      }
    }));}).apply(row, board, column, digit));
  }
  public static boolean isValidIn3x3(dafny.Array2<java.lang.Byte> board, byte row, byte column, byte digit)
  {
    byte _0_box__row = (byte) (byte) ((byte)((dafny.Helpers.divideUnsignedByte(row, (byte) 3)) * ((byte) 3)));
    byte _1_box__col = (byte) (byte) ((byte)((dafny.Helpers.divideUnsignedByte(column, (byte) 3)) * ((byte) 3)));
    return (((digit) == 0 ? 0 : 1) == 0) || (((dafny.Function6<java.lang.Byte, java.lang.Byte, java.lang.Byte, java.lang.Byte, dafny.Array2<java.lang.Byte>, java.lang.Byte, Boolean>)(__2_box__row0, __3_box__col0, __4_row0, __5_column0, _6_board, __7_digit0) -> {byte _2_box__row = ((byte)(java.lang.Object)(__2_box__row0));
    byte _3_box__col = ((byte)(java.lang.Object)(__3_box__col0));
    byte _4_row = ((byte)(java.lang.Object)(__4_row0));
    byte _5_column = ((byte)(java.lang.Object)(__5_column0));
    byte _7_digit = ((byte)(java.lang.Object)(__7_digit0));
    return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(256L)), true, ((_forall_var_0_boxed0) -> {
      byte _forall_var_0 = ((byte)(java.lang.Object)(_forall_var_0_boxed0));
      byte _8_r = (byte)_forall_var_0;
      if (true) {
        return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(256L)), true, ((_forall_var_1_boxed0) -> {
          byte _forall_var_1 = ((byte)(java.lang.Object)(_forall_var_1_boxed0));
          byte _9_c = (byte)_forall_var_1;
          if (true) {
            return !(((java.lang.Integer.compareUnsigned(_2_box__row, _8_r) <= 0) && (java.lang.Integer.compareUnsigned(_8_r, (byte) (byte) ((byte)((_2_box__row) + ((byte) 3)))) < 0)) && ((java.lang.Integer.compareUnsigned(_3_box__col, _9_c) <= 0) && (java.lang.Integer.compareUnsigned(_9_c, (byte) (byte) ((byte)((_3_box__col) + ((byte) 3)))) < 0))) || ((((_8_r) == (_4_row)) && ((_9_c) == (_5_column))) || (((byte)((byte[][]) (((_6_board)).elmts))[(dafny.Helpers.unsignedToInt(_8_r))][(dafny.Helpers.unsignedToInt(_9_c))]) != (_7_digit)));
          } else {
            return true;
          }
        }));
      } else {
        return true;
      }
    }));}).apply(_0_box__row, _1_box__col, row, column, board, digit));
  }
  public static boolean isValidBoardMethod(dafny.Array2<java.lang.Byte> board)
  {
    boolean isValid = false;
    byte _hi0 = (byte) 9;
    for (byte _0_r = (byte) 0; java.lang.Integer.compareUnsigned(_0_r, _hi0) < 0; _0_r++) {
      byte _hi1 = (byte) 9;
      for (byte _1_c = (byte) 0; java.lang.Integer.compareUnsigned(_1_c, _hi1) < 0; _1_c++) {
        boolean _2_isValidDigit;
        boolean _out0;
        _out0 = __default.isValidDigitMethod(board, _0_r, _1_c, (byte)((byte[][]) (((board)).elmts))[(dafny.Helpers.unsignedToInt(_0_r))][(dafny.Helpers.unsignedToInt(_1_c))]);
        _2_isValidDigit = _out0;
        if (!(_2_isValidDigit)) {
          isValid = false;
          return isValid;
        }
      }
    }
    isValid = true;
    return isValid;
  }
  public static boolean isValidBoard(dafny.Array2<java.lang.Byte> board) {
    return ((java.util.function.Function<dafny.Array2<java.lang.Byte>, Boolean>)(_0_board) -> {return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_0_boxed0) -> {
      byte _forall_var_0 = ((byte)(java.lang.Object)(_forall_var_0_boxed0));
      byte _1_r = (byte)_forall_var_0;
      if (true) {
        return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_1_boxed0) -> {
          byte _forall_var_1 = ((byte)(java.lang.Object)(_forall_var_1_boxed0));
          byte _2_c = (byte)_forall_var_1;
          if (true) {
            return !(((((_1_r) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_1_r, (byte) 9) < 0)) && ((((_2_c) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_2_c, (byte) 9) < 0))) || (__default.isValidDigit(_0_board, _1_r, _2_c, (byte)((byte[][]) (((_0_board)).elmts))[(dafny.Helpers.unsignedToInt(_1_r))][(dafny.Helpers.unsignedToInt(_2_c))]));
          } else {
            return true;
          }
        }));
      } else {
        return true;
      }
    }));}).apply(board);
  }
  public static boolean isFullBoard(dafny.Array2<java.lang.Byte> board) {
    return ((java.util.function.Function<dafny.Array2<java.lang.Byte>, Boolean>)(_0_board) -> {return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_0_boxed0) -> {
      byte _forall_var_0 = ((byte)(java.lang.Object)(_forall_var_0_boxed0));
      byte _1_r = (byte)_forall_var_0;
      if (true) {
        return dafny.Helpers.Quantifier(Datatypes.uint8.IntegerRange(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(9L)), true, ((_forall_var_1_boxed0) -> {
          byte _forall_var_1 = ((byte)(java.lang.Object)(_forall_var_1_boxed0));
          byte _2_c = (byte)_forall_var_1;
          if (true) {
            return !(((((_1_r) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_1_r, (byte) 9) < 0)) && ((((_2_c) == 0 ? 0 : 1) != -1) && (java.lang.Integer.compareUnsigned(_2_c, (byte) 9) < 0))) || ((java.lang.Integer.compareUnsigned((byte) 1, (byte)((byte[][]) (((_0_board)).elmts))[(dafny.Helpers.unsignedToInt(_1_r))][(dafny.Helpers.unsignedToInt(_2_c))]) <= 0) && (java.lang.Integer.compareUnsigned((byte)((byte[][]) (((_0_board)).elmts))[(dafny.Helpers.unsignedToInt(_1_r))][(dafny.Helpers.unsignedToInt(_2_c))], (byte) 9) <= 0));
          } else {
            return true;
          }
        }));
      } else {
        return true;
      }
    }));}).apply(board);
  }
  @Override
  public java.lang.String toString() {
    return "SudokuSolver._default";
  }
}
