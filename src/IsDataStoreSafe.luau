--!optimize 2
--!strict

local EnglishUtilities = require(script.Parent.Utilities.EnglishUtilities)
local GreenTea = require(script.Parent.Parent.GreenTea)

export type DataStoreSafe = {DataStoreSafe} | {[string]: DataStoreSafe} | boolean | nil | number | string

local NO_EXTRA_CHECKS = {
	boolean = true;
	["nil"] = true;
	number = true;
	string = true;
}
local VALID_TYPES = {
	boolean = true;
	["nil"] = true;
	number = true;
	string = true;
	table = true;
}
local function IsTypeValid(object: unknown)
	local typeOf = typeof(object)
	return not not VALID_TYPES[typeOf], typeOf
end
type ScanResult = {
	Success: true,
} | {
	Success: false,
	Path: {string},
	Reason: string,
	Extra: string?,
}
-- Also written by Corecii
local function ScanValidity(object: any, passed: {[unknown]: true}?, path: {string}?): ScanResult
	if type(object) ~= "table" then
		return ScanValidity({Input = object}, {}, {})
	end

	local truePassed: {[unknown]: true} = passed or {}
	local truePath: {string} = path or {"Input"}

	truePassed[object] = true
	local tableType: "Array" | "Dictionary" = if type((next(object))) == "number" then "Array" else "Dictionary"
	local last = 0

	-- using next instead of generalized iterators because of __call metamethod
	-- breaking generalized iterators
	for key, value in next, object do
		table.insert(truePath, tostring(key))
		if type(key) == "number" then
			if tableType == "Dictionary" then
				return {
					Success = false;
					Path = truePath;
					Reason = "Mixed Array / Dictionary";
				}
			end

			if key % 1 ~= 0 then -- if not an integer
				return {
					Success = false;
					Path = truePath;
					Reason = "Non-integer index";
				}
			end

			if key == math.huge or key == -math.huge then
				return {
					Success = false;
					Path = truePath;
					Reason = "(-)Infinity index";
				}
			end
		elseif type(key) ~= "string" then
			-- return AsResult(false, truePath, "Non-string key", typeof(key))
			return {
				Success = false;
				Path = truePath;
				Reason = "Non-string key";
				Extra = typeof(key);
			}
		elseif tableType == "Array" then
			return {
				Success = false;
				Path = truePath;
				Reason = "Mixed Array / Dictionary";
			}
		end

		if tableType == "Array" then
			if last ~= key - 1 then
				return {
					Success = false;
					Path = truePath;
					Reason = "Array with non-sequential indexes";
				}
			end

			last = key
		end

		local isTypeValid, valueType = IsTypeValid(value)
		if not isTypeValid then
			return {
				Success = false;
				Path = truePath;
				Reason = "Invalid type";
				Extra = valueType;
			}
		end

		if type(value) == "table" then
			if truePassed[value] then
				return {
					Success = false;
					Path = truePath;
					Reason = "Cyclic";
				}
			end

			local result = ScanValidity(value, truePassed, truePath)
			if not result.Success then
				return result
			end
		end

		truePath[#truePath] = nil
	end

	truePassed[object] = nil
	return {Success = true}
end
local function GetStringPath(path: {string})
	return table.concat(path, ".")
end
local function TestValidity(input: unknown): string?
	local result = ScanValidity(input)
	if result.Success then
		return nil
	end

	local extra = result.Extra
	return `Invalid at {GetStringPath(result.Path)} because: {result.Reason}{if extra then ` ({extra})` else ""}`
end

--[=[
	A type that indicates what is safe to store in a data store.
	@type DataStoreSafe {DataStoreSafe} | {[string]: DataStoreSafe} | boolean | nil | number | string
	@within GreenTeaUtilities
]=]

--[=[
	Makes sure that the given value is safe to store in a data store.

	```lua
	local IsDataStoreSafe = GreenTea.build(GreenTeaUtilities.IsDataStoreSafe)
	IsDataStoreSafe:assert(nil)
	IsDataStoreSafe:assert(1)
	IsDataStoreSafe:assert("hi")
	IsDataStoreSafe:assert({IsDataStoreSafe = true})
	IsDataStoreSafe:assert({1, 2, 3})
	IsDataStoreSafe:assert({IsDataStoreSafe = true, 1, 2, 3}) -- fails
	IsDataStoreSafe:assert(Vector3.zero) -- fails
	```

	@readonly
	@prop IsDataStoreSafe DataStoreSafe
	@within GreenTeaUtilities
]=]
local IsDataStoreSafe = GreenTea.withCustom(nil :: DataStoreSafe, function(value)
	local typeOf = typeof(value)
	if NO_EXTRA_CHECKS[typeOf] then
		return true
	end

	if typeOf == "table" then
		local exception = TestValidity(value)
		if exception then
			return false, exception
		end

		return true
	end

	return false, `You cannot store {EnglishUtilities.GetIndefiniteArticle(typeOf)} {typeOf} in data stores.`
end, "DataStoreSafe")

return IsDataStoreSafe
