--!optimize 2
--!strict

local GreenTea = require(script.Parent.Parent.GreenTea)

--[=[
	A utility function that makes making literal unions easier.

	```lua
	local IsMethod = EasyLiteral("Method", "Function")
	```

	@since 1.4.0
	@function EasyLiteral
	@within GreenTeaUtilities

	@param ...T -- The types to union.
	@return T -- This is actually a build-able GreenTea type.
]=]
local function EasyLiteral<T>(...: any)
	local count = select("#", ...)
	local array = table.create(count)

	for index = 1, count do
		local value = select(index, ...)
		array[index] = GreenTea.literal(value)
	end

	return GreenTea.union(table.unpack(array)) :: T
end

return EasyLiteral
