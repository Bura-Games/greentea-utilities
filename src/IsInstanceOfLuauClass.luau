--!optimize 2
--!strict

local Debug = require(script.Parent.Parent.Debug)
local EnglishUtilities = require(script.Parent.Utilities.EnglishUtilities)
local GreenTea = require(script.Parent.Parent.GreenTea)

local IsMaybeString = GreenTea.build(GreenTea.optional(GreenTea.string()))
local IsTable = GreenTea.build(GreenTea.anyTable())

type BaseClassSetup<T> = {
	new: (...any?) -> T,
	[any]: any,
}

--[=[
	A type that checks if a value is an instance of a given Luau metatable
	class.

	```lua
	local BasicClass = {}
	BasicClass.__index = BasicClass

	function BasicClass.new()
		return setmetatable({}, BasicClass)
	end

	function BasicClass:Print(...: unknown)
		print("[BasicClass] -", ...)
	end

	local IsBasicClassRaw = GreenTeaUtilities.IsInstanceOfLuauClass(BasicClass)
	export type BasicClass = typeof(IsBasicClassRaw)
	```

	```lua
	local BasicClass = {}
	BasicClass.__index = BasicClass

	function BasicClass.new()
		return setmetatable({}, BasicClass)
	end

	-- If you have a function that checks if a value is an instance of a class
	-- called either `Is` or `instanceof`, the type checker will use that to
	-- check if the value is an instance of the class. You can disable this
	-- behavior by passing `true` as the second argument.
	function BasicClass.Is(value: any)
		return type(value) == "table" and getmetatable(value) == BasicClass
	end

	function BasicClass:Print(...: unknown)
		print("[BasicClass] -", ...)
	end

	local IsBasicClassRaw = GreenTeaUtilities.IsInstanceOfLuauClass(BasicClass)
	local IsBasicClassRawBlockIsOrInstanceOf = GreenTeaUtilities.IsInstanceOfLuauClass(BasicClass, true)
	```

	@since v1.5.0
	@function IsInstanceOfLuauClass
	@within GreenTeaUtilities

	@param luauClass {new: (...any) -> T} -- The root table of the class.
	@param className? string -- The name of the class. If not provided, the name will be inferred from the class somehow.
	@return T -- This is actually a build-able GreenTea type.
]=]
local function IsInstanceOfLuauClass<T>(luauClass: BaseClassSetup<T>, className: string?)
	do
		local typeSuccess0, typeError0 = IsTable:matches(luauClass)
		if not typeSuccess0 then
			error(typeError0)
		end
		local typeSuccess2, typeError2 = IsMaybeString:matches(className)
		if not typeSuccess2 then
			error(typeError2)
		end
	end
	assert(type(luauClass) == "table", "Luau")

	local trueClassName = className or "class object"
	local indefiniteArticle = if className then EnglishUtilities.GetIndefiniteArticle(className) else "a"

	return GreenTea.withCustom((nil :: never) :: T, function(classObject)
		local typeSuccess, typeError = IsTable:matches(classObject)
		if not typeSuccess then
			return false, tostring(typeError)
		end

		local metatable = getmetatable(classObject)
		if not metatable then
			return false,
				`expected {indefiniteArticle} {trueClassName} with a metatable, got {Debug.Inspect(classObject)}`
		end

		if type(metatable) ~= "table" then
			return false,
				`expected {indefiniteArticle} {trueClassName} with a table metatable, got {Debug.Inspect(metatable)}`
		end

		if metatable.__index ~= luauClass then
			return false,
				`expected {indefiniteArticle} {trueClassName} with a metatable that indexes to {luauClass}, got {Debug.Inspect(
					metatable
				)}`
		end

		return true
	end)
end

return IsInstanceOfLuauClass
