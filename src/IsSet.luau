--!optimize 2
--!strict

local GreenTea = require(script.Parent.Parent.GreenTea)

--[=[
	A type that represents a set. Technically, `boolean` is only going to be
	`true`.

	@type Set<K> {[K]: boolean}
	@within GreenTeaUtilities
]=]
export type Set<K> = {[K]: boolean}

--[=[
	Creates a GreenTea type that represents a set.

	@function IsSet
	@within GreenTeaUtilities

	@param keyType K -- The type of the keys in the set.
	@param literalSet? boolean -- Whether the set is literally equal to a set. If it is `true`, the values of the set are expected to be `true`.
	@return Set<K>
]=]
local function IsSet<K>(keyType: K, literalSet: boolean?): Set<K>
	return GreenTea.table({
		[GreenTea.typeof(keyType)] = if literalSet then GreenTea.literal(true) else GreenTea.boolean();
	}, {})
end

return IsSet
