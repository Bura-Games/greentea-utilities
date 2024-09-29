--!optimize 2
--!strict

local Debug = require(script.Parent.Parent.Debug)
local GreenTea = require(script.Parent.Parent.GreenTea)

--[=[
	A GreenTea type to match against a DateTime type. This was missing from the
	GreenTea library.

	@readonly
	@prop IsDateTime DateTime
	@within GreenTeaUtilities
]=]
local IsDateTime = GreenTea.withCustom(DateTime.now(), function(dateTime)
	if typeof(dateTime) ~= "DateTime" then
		return false, `expected DateTime, got {Debug.Inspect(dateTime)}`
	end

	return true
end, "DateTime")

return IsDateTime
