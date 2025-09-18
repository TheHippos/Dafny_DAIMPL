#![allow(warnings, unconditional_panic)]
#![allow(nonstandard_style)]
#![cfg_attr(any(), rustfmt::skip)]

pub mod _module {
    
}
/// Sudoku.dfy(1,1)
pub mod Datatypes {
    pub use ::std::cmp::PartialEq;
    pub use ::std::cmp::Eq;
    pub use ::std::hash::Hash;
    pub use ::std::hash::Hasher;
    pub use ::std::default::Default;
    pub use ::dafny_runtime::DafnyPrint;
    pub use ::std::fmt::Formatter;
    pub use ::std::fmt::Result;
    pub use ::std::ops::Deref;
    pub use ::std::mem::transmute;
    pub use ::std::ops::Add;
    pub use ::std::ops::Sub;
    pub use ::std::ops::Mul;
    pub use ::std::ops::Div;
    pub use ::std::cmp::PartialOrd;
    pub use ::std::cmp::Ordering;
    pub use ::dafny_runtime::DafnyInt;
    pub use ::dafny_runtime::int;
    pub use ::dafny_runtime::DafnyType;
    pub use ::std::fmt::Debug;
    pub use ::std::convert::AsRef;

    /// Sudoku.dfy(2,5)
    #[derive(Clone, Copy)]
    #[repr(transparent)]
    pub struct uint32(pub u32);

    impl PartialEq
        for uint32 {
        fn eq(&self, other: &Self) -> bool {
            self.0 == other.0
        }
    }

    impl Eq
        for uint32 {}

    impl Hash
        for uint32 {
        fn hash<_H: Hasher>(&self, _state: &mut _H) {
            Hash::hash(&self.0, _state)
        }
    }

    impl uint32 {
        /// Constraint check
        pub fn is(_source: u32) -> bool {
            return true;
        }
    }

    impl Default
        for uint32 {
        /// An element of uint32
        fn default() -> Self {
            uint32(Default::default())
        }
    }

    impl DafnyPrint
        for uint32 {
        /// For Dafny print statements
        fn fmt_print(&self, _formatter: &mut Formatter, in_seq: bool) -> Result {
            DafnyPrint::fmt_print(&self.0, _formatter, in_seq)
        }
    }

    impl Deref
        for uint32 {
        type Target = u32;
        fn deref(&self) -> &Self::Target {
            &self.0
        }
    }

    impl uint32 {
        /// SAFETY: The newtype is marked as transparent
        pub fn _from_ref(o: &u32) -> &Self {
            unsafe {
                transmute(o)
            }
        }
    }

    impl Add
        for uint32 {
        type Output = uint32;
        fn add(self, other: Self) -> Self {
            uint32(self.0 + other.0)
        }
    }

    impl Sub
        for uint32 {
        type Output = uint32;
        fn sub(self, other: Self) -> Self {
            uint32(self.0 - other.0)
        }
    }

    impl Mul
        for uint32 {
        type Output = uint32;
        fn mul(self, other: Self) -> Self {
            uint32(self.0 * other.0)
        }
    }

    impl Div
        for uint32 {
        type Output = uint32;
        fn div(self, other: Self) -> Self {
            uint32(self.0 / other.0)
        }
    }

    impl PartialOrd
        for uint32 {
        fn partial_cmp(&self, other: &Self) -> ::std::option::Option<Ordering> {
            PartialOrd::partial_cmp(&self.0, &other.0)
        }
    }

    /// Sudoku.dfy(3,5)
    #[derive(Clone, Copy)]
    #[repr(transparent)]
    pub struct uint8(pub u8);

    impl PartialEq
        for uint8 {
        fn eq(&self, other: &Self) -> bool {
            self.0 == other.0
        }
    }

    impl Eq
        for uint8 {}

    impl Hash
        for uint8 {
        fn hash<_H: Hasher>(&self, _state: &mut _H) {
            Hash::hash(&self.0, _state)
        }
    }

