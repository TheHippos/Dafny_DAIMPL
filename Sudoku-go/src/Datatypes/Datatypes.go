// Package Datatypes
// Dafny module Datatypes compiled into Go

package Datatypes

import (
	m__System "System_"
	_dafny "dafny"
	os "os"
)

var _ = os.Args
var _ _dafny.Dummy__
var _ m__System.Dummy__

type Dummy__ struct{}

// Definition of class Uint32
type Uint32 struct {
}

func New_Uint32_() *Uint32 {
	_this := Uint32{}

	return &_this
}

type CompanionStruct_Uint32_ struct {
}

var Companion_Uint32_ = CompanionStruct_Uint32_{}

func (*Uint32) String() string {
	return "Datatypes.Uint32"
}
func (_this *Uint32) ParentTraits_() []*_dafny.TraitID {
	return [](*_dafny.TraitID){}
}

var _ _dafny.TraitOffspring = &Uint32{}

func (_this *CompanionStruct_Uint32_) IntegerRange(lo _dafny.Int, hi _dafny.Int) _dafny.Iterator {
	iter := _dafny.IntegerRange(lo, hi)
	return func() (interface{}, bool) {
		next, ok := iter()
		if !ok {
			return uint32(0), false
		}
		return next.(_dafny.Int).Uint32(), true
	}
}

// End of class Uint32

func Type_Uint32_() _dafny.TypeDescriptor {
	return type_Uint32_{}
}

type type_Uint32_ struct {
}

func (_this type_Uint32_) Default() interface{} {
	return uint32(0)
}

func (_this type_Uint32_) String() string {
	return "Datatypes.Uint32"
}
func (_this *CompanionStruct_Uint32_) Is_(__source uint32) bool {
	return true
}

// Definition of class Uint8
type Uint8 struct {
}

func New_Uint8_() *Uint8 {
	_this := Uint8{}

	return &_this
}

type CompanionStruct_Uint8_ struct {
}

var Companion_Uint8_ = CompanionStruct_Uint8_{}

func (*Uint8) String() string {
	return "Datatypes.Uint8"
}
func (_this *Uint8) ParentTraits_() []*_dafny.TraitID {
	return [](*_dafny.TraitID){}
}

var _ _dafny.TraitOffspring = &Uint8{}

func (_this *CompanionStruct_Uint8_) IntegerRange(lo _dafny.Int, hi _dafny.Int) _dafny.Iterator {
	iter := _dafny.IntegerRange(lo, hi)
	return func() (interface{}, bool) {
		next, ok := iter()
		if !ok {
			return uint8(0), false
		}
		return next.(_dafny.Int).Uint8(), true
	}
}

// End of class Uint8

func Type_Uint8_() _dafny.TypeDescriptor {
	return type_Uint8_{}
}

type type_Uint8_ struct {
}

func (_this type_Uint8_) Default() interface{} {
	return uint8(0)
}

func (_this type_Uint8_) String() string {
	return "Datatypes.Uint8"
}
func (_this *CompanionStruct_Uint8_) Is_(__source uint8) bool {
	return true
}

// Definition of class SValue
type SValue struct {
}

func New_SValue_() *SValue {
	_this := SValue{}

	return &_this
}

type CompanionStruct_SValue_ struct {
}

var Companion_SValue_ = CompanionStruct_SValue_{}

func (*SValue) String() string {
	return "Datatypes.SValue"
}
func (_this *SValue) ParentTraits_() []*_dafny.TraitID {
	return [](*_dafny.TraitID){}
}

var _ _dafny.TraitOffspring = &SValue{}

func (_this *CompanionStruct_SValue_) IntegerRange(lo _dafny.Int, hi _dafny.Int) _dafny.Iterator {
	iter := _dafny.IntegerRange(lo, hi)
	return func() (interface{}, bool) {
		next, ok := iter()
		if !ok {
			return uint8(0), false
		}
		return next.(_dafny.Int).Uint8(), true
	}
}

// End of class SValue

func Type_SValue_() _dafny.TypeDescriptor {
	return type_SValue_{}
}

type type_SValue_ struct {
}

func (_this type_SValue_) Default() interface{} {
	return uint8(0)
}

func (_this type_SValue_) String() string {
	return "Datatypes.SValue"
}
func (_this *CompanionStruct_SValue_) Is_(__source uint8) bool {
	var _0_x _dafny.Int = _dafny.IntOfUint8(__source)
	_ = _0_x
	return ((_0_x).Sign() != -1) && ((_0_x).Cmp(_dafny.IntOfInt64(9)) <= 0)
}

// Definition of datatype Option
type Option struct {
	Data_Option_
}

func (_this Option) Get_() Data_Option_ {
	return _this.Data_Option_
}

type Data_Option_ interface {
	isOption()
}

type CompanionStruct_Option_ struct {
}

var Companion_Option_ = CompanionStruct_Option_{}

type Option_None struct {
}

func (Option_None) isOption() {}

func (CompanionStruct_Option_) Create_None_() Option {
	return Option{Option_None{}}
}

func (_this Option) Is_None() bool {
	_, ok := _this.Get_().(Option_None)
	return ok
}

type Option_Some struct {
	Value interface{}
}

func (Option_Some) isOption() {}

func (CompanionStruct_Option_) Create_Some_(Value interface{}) Option {
	return Option{Option_Some{Value}}
}

func (_this Option) Is_Some() bool {
	_, ok := _this.Get_().(Option_Some)
	return ok
}

func (CompanionStruct_Option_) Default() Option {
	return Companion_Option_.Create_None_()
}

func (_this Option) Dtor_value() interface{} {
	return _this.Get_().(Option_Some).Value
}

func (_this Option) String() string {
	switch data := _this.Get_().(type) {
	case nil:
		return "null"
	case Option_None:
		{
			return "Datatypes.Option.None"
		}
	case Option_Some:
		{
			return "Datatypes.Option.Some" + "(" + _dafny.String(data.Value) + ")"
		}
	default:
		{
			return "<unexpected>"
		}
	}
}

func (_this Option) Equals(other Option) bool {
	switch data1 := _this.Get_().(type) {
	case Option_None:
		{
			_, ok := other.Get_().(Option_None)
			return ok
		}
	case Option_Some:
		{
			data2, ok := other.Get_().(Option_Some)
			return ok && _dafny.AreEqual(data1.Value, data2.Value)
		}
	default:
		{
			return false // unexpected
		}
	}
}

func (_this Option) EqualsGeneric(other interface{}) bool {
	typed, ok := other.(Option)
	return ok && _this.Equals(typed)
}

func Type_Option_() _dafny.TypeDescriptor {
	return type_Option_{}
}

type type_Option_ struct {
}

func (_this type_Option_) Default() interface{} {
	return Companion_Option_.Default()
}

func (_this type_Option_) String() string {
	return "Datatypes.Option"
}
func (_this Option) ParentTraits_() []*_dafny.TraitID {
	return [](*_dafny.TraitID){}
}

var _ _dafny.TraitOffspring = Option{}

// End of datatype Option
