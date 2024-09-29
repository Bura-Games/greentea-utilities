--!optimize 2
--!strict

local Debug = require(script.Parent.Parent.Debug)
local GreenTea = require(script.Parent.Parent.GreenTea)

local IsEnumItem = GreenTea.build(GreenTea.EnumItem())
local IsString = GreenTea.build(GreenTea.string())

--[=[
	A custom GreenTea type that matches against an EnumItem type.

	```lua
	local IsTextXAlignmentRaw = GreenTeaUtilities.IsEnumItemOfType(
		Enum.TextXAlignment.Center :: Enum.TextXAlignment, -- casting required
		"TextXAlignment"
	)

	local IsTextXAlignment = GreenTea.build(IsTextXAlignmentRaw)
	export type TextXAlignment = typeof(IsTextXAlignment:type())
	```

	@function IsEnumItemOfType
	@within GreenTeaUtilities

	@param enumType T -- The EnumItem. You will have to cast.
	@param enumName string -- The name of the EnumItem.
	@return T -- This is actually a build-able GreenTea type.
]=]
local function IsEnumItemOfType<T>(enumType: T, enumName: string)
	do
		local typeSuccess0, typeError0 = IsEnumItem:matches(enumType)
		if not typeSuccess0 then
			error(typeError0)
		end
		local typeSuccess1, typeError1 = IsString:matches(enumName)
		if not typeSuccess1 then
			error(typeError1)
		end
	end

	return GreenTea.withCustom(enumType, function(enumItem)
		if typeof(enumItem) ~= "EnumItem" then
			return false, `expected an EnumItem, got {Debug.Inspect(enumItem)}`
		end

		if not enumItem:IsA(enumName) then
			return false, `expected an EnumItem of type {enumName}, got {Debug.Inspect(enumItem)}`
		end

		return true
	end, `Enum.{enumName}`)
end

return IsEnumItemOfType