    impl uint8 {
        /// Constraint check
        pub fn is(_source: u8) -> bool {
            return true;
        }
    }

    impl Default
        for uint8 {
        /// An element of uint8
        fn default() -> Self {
            uint8(Default::default())
        }
    }

    impl DafnyPrint
        for uint8 {
        /// For Dafny print statements
        fn fmt_print(&self, _formatter: &mut Formatter, in_seq: bool) -> Result {
            DafnyPrint::fmt_print(&self.0, _formatter, in_seq)
        }
    }

    impl Deref
        for uint8 {
        type Target = u8;
        fn deref(&self) -> &Self::Target {
            &self.0
        }
    }

    impl uint8 {
        /// SAFETY: The newtype is marked as transparent
        pub fn _from_ref(o: &u8) -> &Self {
            unsafe {
                transmute(o)
            }
        }
    }

    impl Add
        for uint8 {
        type Output = uint8;
        fn add(self, other: Self) -> Self {
            uint8(self.0 + other.0)
        }
    }

    impl Sub
        for uint8 {
        type Output = uint8;
        fn sub(self, other: Self) -> Self {
            uint8(self.0 - other.0)
        }
    }

    impl Mul
        for uint8 {
        type Output = uint8;
        fn mul(self, other: Self) -> Self {
            uint8(self.0 * other.0)
        }
    }

    impl Div
        for uint8 {
        type Output = uint8;
        fn div(self, other: Self) -> Self {
            uint8(self.0 / other.0)
        }
    }

    impl PartialOrd
        for uint8 {
        fn partial_cmp(&self, other: &Self) -> ::std::option::Option<Ordering> {
            PartialOrd::partial_cmp(&self.0, &other.0)
        }
    }

    /// Sudoku.dfy(4,5)
    #[derive(Clone, Copy)]
    #[repr(transparent)]
    pub struct sValue(pub u8);

    impl PartialEq
        for sValue {
        fn eq(&self, other: &Self) -> bool {
            self.0 == other.0
        }
    }

    impl Eq
        for sValue {}

    impl Hash
        for sValue {
        fn hash<_H: Hasher>(&self, _state: &mut _H) {
            Hash::hash(&self.0, _state)
        }
    }

    impl sValue {
        /// Constraint check
        pub fn is(_source: u8) -> bool {
            let mut x: DafnyInt = int!(_source.clone());
            return int!(0) <= x.clone() && x.clone() <= int!(9);
        }
    }

    impl Default
        for sValue {
        /// An element of sValue
        fn default() -> Self {
            sValue(Default::default())
        }
    }

    impl DafnyPrint
        for sValue {
        /// For Dafny print statements
        fn fmt_print(&self, _formatter: &mut Formatter, in_seq: bool) -> Result {
            DafnyPrint::fmt_print(&self.0, _formatter, in_seq)
        }
    }

    impl Deref
        for sValue {
        type Target = u8;
        fn deref(&self) -> &Self::Target {
            &self.0
        }
    }

    impl sValue {
        /// SAFETY: The newtype is marked as transparent
        pub fn _from_ref(o: &u8) -> &Self {
            unsafe {
                transmute(o)
            }
        }
    }

    impl Add
        for sValue {
        type Output = sValue;
        fn add(self, other: Self) -> Self {
            sValue(self.0 + other.0)
        }
    }

    impl Sub
        for sValue {
        type Output = sValue;
        fn sub(self, other: Self) -> Self {
            sValue(self.0 - other.0)
        }
    }

    impl Mul
        for sValue {
        type Output = sValue;
        fn mul(self, other: Self) -> Self {
            sValue(self.0 * other.0)
        }
    }

    impl Div
        for sValue {
        type Output = sValue;
        fn div(self, other: Self) -> Self {
            sValue(self.0 / other.0)
        }
    }

