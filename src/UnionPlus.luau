--!optimize 2
--!strict

local GreenTea = require(script.Parent.Parent.GreenTea)

type UnionType =
	(<T1, T2>(T1, T2) -> T1 | T2)
	& (<T1, T2, T3>(T1, T2, T3) -> T1 | T2 | T3)
	& (<T1, T2, T3, T4>(T1, T2, T3, T4) -> T1 | T2 | T3 | T4)
	& (<T1, T2, T3, T4, T5>(T1, T2, T3, T4, T5) -> T1 | T2 | T3 | T4 | T5)
	& (<T1, T2, T3, T4, T5, T6>(T1, T2, T3, T4, T5, T6) -> T1 | T2 | T3 | T4 | T5 | T6)
	& (<T1, T2, T3, T4, T5, T6, T7>(T1, T2, T3, T4, T5, T6, T7) -> T1 | T2 | T3 | T4 | T5 | T6 | T7)
	& (<T1, T2, T3, T4, T5, T6, T7, T8>(T1, T2, T3, T4, T5, T6, T7, T8) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9,
		T10
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10)
	& (<T>(...T) -> T)

--[=[
	An expanded version of `GreenTea.union`. It just expands the type
	definition to include more possible types (10).

	@function UnionPlus
	@within GreenTeaUtilities

	@param ... ...T -- The unioned types.
	@return T -- This is actually a build-able GreenTea type.
]=]
local UnionPlus = GreenTea.union :: UnionType
return UnionPlus
