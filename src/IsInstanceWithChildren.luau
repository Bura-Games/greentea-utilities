--!optimize 2
--!strict

local AsGreenTeaType = require(script.Parent.Utilities.AsGreenTeaType)
local Debug = require(script.Parent.Parent.Debug)
local GreenTea = require(script.Parent.Parent.GreenTea)

local IsValidChildren = GreenTea.build({[GreenTea.string()] = GreenTea.unknown({allowNil = true})})

--[=[
	A type that checks if a value is an Instance of a given root type, and then
	checks that all of the children are of the given types.

	```lua
	local IsModelWithHumanoidRaw = GreenTeaUtilities.IsInstanceWithChildren(GreenTea.IsA.Model(), {
		Humanoid = GreenTea.IsA.Humanoid();
	})
	export type ModelWithHumanoid = typeof(IsModelWithHumanoidRaw)
	```

	@since v1.3.0
	@function IsInstanceWithChildren
	@within GreenTeaUtilities

	@param root RootInstance -- The root type of the Instance.
	@param children Children -- A table of child types.
	@return RootInstance & Children -- This is actually a build-able GreenTea type.
]=]
local function IsInstanceWithChildren<RootInstance, Children>(root: RootInstance, children: Children): Children & RootInstance
	do
		local typeSuccess, typeError = IsValidChildren:matches(children)
		if not typeSuccess then
			error(typeError)
		end
	end

	-- dear reader, please don't recreate this function every time you use it.
	assert(type(children) == "table", "Luau")

	local childrenTypeCheckers: {[string]: any} = {}
	for key, childType in children do
		childrenTypeCheckers[key] = AsGreenTeaType(childType)
	end

	local rootType = AsGreenTeaType(root)

	return GreenTea.withCustom(rootType :: RootInstance & Children, function(instance)
		if not instance or typeof(instance) ~= "Instance" then
			return false, `expected an Instance, got {Debug.Inspect(instance)}`
		end

		for key, typeCheck in childrenTypeCheckers do
			local child = instance:FindFirstChild(key)
			if not child then
				return false, `missing child with name '{key}'`
			end

			local success, exception = typeCheck(child)
			if not success then
				return false, exception
			end
		end

		local existingChildren = {}
		for _, child in instance:GetChildren() do
			local name = child.Name
			if existingChildren[name] then
				return false, `duplicate child with name '{name}'`
			end

			existingChildren[name] = true
		end

		return true
	end)
end

return IsInstanceWithChildren