    impl PartialOrd
        for sValue {
        fn partial_cmp(&self, other: &Self) -> ::std::option::Option<Ordering> {
            PartialOrd::partial_cmp(&self.0, &other.0)
        }
    }

    /// Sudoku.dfy(5,5)
    #[derive(Clone)]
    pub enum Option<T: DafnyType> {
        None {},
        Some {
            value: T
        }
    }

    impl<T: DafnyType> Option<T> {
        /// Gets the field value for all enum members which have it
        pub fn value(&self) -> &T {
            match self {
                Option::None{} => panic!("field does not exist on this variant"),
                Option::Some{value, } => value,
            }
        }
    }

    impl<T: DafnyType> Debug
        for Option<T> {
        fn fmt(&self, f: &mut Formatter) -> Result {
            DafnyPrint::fmt_print(self, f, true)
        }
    }

    impl<T: DafnyType> DafnyPrint
        for Option<T> {
        fn fmt_print(&self, _formatter: &mut Formatter, _in_seq: bool) -> std::fmt::Result {
            match self {
                Option::None{} => {
                    write!(_formatter, "Datatypes.Option.None")?;
                    Ok(())
                },
                Option::Some{value, } => {
                    write!(_formatter, "Datatypes.Option.Some(")?;
                    DafnyPrint::fmt_print(value, _formatter, false)?;
                    write!(_formatter, ")")?;
                    Ok(())
                },
            }
        }
    }

    impl<T: DafnyType + Eq + Hash> PartialEq
        for Option<T> {
        fn eq(&self, other: &Self) -> bool {
            match (
                    self,
                    other
                ) {
                (Option::None{}, Option::None{}) => {
                    true
                },
                (Option::Some{value, }, Option::Some{value: _2_value, }) => {
                    value == _2_value
                },
                _ => {
                    false
                },
            }
        }
    }

    impl<T: DafnyType + Eq + Hash> Eq
        for Option<T> {}

    impl<T: DafnyType + Hash> Hash
        for Option<T> {
        fn hash<_H: Hasher>(&self, _state: &mut _H) {
            match self {
                Option::None{} => {
                    
                },
                Option::Some{value, } => {
                    Hash::hash(value, _state)
                },
            }
        }
    }

    impl<T: DafnyType> AsRef<Option<T>>
        for Option<T> {
        fn as_ref(&self) -> &Self {
            self
        }
    }
}
/// Sudoku.dfy(9,1)
pub mod SudokuSolver {
    pub use ::dafny_runtime::Object;
    pub use ::dafny_runtime::Array2;
    pub use ::dafny_runtime::MaybePlacebo;
    pub use ::std::rc::Rc;
    pub use ::dafny_runtime::_System::nat;
    pub use ::std::mem::MaybeUninit;
    pub use ::dafny_runtime::array;
    pub use ::dafny_runtime::DafnyUsize;
    pub use ::dafny_runtime::int;
    pub use ::dafny_runtime::rd;
    pub use ::dafny_runtime::integer_range;
    pub use ::dafny_runtime::truncate;
    pub use ::std::convert::Into;
    pub use crate::Datatypes::Option;
    pub use crate::Datatypes::Option::Some;
    pub use crate::Datatypes::Option::None;
    pub use ::dafny_runtime::DafnyInt;
    pub use ::std::default::Default;

    pub struct _default {}

