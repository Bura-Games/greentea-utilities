--!optimize 2
--!strict

local GreenTea = require(script.Parent.Parent.GreenTea)

--[=[
	A GreenTea type to match against a DateTime type. This was missing from the
	GreenTea library.

	@readonly
	@prop IsDateTime DateTime
	@within GreenTeaUtilities
]=]
local IsDateTime = GreenTea.withCustom(DateTime.now(), function(value)
	if typeof(value) ~= "DateTime" then
		return false, `expected DateTime, got {typeof(value)}`
	end

	return true
end, "DateTime")

return IsDateTime
