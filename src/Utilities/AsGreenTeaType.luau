--!optimize 2
--!strict

local GreenTea = require(script.Parent.Parent.Parent.GreenTea)

local IsNoneRaw = GreenTea.none()

local function AsGreenTeaType(value: any)
	if GreenTea.isGreenTeaType(value) then
		return value
	end

	if value == nil then
		return IsNoneRaw
	end

	if type(value) == "function" then
		return GreenTea.custom(value)
	end

	return GreenTea.typeof(value)
end

return AsGreenTeaType
