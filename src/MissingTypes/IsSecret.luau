--!optimize 2
--!strict

local Debug = require(script.Parent.Parent.Parent.Debug)
local GreenTea = require(script.Parent.Parent.Parent.GreenTea)

--[=[
	A GreenTea type to match against a Secret type. This was missing from the
	GreenTea library.

	@since v1.6.0
	@readonly
	@prop IsSecret Secret
	@within GreenTeaUtilities
]=]
local IsSecret = GreenTea.custom(function(secret)
	if typeof(secret) ~= "Secret" then
		return false, `expected Secret, got {Debug.Inspect(secret)}`
	end

	return true
end, "Secret") :: Secret

return IsSecret