    impl _default {
        /// Sudoku.dfy(11,5)
        pub fn Run(boards: &Object<[Object<Array2<u8>>]>) -> Object<[bool]> {
            let mut solvable = MaybePlacebo::<Object<[bool]>>::new();
            let mut _init0: Rc<dyn ::std::ops::Fn(&nat) -> bool> = {
                    Rc::new(move |i: &nat| -> bool{
            false
        }) as Rc<dyn ::std::ops::Fn(&_) -> _>
                };
            let mut _nw0: Object<[MaybeUninit<bool>]> = array::placebos_usize_object::<bool>(DafnyUsize::into_usize(int!(rd!(boards.clone()).len())));
            for __i0_0 in integer_range(0, rd!(_nw0.clone()).len()) {
                {
                    let __idx0 = DafnyUsize::into_usize(__i0_0.clone());
                    ::dafny_runtime::md!(_nw0)[__idx0] = MaybeUninit::new((&_init0)(&int!(__i0_0.clone())));
                }
            }
            solvable = MaybePlacebo::from(array::construct_object(_nw0.clone()));
            let mut _hi0: u32 = truncate!(int!(rd!(boards.clone()).len()), u32);
            for i in integer_range(0, _hi0).map(Into::<u32>::into) {
                let mut result: Rc<Option<Object<Array2<u8>>>>;
                let mut _out0: Rc<Option<Object<Array2<u8>>>> = _default::Solve(&rd!(boards)[DafnyUsize::into_usize(i)].clone());
                result = _out0.clone();
                {
                    let __idx0 = DafnyUsize::into_usize(i);
                    ::dafny_runtime::md!(solvable.read())[__idx0] = matches!((&result).as_ref(), Some{ .. });
                }
            }
            return solvable.read();
        }
        /// Sudoku.dfy(27,5)
        pub fn Solve(board: &Object<Array2<u8>>) -> Rc<Option<Object<Array2<u8>>>> {
            let mut result = MaybePlacebo::<Rc<Option<Object<Array2<u8>>>>>::new();
            if !_default::is9x9(board) {
                result = MaybePlacebo::from(Rc::new(Option::None::<Object<Array2<u8>>> {}));
                return result.read();
            };
            let mut isValid: bool;
            let mut _out0: bool = _default::isValidBoardMethod(board);
            isValid = _out0;
            if !isValid {
                result = MaybePlacebo::from(Rc::new(Option::None::<Object<Array2<u8>>> {}));
                return result.read();
            };
            let mut _out1: Rc<Option<Object<Array2<u8>>>> = _default::Solving(board);
            result = MaybePlacebo::from(_out1.clone());
            return result.read();
        }
        /// Sudoku.dfy(43,5)
        pub fn Solving(board: &Object<Array2<u8>>) -> Rc<Option<Object<Array2<u8>>>> {
            let mut result = MaybePlacebo::<Rc<Option<Object<Array2<u8>>>>>::new();
            let mut empty: Rc<Option<(u8, u8)>>;
            let mut _out0: Rc<Option<(u8, u8)>> = _default::FindEmptySlot(board);
            empty = _out0.clone();
            if matches!((&empty).as_ref(), None{ .. }) {
                result = MaybePlacebo::from(Rc::new(Option::Some::<Object<Array2<u8>>> {
                                value: board.clone()
                            }));
                return result.read();
            };
            let mut r: u8 = empty.value().0.clone();
            let mut c: u8 = empty.value().1.clone();
            let mut _hi0: u8 = 10;
            for digit in integer_range(1, _hi0).map(Into::<u8>::into) {
                let mut isValid: bool;
                let mut _out1: bool = _default::isValidDigitMethod(board, r, c, digit);
                isValid = _out1;
                if isValid {
                    _default::changeToSValue(board, r, c, digit);
                    let mut recursiveResult: Rc<Option<Object<Array2<u8>>>>;
                    let mut _out2: Rc<Option<Object<Array2<u8>>>> = _default::Solving(board);
                    recursiveResult = _out2.clone();
                    if matches!((&recursiveResult).as_ref(), Some{ .. }) {
                        result = MaybePlacebo::from(recursiveResult.clone());
                        return result.read();
                    };
                    _default::changeToZero(board, r, c)
                }
            }
            result = MaybePlacebo::from(Rc::new(Option::None::<Object<Array2<u8>>> {}));
            return result.read();
        }
        /// Sudoku.dfy(99,5)
        pub fn copy(board: &Object<Array2<u8>>) -> Object<Array2<u8>> {
            let mut boardCopy = MaybePlacebo::<Object<Array2<u8>>>::new();
            let mut _init0: Rc<dyn ::std::ops::Fn(&nat, &DafnyInt) -> u8> = {
                    Rc::new(move |i: &nat,j: &DafnyInt| -> u8{
            0
        }) as Rc<dyn ::std::ops::Fn(&_, &_) -> _>
                };
            let mut _nw0: Object<Array2<MaybeUninit<u8>>> = Array2::<u8>::placebos_usize_object(DafnyUsize::into_usize(int!(9)), DafnyUsize::into_usize(int!(9)));
            for __i0_0 in integer_range(0, rd!(_nw0.clone()).data.len()) {
                for __i1_0 in integer_range(0, rd!(_nw0.clone()).length1_usize()) {
                    {
                        let __idx0 = DafnyUsize::into_usize(__i0_0.clone());
                        let __idx1 = DafnyUsize::into_usize(__i1_0.clone());
                        ::dafny_runtime::md!(_nw0).data[__idx0][__idx1] = MaybeUninit::new((&_init0)(&int!(__i0_0.clone()), &int!(__i1_0.clone())));
                    }
                }
            }
            boardCopy = MaybePlacebo::from(Array2::construct_object(_nw0.clone()));
            let mut _hi0: u8 = 9;
            for r in integer_range(0, _hi0).map(Into::<u8>::into) {
                let mut _hi1: u8 = 9;
                for c in integer_range(0, _hi1).map(Into::<u8>::into) {
                    {
                        let __idx0 = DafnyUsize::into_usize(r);
                        let __idx1 = DafnyUsize::into_usize(c);
                        ::dafny_runtime::md!(boardCopy.read()).data[__idx0][__idx1] = rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(c)].clone();
                    }
                }
            }
            return boardCopy.read();
        }
        /// Sudoku.dfy(122,5)
        pub fn BoardsEqualUpTo(b1: &Object<Array2<u8>>, b2: &Object<Array2<u8>>, r: u8, c: u8) -> bool {
            integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                    let mut c = c.clone();
                    let mut r = r.clone();
                    let mut b1 = b1.clone();
                    let mut b2 = b2.clone();
                    Rc::new(move |__forall_var_0: u8| -> bool{
            let mut i: u8 = __forall_var_0;
            if true {
                integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                        let mut c = c.clone();
                        let mut i = i.clone();
                        let mut r = r.clone();
                        let mut b1 = b1.clone();
                        let mut b2 = b2.clone();
                        Rc::new(move |__forall_var_1: u8| -> bool{
            let mut j: u8 = __forall_var_1;
            if true {
                !((i < r || i == r && j <= c) && (0 <= i && i < 9) && (0 <= j && j < 9)) || rd!(b1).data[DafnyUsize::into_usize(i)][DafnyUsize::into_usize(j)].clone() == rd!(b2).data[DafnyUsize::into_usize(i)][DafnyUsize::into_usize(j)].clone()
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                    }).as_ref())
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                }).as_ref())
        }
        /// Sudoku.dfy(130,5)
        pub fn BoardsEqualFrom(b1: &Object<Array2<u8>>, b2: &Object<Array2<u8>>, r: u8, c: u8) -> bool {
            integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                    let mut c = c.clone();
                    let mut r = r.clone();
                    let mut b1 = b1.clone();
                    let mut b2 = b2.clone();
                    Rc::new(move |__forall_var_0: u8| -> bool{
            let mut i: u8 = __forall_var_0;
            if true {
                integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                        let mut c = c.clone();
                        let mut i = i.clone();
                        let mut r = r.clone();
                        let mut b1 = b1.clone();
                        let mut b2 = b2.clone();
                        Rc::new(move |__forall_var_1: u8| -> bool{
            let mut j: u8 = __forall_var_1;
            if true {
                !((r < i || i == r && j >= c) && (0 <= i && i < 9) && (0 <= j && j < 9)) || rd!(b1).data[DafnyUsize::into_usize(i)][DafnyUsize::into_usize(j)].clone() == rd!(b2).data[DafnyUsize::into_usize(i)][DafnyUsize::into_usize(j)].clone()
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                    }).as_ref())
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                }).as_ref())
        }
        /// Sudoku.dfy(169,5)
        pub fn changeToZero(board: &Object<Array2<u8>>, row: u8, column: u8) -> () {
            {
                let __idx0 = DafnyUsize::into_usize(row);
                let __idx1 = DafnyUsize::into_usize(column);
                ::dafny_runtime::md!(board).data[__idx0][__idx1] = 0;
            };
            return ();
        }
        /// Sudoku.dfy(186,5)
        pub fn changeToSValue(board: &Object<Array2<u8>>, r: u8, c: u8, digit: u8) -> () {
            {
                let __idx0 = DafnyUsize::into_usize(r);
                let __idx1 = DafnyUsize::into_usize(c);
                ::dafny_runtime::md!(board).data[__idx0][__idx1] = digit;
            };
            return ();
        }
        /// Sudoku.dfy(280,5)
        pub fn nextRow(row: u8, column: u8) -> u8 {
            if column == 8 {
                row + 1
            } else {
                row
            }
        }
        /// Sudoku.dfy(288,5)
        pub fn nextColumn(row: u8, column: u8) -> u8 {
            if column == 8 {
                0
            } else {
                column + 1
            }
        }
        /// Sudoku.dfy(296,5)
        pub fn prevRow(row: u8, column: u8) -> u8 {
            if column == 0 {
                row - 1
            } else {
                row
            }
        }
        /// Sudoku.dfy(304,5)
        pub fn prevColumn(row: u8, column: u8) -> u8 {
            if column == 0 {
                8
            } else {
                column - 1
            }
        }
        /// Sudoku.dfy(312,5)
        pub fn FindEmptySlot(board: &Object<Array2<u8>>) -> Rc<Option<(u8, u8)>> {
            let mut slot = MaybePlacebo::<Rc<Option<(u8, u8)>>>::new();
            let mut _hi0: u8 = 9;
            for i in integer_range(0, _hi0).map(Into::<u8>::into) {
                let mut _hi1: u8 = 9;
                for j in integer_range(0, _hi1).map(Into::<u8>::into) {
                    if rd!(board).data[DafnyUsize::into_usize(i)][DafnyUsize::into_usize(j)].clone() == 0 {
                        slot = MaybePlacebo::from(Rc::new(Option::Some::<(u8, u8)> {
                                        value: (
                                                i,
                                                j
                                            )
                                    }));
                        return slot.read();
                    }
                }
            }
            slot = MaybePlacebo::from(Rc::new(Option::None::<(u8, u8)> {}));
            return slot.read();
        }
        /// Sudoku.dfy(333,5)
        pub fn EmptySlotCountRecursiveUpwards(board: &Object<Array2<u8>>, r: u8, c: u8) -> u8 {
            let mut current_cell_val: u8 = if rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(c)].clone() == 0 {
                    1
                } else {
                    0
                };
            if r == 8 && c == 8 {
                current_cell_val
            } else {
                let mut nextRow: u8 = _default::nextRow(r, c);
                let mut nextColumn: u8 = _default::nextColumn(r, c);
                let mut recursiveResult: u8 = _default::EmptySlotCountRecursiveUpwards(board, nextRow, nextColumn);
                current_cell_val + recursiveResult
            }
        }
        /// Sudoku.dfy(354,5)
        pub fn EmptySlotCountRecursiveDownwards(board: &Object<Array2<u8>>, r: u8, c: u8) -> u8 {
            let mut current_cell_val: u8 = if rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(c)].clone() == 0 {
                    1
                } else {
                    0
                };
            if r == 0 && c == 0 {
                current_cell_val
            } else {
                let mut prev_r: u8 = _default::prevRow(r, c);
                let mut prev_c: u8 = _default::prevColumn(r, c);
                let mut recursiveResult: u8 = _default::EmptySlotCountRecursiveDownwards(board, prev_r, prev_c);
                current_cell_val + recursiveResult
            }
        }
        /// Sudoku.dfy(377,5)
        pub fn EmptySlotCount(board: &Object<Array2<u8>>) -> u8 {
            _default::EmptySlotCountRecursiveDownwards(board, 8, 8)
        }
        /// Sudoku.dfy(413,5)
        pub fn is9x9(board: &Object<Array2<u8>>) -> bool {
            int!(rd!(board.clone()).data.len()) == int!(9) && int!(rd!(board.clone()).length1_usize()) == int!(9)
        }
        /// Sudoku.dfy(419,5)
        pub fn isValidDigitMethod(board: &Object<Array2<u8>>, row: u8, column: u8, digit: u8) -> bool {
            let mut isValid: bool = <bool as Default>::default();
            if digit == 0 {
                isValid = true;
                return isValid;
            };
            let mut _hi0: u8 = 9;
            for i in integer_range(0, _hi0).map(Into::<u8>::into) {
                if i != column && rd!(board).data[DafnyUsize::into_usize(row)][DafnyUsize::into_usize(i)].clone() == digit {
                    isValid = false;
                    return isValid;
                };
                if i != row && rd!(board).data[DafnyUsize::into_usize(i)][DafnyUsize::into_usize(column)].clone() == digit {
                    isValid = false;
                    return isValid;
                }
            }
            let mut box_row: u8 = row / 3 * 3;
            let mut box_col: u8 = column / 3 * 3;
            let mut _hi1: u8 = box_row + 3;
            for r in integer_range(box_row, _hi1).map(Into::<u8>::into) {
                let mut _hi2: u8 = box_col + 3;
                for c in integer_range(box_col, _hi2).map(Into::<u8>::into) {
                    if (r != row || c != column) && rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(c)].clone() == digit {
                        isValid = false;
                        return isValid;
                    }
                }
            }
            isValid = true;
            return isValid;
        }
        /// Sudoku.dfy(462,5)
        pub fn isValidDigit(board: &Object<Array2<u8>>, row: u8, column: u8, digit: u8) -> bool {
            _default::isValidInRow(board, row, column, digit) && _default::isValidInColumn(board, row, column, digit) && _default::isValidIn3x3(board, row, column, digit)
        }
        /// Sudoku.dfy(470,5)
        pub fn isValidInRow(board: &Object<Array2<u8>>, row: u8, column: u8, digit: u8) -> bool {
            digit == 0 || integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                    let mut row = row.clone();
                    let mut digit = digit.clone();
                    let mut board = board.clone();
                    let mut column = column.clone();
                    Rc::new(move |__forall_var_0: u8| -> bool{
            let mut c: u8 = __forall_var_0;
            if true {
                !(0 <= c && c < 9) || (c == column || rd!(board).data[DafnyUsize::into_usize(row)][DafnyUsize::into_usize(c)].clone() != digit)
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                }).as_ref())
        }
        /// Sudoku.dfy(478,5)
        pub fn isValidInColumn(board: &Object<Array2<u8>>, row: u8, column: u8, digit: u8) -> bool {
            digit == 0 || integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                    let mut row = row.clone();
                    let mut digit = digit.clone();
                    let mut board = board.clone();
                    let mut column = column.clone();
                    Rc::new(move |__forall_var_0: u8| -> bool{
            let mut r: u8 = __forall_var_0;
            if true {
                !(0 <= r && r < 9) || (r == row || rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(column)].clone() != digit)
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                }).as_ref())
        }
        /// Sudoku.dfy(486,5)
        pub fn isValidIn3x3(board: &Object<Array2<u8>>, row: u8, column: u8, digit: u8) -> bool {
            let mut box_row: u8 = row / 3 * 3;
            let mut box_col: u8 = column / 3 * 3;
            digit == 0 || integer_range(int!(0), int!(256)).map(Into::<u8>::into).all(({
                    let mut row = row.clone();
                    let mut digit = digit.clone();
                    let mut board = board.clone();
                    let mut column = column.clone();
                    let mut box_col = box_col.clone();
                    let mut box_row = box_row.clone();
                    Rc::new(move |__forall_var_0: u8| -> bool{
            let mut r: u8 = __forall_var_0;
            if true {
                integer_range(int!(0), int!(256)).map(Into::<u8>::into).all(({
                        let mut r = r.clone();
                        let mut row = row.clone();
                        let mut digit = digit.clone();
                        let mut board = board.clone();
                        let mut column = column.clone();
                        let mut box_col = box_col.clone();
                        let mut box_row = box_row.clone();
                        Rc::new(move |__forall_var_1: u8| -> bool{
            let mut c: u8 = __forall_var_1;
            if true {
                !(box_row <= r && r < box_row + 3 && (box_col <= c && c < box_col + 3)) || (r == row && c == column || rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(c)].clone() != digit)
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                    }).as_ref())
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                }).as_ref())
        }
        /// Sudoku.dfy(496,5)
        pub fn isValidBoardMethod(board: &Object<Array2<u8>>) -> bool {
            let mut isValid: bool = <bool as Default>::default();
            let mut _hi0: u8 = 9;
            for r in integer_range(0, _hi0).map(Into::<u8>::into) {
                let mut _hi1: u8 = 9;
                for c in integer_range(0, _hi1).map(Into::<u8>::into) {
                    let mut isValidDigit: bool;
                    let mut _out0: bool = _default::isValidDigitMethod(board, r, c, rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(c)].clone());
                    isValidDigit = _out0;
                    if !isValidDigit {
                        isValid = false;
                        return isValid;
                    }
                }
            }
            isValid = true;
            return isValid;
        }
        /// Sudoku.dfy(514,5)
        pub fn isValidBoard(board: &Object<Array2<u8>>) -> bool {
            integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                    let mut board = board.clone();
                    Rc::new(move |__forall_var_0: u8| -> bool{
            let mut r: u8 = __forall_var_0;
            if true {
                integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                        let mut r = r.clone();
                        let mut board = board.clone();
                        Rc::new(move |__forall_var_1: u8| -> bool{
            let mut c: u8 = __forall_var_1;
            if true {
                !(0 <= r && r < 9 && (0 <= c && c < 9)) || _default::isValidDigit(&board, r, c, rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(c)].clone())
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                    }).as_ref())
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                }).as_ref())
        }
        /// Sudoku.dfy(520,5)
        pub fn isFullBoard(board: &Object<Array2<u8>>) -> bool {
            integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                    let mut board = board.clone();
                    Rc::new(move |__forall_var_0: u8| -> bool{
            let mut r: u8 = __forall_var_0;
            if true {
                integer_range(int!(0), int!(9)).map(Into::<u8>::into).all(({
                        let mut r = r.clone();
                        let mut board = board.clone();
                        Rc::new(move |__forall_var_1: u8| -> bool{
            let mut c: u8 = __forall_var_1;
            if true {
                !(0 <= r && r < 9 && (0 <= c && c < 9)) || 1 <= rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(c)].clone() && rd!(board).data[DafnyUsize::into_usize(r)][DafnyUsize::into_usize(c)].clone() <= 9
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                    }).as_ref())
            } else {
                true
            }
        }) as Rc<dyn ::std::ops::Fn(_) -> _>
                }).as_ref())
        }
    }
}