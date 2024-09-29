--!optimize 2
--!strict

local Debug = require(script.Parent.Parent.Debug)
local GreenTea = require(script.Parent.Parent.GreenTea)

local IsConstructorRaw = GreenTea.fn(
	GreenTea.args(GreenTea.vararg(GreenTea.unknown({allowNil = true}))),
	GreenTea.returns(GreenTea.anyTable())
)
local IsIsFunctionRaw = GreenTea.fn(GreenTea.args(GreenTea.any()), GreenTea.returns(GreenTea.boolean()))

local IsBaseClassSetup = GreenTea.build({
	new = IsConstructorRaw;
	Is = GreenTea.optional(IsIsFunctionRaw);
	instanceof = GreenTea.optional(IsIsFunctionRaw);
	[GreenTea.any()] = GreenTea.any({allowNil = true});
})
local IsMaybeBoolean = GreenTea.build(GreenTea.optional(GreenTea.boolean()))
local IsMaybeString = GreenTea.build(GreenTea.optional(GreenTea.string()))
local IsTable = GreenTea.build(GreenTea.anyTable())

type BaseClassSetup<T> = {
	new: (...any?) -> T,
	-- Is: ((value: any) -> boolean)?,
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
	@param allowIsOrInstanceOf? boolean -- If this is true, the type checker will use an `Is` or `instanceof` in the class to check if the value is an instance of the class.
	@param className? string -- The name of the class. If not provided, the name will be inferred from the class somehow.
	@return T -- This is actually a build-able GreenTea type.
]=]
local function IsInstanceOfLuauClass<T>(luauClass: BaseClassSetup<T>, allowIsOrInstanceOf: boolean?, className: string?)
	do
		local typeSuccess0, typeError0 = IsTable:matches(luauClass)
		if not typeSuccess0 then
			error(typeError0)
		end
		local typeSuccess1, typeError1 = IsMaybeBoolean:matches(allowIsOrInstanceOf)
		if not typeSuccess1 then
			error(typeError1)
		end
		local typeSuccess2, typeError2 = IsMaybeString:matches(className)
		if not typeSuccess2 then
			error(typeError2)
		end
	end
	-- assert(type(luauClass) == "table", "Luau")

	-- if allowIsOrInstanceOf then
	-- 	local directClassCheck: nil | (value: any) -> boolean = luauClass.Is or luauClass.instanceof
	-- 	if directClassCheck then
	-- 		return GreenTea.withCustom((nil :: never) :: T, function(classObject)
	-- 			return true
	-- 		end)
	-- 	end
	-- end

	return GreenTea.withCustom((nil :: never) :: T, function(classObject)
		local typeSuccess, typeError = IsTable:matches(classObject)
		if not typeSuccess then
			return false, tostring(typeError)
		end

		return true
	end)
end

return IsInstanceOfLuauClass
