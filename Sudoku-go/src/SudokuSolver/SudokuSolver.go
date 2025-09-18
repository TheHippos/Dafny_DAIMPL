// Package SudokuSolver
// Dafny module SudokuSolver compiled into Go

package SudokuSolver

import (
	m_Datatypes "Datatypes"
	m__System "System_"
	_dafny "dafny"
	os "os"
)

var _ = os.Args
var _ _dafny.Dummy__
var _ m__System.Dummy__
var _ m_Datatypes.Dummy__

type Dummy__ struct{}

// Definition of class Default__
type Default__ struct {
	dummy byte
}

func New_Default___() *Default__ {
	_this := Default__{}

	return &_this
}

type CompanionStruct_Default___ struct {
}

var Companion_Default___ = CompanionStruct_Default___{}

func (_this *Default__) Equals(other *Default__) bool {
	return _this == other
}

func (_this *Default__) EqualsGeneric(x interface{}) bool {
	other, ok := x.(*Default__)
	return ok && _this.Equals(other)
}

func (*Default__) String() string {
	return "SudokuSolver.Default__"
}
func (_this *Default__) ParentTraits_() []*_dafny.TraitID {
	return [](*_dafny.TraitID){}
}

var _ _dafny.TraitOffspring = &Default__{}

func (_static *CompanionStruct_Default___) Run(boards _dafny.Array) _dafny.Array {
	var solvable _dafny.Array = _dafny.NewArrayWithValue(nil, _dafny.IntOf(0))
	_ = solvable
	var _len0_0 _dafny.Int = _dafny.ArrayLen((boards), 0)
	_ = _len0_0
	var _nw0 _dafny.Array
	_ = _nw0
	if _len0_0.Cmp(_dafny.Zero) == 0 {
		_nw0 = _dafny.NewArray(_len0_0)
	} else {
		var _init0 func(_dafny.Int) bool = func(_0_i _dafny.Int) bool {
			return false
		}
		_ = _init0
		var _element0_0 = _init0(_dafny.Zero)
		_ = _element0_0
		_nw0 = _dafny.NewArrayFromExample(_element0_0, nil, _len0_0)
		(_nw0).ArraySet1(_element0_0, 0)
		var _nativeLen0_0 = (_len0_0).Int()
		_ = _nativeLen0_0
		for _i0_0 := 1; _i0_0 < _nativeLen0_0; _i0_0++ {
			(_nw0).ArraySet1(_init0(_dafny.IntOf(_i0_0)), _i0_0)
		}
	}
	solvable = _nw0
	var _hi0 uint32 = uint32(_dafny.ArrayLenInt(boards, 0))
	_ = _hi0
	for _1_i := uint32(0); _1_i < _hi0; _1_i++ {
		var _2_result m_Datatypes.Option
		_ = _2_result
		var _out0 m_Datatypes.Option
		_ = _out0
		_out0 = Companion_Default___.Solve(_dafny.ArrayCastTo((boards).ArrayGet1(int(_1_i))))
		_2_result = _out0
		(solvable).ArraySet1((_2_result).Is_Some(), int((_1_i)))
	}
	return solvable
}
func (_static *CompanionStruct_Default___) Solve(board _dafny.Array) m_Datatypes.Option {
	var result m_Datatypes.Option = m_Datatypes.Companion_Option_.Default()
	_ = result
	if !(Companion_Default___.Is9x9(board)) {
		result = m_Datatypes.Companion_Option_.Create_None_()
		return result
	}
	var _0_isValid bool
	_ = _0_isValid
	var _out0 bool
	_ = _out0
	_out0 = Companion_Default___.IsValidBoardMethod(board)
	_0_isValid = _out0
	if !(_0_isValid) {
		result = m_Datatypes.Companion_Option_.Create_None_()
		return result
	}
	var _out1 m_Datatypes.Option
	_ = _out1
	_out1 = Companion_Default___.Solving(board)
	result = _out1
	return result
}
func (_static *CompanionStruct_Default___) Solving(board _dafny.Array) m_Datatypes.Option {
	var result m_Datatypes.Option = m_Datatypes.Companion_Option_.Default()
	_ = result
	var _0_empty m_Datatypes.Option
	_ = _0_empty
	var _out0 m_Datatypes.Option
	_ = _out0
	_out0 = Companion_Default___.FindEmptySlot(board)
	_0_empty = _out0
	if (_0_empty).Is_None() {
		result = m_Datatypes.Companion_Option_.Create_Some_(board)
		return result
	}
	var _1_r uint8
	_ = _1_r
	_1_r = (*((_0_empty).Dtor_value().(_dafny.Tuple)).IndexInt(0)).(uint8)
	var _2_c uint8
	_ = _2_c
	_2_c = (*((_0_empty).Dtor_value().(_dafny.Tuple)).IndexInt(1)).(uint8)
	var _hi0 uint8 = uint8(10)
	_ = _hi0
	for _3_digit := uint8(1); _3_digit < _hi0; _3_digit++ {
		var _4_isValid bool
		_ = _4_isValid
		var _out1 bool
		_ = _out1
		_out1 = Companion_Default___.IsValidDigitMethod(board, _1_r, _2_c, uint8(_3_digit))
		_4_isValid = _out1
		if _4_isValid {
			Companion_Default___.ChangeToSValue(board, _1_r, _2_c, uint8(_3_digit))
			var _5_recursiveResult m_Datatypes.Option
			_ = _5_recursiveResult
			var _out2 m_Datatypes.Option
			_ = _out2
			_out2 = Companion_Default___.Solving(board)
			_5_recursiveResult = _out2
			if (_5_recursiveResult).Is_Some() {
				result = _5_recursiveResult
				return result
			}
			Companion_Default___.ChangeToZero(board, _1_r, _2_c)
		}
	}
	result = m_Datatypes.Companion_Option_.Create_None_()
	return result
	return result
}
func (_static *CompanionStruct_Default___) Copy(board _dafny.Array) _dafny.Array {
	var boardCopy _dafny.Array = _dafny.NewArrayWithValue(nil, _dafny.IntOf(0), _dafny.IntOf(0))
	_ = boardCopy
	var _len0_0 _dafny.Int = _dafny.IntOfInt64(9)
	_ = _len0_0
	var _len1_0 _dafny.Int = _dafny.IntOfInt64(9)
	_ = _len1_0
	var _nw0 _dafny.Array
	_ = _nw0
	if _len0_0.Cmp(_dafny.Zero) == 0 || _len1_0.Cmp(_dafny.Zero) == 0 {
		_nw0 = _dafny.NewArray(_len0_0, _len1_0)
	} else {
		var _init0 func(_dafny.Int, _dafny.Int) uint8 = func(_0_i _dafny.Int, _1_j _dafny.Int) uint8 {
			return uint8(0)
		}
		_ = _init0
		var _element0_0 = _init0(_dafny.Zero, _dafny.Zero)
		_ = _element0_0
		_nw0 = _dafny.NewArrayFromExample(_element0_0, nil, _len0_0, _len1_0)
		_dafny.ArraySet(_nw0, _element0_0, 0, 0)
		var _nativeLen0_0 = (_len0_0).Int()
		_ = _nativeLen0_0
		var _nativeLen1_0 = (_len1_0).Int()
		_ = _nativeLen1_0
		var _start0 = 1
		_ = _start0
		for _i0_0 := 0; _i0_0 < _nativeLen0_0; _i0_0++ {
			for _i1_0 := _start0; _i1_0 < _nativeLen1_0; _i1_0++ {
				_dafny.ArraySet(_nw0, _init0(_dafny.IntOf(_i0_0), _dafny.IntOf(_i1_0)), _i0_0, _i1_0)
			}
			_start0 = 0
		}
	}
	boardCopy = _nw0
	var _hi0 uint8 = uint8(9)
	_ = _hi0
	for _2_r := uint8(0); _2_r < _hi0; _2_r++ {
		var _hi1 uint8 = uint8(9)
		_ = _hi1
		for _3_c := uint8(0); _3_c < _hi1; _3_c++ {
			_dafny.ArraySet((boardCopy), _dafny.ArrayGet((board), int(_2_r), int(_3_c)).(uint8), int((_2_r)), int((_3_c)))
		}
	}
	return boardCopy
}
func (_static *CompanionStruct_Default___) BoardsEqualUpTo(b1 _dafny.Array, b2 _dafny.Array, r uint8, c uint8) bool {
	return _dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_0 uint8) bool {
		var _0_i uint8
		_0_i = interface{}(_forall_var_0).(uint8)
		if true {
			return _dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_1 uint8) bool {
				var _1_j uint8
				_1_j = interface{}(_forall_var_1).(uint8)
				if true {
					return !(((((_0_i) < (r)) || (((_0_i) == (r)) && ((_1_j) <= (c)))) && (((uint8(0)) <= (_0_i)) && ((_0_i) < (uint8(9))))) && (((uint8(0)) <= (_1_j)) && ((_1_j) < (uint8(9))))) || ((_dafny.ArrayGet((b1), int(_0_i), int(_1_j)).(uint8)) == (_dafny.ArrayGet((b2), int(_0_i), int(_1_j)).(uint8)))
				} else {
					return true
				}
			})
		} else {
			return true
		}
	})
}
func (_static *CompanionStruct_Default___) BoardsEqualFrom(b1 _dafny.Array, b2 _dafny.Array, r uint8, c uint8) bool {
	return _dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_0 uint8) bool {
		var _0_i uint8
		_0_i = interface{}(_forall_var_0).(uint8)
		if true {
			return _dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_1 uint8) bool {
				var _1_j uint8
				_1_j = interface{}(_forall_var_1).(uint8)
				if true {
					return !(((((_0_i) > (r)) || (((_0_i) == (r)) && ((_1_j) >= (c)))) && (((uint8(0)) <= (_0_i)) && ((_0_i) < (uint8(9))))) && (((uint8(0)) <= (_1_j)) && ((_1_j) < (uint8(9))))) || ((_dafny.ArrayGet((b1), int(_0_i), int(_1_j)).(uint8)) == (_dafny.ArrayGet((b2), int(_0_i), int(_1_j)).(uint8)))
				} else {
					return true
				}
			})
		} else {
			return true
		}
	})
}
func (_static *CompanionStruct_Default___) ChangeToZero(board _dafny.Array, row uint8, column uint8) {
	_dafny.ArraySet((board), uint8(0), int((row)), int((column)))
}
func (_static *CompanionStruct_Default___) ChangeToSValue(board _dafny.Array, r uint8, c uint8, digit uint8) {
	_dafny.ArraySet((board), digit, int((r)), int((c)))
}
func (_static *CompanionStruct_Default___) NextRow(row uint8, column uint8) uint8 {
	if (column) == (uint8(8)) {
		return (row) + (uint8(1))
	} else {
		return row
	}
}
func (_static *CompanionStruct_Default___) NextColumn(row uint8, column uint8) uint8 {
	if (column) == (uint8(8)) {
		return uint8(0)
	} else {
		return (column) + (uint8(1))
	}
}
func (_static *CompanionStruct_Default___) PrevRow(row uint8, column uint8) uint8 {
	if (column) == (uint8(0)) {
		return (row) - (func() uint8 { return (uint8(1)) })()
	} else {
		return row
	}
}
func (_static *CompanionStruct_Default___) PrevColumn(row uint8, column uint8) uint8 {
	if (column) == (uint8(0)) {
		return uint8(8)
	} else {
		return (column) - (func() uint8 { return (uint8(1)) })()
	}
}
func (_static *CompanionStruct_Default___) FindEmptySlot(board _dafny.Array) m_Datatypes.Option {
	var slot m_Datatypes.Option = m_Datatypes.Companion_Option_.Default()
	_ = slot
	var _hi0 uint8 = uint8(9)
	_ = _hi0
	for _0_i := uint8(0); _0_i < _hi0; _0_i++ {
		var _hi1 uint8 = uint8(9)
		_ = _hi1
		for _1_j := uint8(0); _1_j < _hi1; _1_j++ {
			if (_dafny.ArrayGet((board), int(_0_i), int(_1_j)).(uint8)) == (uint8(0)) {
				slot = m_Datatypes.Companion_Option_.Create_Some_(_dafny.TupleOf(_0_i, _1_j))
				return slot
			}
		}
	}
	slot = m_Datatypes.Companion_Option_.Create_None_()
	return slot
	return slot
}
func (_static *CompanionStruct_Default___) EmptySlotCountRecursiveUpwards(board _dafny.Array, r uint8, c uint8) uint8 {
	var _0_current__cell__val uint8 = (func() uint8 {
		if (_dafny.ArrayGet((board), int(r), int(c)).(uint8)) == (uint8(0)) {
			return uint8(1)
		}
		return uint8(0)
	})()
	_ = _0_current__cell__val
	if ((r) == (uint8(8))) && ((c) == (uint8(8))) {
		return _0_current__cell__val
	} else {
		var _1_nextRow uint8 = Companion_Default___.NextRow(r, c)
		_ = _1_nextRow
		var _2_nextColumn uint8 = Companion_Default___.NextColumn(r, c)
		_ = _2_nextColumn
		var _3_recursiveResult uint8 = Companion_Default___.EmptySlotCountRecursiveUpwards(board, _1_nextRow, _2_nextColumn)
		_ = _3_recursiveResult
		return (_0_current__cell__val) + (_3_recursiveResult)
	}
}
func (_static *CompanionStruct_Default___) EmptySlotCountRecursiveDownwards(board _dafny.Array, r uint8, c uint8) uint8 {
	var _0_current__cell__val uint8 = (func() uint8 {
		if (_dafny.ArrayGet((board), int(r), int(c)).(uint8)) == (uint8(0)) {
			return uint8(1)
		}
		return uint8(0)
	})()
	_ = _0_current__cell__val
	if ((r) == (uint8(0))) && ((c) == (uint8(0))) {
		return _0_current__cell__val
	} else {
		var _1_prev__r uint8 = Companion_Default___.PrevRow(r, c)
		_ = _1_prev__r
		var _2_prev__c uint8 = Companion_Default___.PrevColumn(r, c)
		_ = _2_prev__c
		var _3_recursiveResult uint8 = Companion_Default___.EmptySlotCountRecursiveDownwards(board, _1_prev__r, _2_prev__c)
		_ = _3_recursiveResult
		return (_0_current__cell__val) + (_3_recursiveResult)
	}
}
func (_static *CompanionStruct_Default___) EmptySlotCount(board _dafny.Array) uint8 {
	return Companion_Default___.EmptySlotCountRecursiveDownwards(board, uint8(8), uint8(8))
}
func (_static *CompanionStruct_Default___) Is9x9(board _dafny.Array) bool {
	return ((_dafny.ArrayLen((board), 0)).Cmp(_dafny.IntOfInt64(9)) == 0) && ((_dafny.ArrayLen((board), 1)).Cmp(_dafny.IntOfInt64(9)) == 0)
}
func (_static *CompanionStruct_Default___) IsValidDigitMethod(board _dafny.Array, row uint8, column uint8, digit uint8) bool {
	var isValid bool = false
	_ = isValid
	if (digit) == (uint8(0)) {
		isValid = true
		return isValid
	}
	var _hi0 uint8 = uint8(9)
	_ = _hi0
	for _0_i := uint8(0); _0_i < _hi0; _0_i++ {
		if ((_0_i) != (column) /* dircomp */) && ((_dafny.ArrayGet((board), int(row), int(_0_i)).(uint8)) == (digit)) {
			isValid = false
			return isValid
		}
		if ((_0_i) != (row) /* dircomp */) && ((_dafny.ArrayGet((board), int(_0_i), int(column)).(uint8)) == (digit)) {
			isValid = false
			return isValid
		}
	}
	var _1_box__row uint8
	_ = _1_box__row
	_1_box__row = ((row) / (uint8(3))) * (uint8(3))
	var _2_box__col uint8
	_ = _2_box__col
	_2_box__col = ((column) / (uint8(3))) * (uint8(3))
	var _hi1 uint8 = (_1_box__row) + (uint8(3))
	_ = _hi1
	for _3_r := _1_box__row; _3_r < _hi1; _3_r++ {
		var _hi2 uint8 = (_2_box__col) + (uint8(3))
		_ = _hi2
		for _4_c := _2_box__col; _4_c < _hi2; _4_c++ {
			if (((_3_r) != (row) /* dircomp */) || ((_4_c) != (column) /* dircomp */)) && ((_dafny.ArrayGet((board), int(_3_r), int(_4_c)).(uint8)) == (digit)) {
				isValid = false
				return isValid
			}
		}
	}
	isValid = true
	return isValid
	return isValid
}
func (_static *CompanionStruct_Default___) IsValidDigit(board _dafny.Array, row uint8, column uint8, digit uint8) bool {
	return ((Companion_Default___.IsValidInRow(board, row, column, digit)) && (Companion_Default___.IsValidInColumn(board, row, column, digit))) && (Companion_Default___.IsValidIn3x3(board, row, column, digit))
}
func (_static *CompanionStruct_Default___) IsValidInRow(board _dafny.Array, row uint8, column uint8, digit uint8) bool {
	return ((digit) == (uint8(0))) || (_dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_0 uint8) bool {
		var _0_c uint8
		_0_c = interface{}(_forall_var_0).(uint8)
		if true {
			return !(((uint8(0)) <= (_0_c)) && ((_0_c) < (uint8(9)))) || (((_0_c) == (column)) || ((_dafny.ArrayGet((board), int(row), int(_0_c)).(uint8)) != (digit) /* dircomp */))
		} else {
			return true
		}
	}))
}
func (_static *CompanionStruct_Default___) IsValidInColumn(board _dafny.Array, row uint8, column uint8, digit uint8) bool {
	return ((digit) == (uint8(0))) || (_dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_0 uint8) bool {
		var _0_r uint8
		_0_r = interface{}(_forall_var_0).(uint8)
		if true {
			return !(((uint8(0)) <= (_0_r)) && ((_0_r) < (uint8(9)))) || (((_0_r) == (row)) || ((_dafny.ArrayGet((board), int(_0_r), int(column)).(uint8)) != (digit) /* dircomp */))
		} else {
			return true
		}
	}))
}
func (_static *CompanionStruct_Default___) IsValidIn3x3(board _dafny.Array, row uint8, column uint8, digit uint8) bool {
	var _0_box__row uint8 = ((row) / (uint8(3))) * (uint8(3))
	_ = _0_box__row
	var _1_box__col uint8 = ((column) / (uint8(3))) * (uint8(3))
	_ = _1_box__col
	return ((digit) == (uint8(0))) || (_dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(256)), true, func(_forall_var_0 uint8) bool {
		var _2_r uint8
		_2_r = interface{}(_forall_var_0).(uint8)
		if true {
			return _dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(256)), true, func(_forall_var_1 uint8) bool {
				var _3_c uint8
				_3_c = interface{}(_forall_var_1).(uint8)
				if true {
					return !((((_0_box__row) <= (_2_r)) && ((_2_r) < ((_0_box__row) + (uint8(3))))) && (((_1_box__col) <= (_3_c)) && ((_3_c) < ((_1_box__col) + (uint8(3)))))) || ((((_2_r) == (row)) && ((_3_c) == (column))) || ((_dafny.ArrayGet((board), int(_2_r), int(_3_c)).(uint8)) != (digit) /* dircomp */))
				} else {
					return true
				}
			})
		} else {
			return true
		}
	}))
}
func (_static *CompanionStruct_Default___) IsValidBoardMethod(board _dafny.Array) bool {
	var isValid bool = false
	_ = isValid
	var _hi0 uint8 = uint8(9)
	_ = _hi0
	for _0_r := uint8(0); _0_r < _hi0; _0_r++ {
		var _hi1 uint8 = uint8(9)
		_ = _hi1
		for _1_c := uint8(0); _1_c < _hi1; _1_c++ {
			var _2_isValidDigit bool
			_ = _2_isValidDigit
			var _out0 bool
			_ = _out0
			_out0 = Companion_Default___.IsValidDigitMethod(board, _0_r, _1_c, _dafny.ArrayGet((board), int(_0_r), int(_1_c)).(uint8))
			_2_isValidDigit = _out0
			if !(_2_isValidDigit) {
				isValid = false
				return isValid
			}
		}
	}
	isValid = true
	return isValid
	return isValid
}
func (_static *CompanionStruct_Default___) IsValidBoard(board _dafny.Array) bool {
	return _dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_0 uint8) bool {
		var _0_r uint8
		_0_r = interface{}(_forall_var_0).(uint8)
		if true {
			return _dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_1 uint8) bool {
				var _1_c uint8
				_1_c = interface{}(_forall_var_1).(uint8)
				if true {
					return !((((uint8(0)) <= (_0_r)) && ((_0_r) < (uint8(9)))) && (((uint8(0)) <= (_1_c)) && ((_1_c) < (uint8(9))))) || (Companion_Default___.IsValidDigit(board, _0_r, _1_c, _dafny.ArrayGet((board), int(_0_r), int(_1_c)).(uint8)))
				} else {
					return true
				}
			})
		} else {
			return true
		}
	})
}
func (_static *CompanionStruct_Default___) IsFullBoard(board _dafny.Array) bool {
	return _dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_0 uint8) bool {
		var _0_r uint8
		_0_r = interface{}(_forall_var_0).(uint8)
		if true {
			return _dafny.Quantifier(m_Datatypes.Companion_Uint8_.IntegerRange(_dafny.Zero, _dafny.IntOfInt64(9)), true, func(_forall_var_1 uint8) bool {
				var _1_c uint8
				_1_c = interface{}(_forall_var_1).(uint8)
				if true {
					return !((((uint8(0)) <= (_0_r)) && ((_0_r) < (uint8(9)))) && (((uint8(0)) <= (_1_c)) && ((_1_c) < (uint8(9))))) || (((uint8(1)) <= (_dafny.ArrayGet((board), int(_0_r), int(_1_c)).(uint8))) && ((_dafny.ArrayGet((board), int(_0_r), int(_1_c)).(uint8)) <= (uint8(9))))
				} else {
					return true
				}
			})
		} else {
			return true
		}
	})
}

// End of class Default__
