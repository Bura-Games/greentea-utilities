--!optimize 2
--!strict

local GreenTea = require(script.Parent.Parent.GreenTea)

export type Map<K, V> = {[K]: V}

--[=[
	Creates a GreenTea type that represents a map.

	@since v1.1.0
	@function IsMap
	@within GreenTeaUtilities

	@param keyType K -- The type of the keys in the map.
	@param valueType V -- The type of the values in the map.
	@return {[K]: V}
]=]
local function IsMap<K, V>(keyType: K, valueType: V): Map<K, V>
	return GreenTea.table({
		[GreenTea.typeof(keyType)] = GreenTea.typeof(valueType);
	}, {})
end

return IsMap
