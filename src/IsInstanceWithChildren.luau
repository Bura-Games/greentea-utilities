--!optimize 2
--!strict

local Debug = require(script.Parent.Parent.Debug)
local GreenTea = require(script.Parent.Parent.GreenTea)

local function AsType(value: any)
	if GreenTea.isGreenTeaType(value) then
		return value
	end

	if value == nil then
		return GreenTea.none()
	end

	if type(value) == "function" then
		return GreenTea.custom(value)
	end

	return GreenTea.typeof(value)
end

--[=[
	A type that checks if a value is an Instance of a given root type, and then
	checks that all of the children are of the given types.

	```lua
	local IsModelWithHumanoidRaw = GreenTea.InstanceWithChildren(GreenTea.IsA.Model(), {
		Humanoid = GreenTea.IsA.Humanoid();
	})
	```

	@function IsInstanceWithChildren
	@within GreenTeaUtilities

	@param root T -- The root type of the Instance.
	@param children C -- A table of child types.
	@return T & C -- This is actually a build-able GreenTea type.
]=]
local function IsInstanceWithChildren<T, C>(root: T, children: C)
	assert(type(children) == "table", "children must be a table.")
	local childrenMapped = {}
	for key, childType in children do
		assert(type(key) == "string", "children keys must be strings.")
		childrenMapped[key] = AsType(childType)
	end

	local rootType = AsType(root)

	return GreenTea.withCustom(rootType :: T & C, function(value)
		if not value or typeof(value) ~= "Instance" then
			return false, `expected an instance, got {Debug.Inspect(value)}`
		end

		for key, typeCheck in childrenMapped do
			local child = value:FindFirstChild(key)
			if not child then
				return false, `missing child {key}`
			end

			local success, exception = typeCheck(child)
			if not success then
				return false, exception
			end
		end

		local existingChildren = {}
		for _, child in value:GetChildren() do
			if existingChildren[child.Name] then
				return false, `duplicate child {child.Name}`
			end

			existingChildren[child.Name] = true
		end

		return true
	end)
end

return IsInstanceWithChildren
