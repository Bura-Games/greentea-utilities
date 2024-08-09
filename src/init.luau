--!optimize 2
--!strict

local IntersectionPlus = require(script.IntersectionPlus)
local IsDataStoreSafe = require(script.IsDataStoreSafe)
local IsDateTime = require(script.IsDateTime)
local IsEnumItemOfType = require(script.IsEnumItemOfType)
local IsSet = require(script.IsSet)
local UnionPlus = require(script.UnionPlus)

--[=[
	Utilities for working with GreenTea. This can be many things, such as:

	- Missing types from the root
	- Fixed types
	- Custom types

	@class GreenTeaUtilities
]=]
local GreenTeaUtilities = table.freeze({
	Intersection = IntersectionPlus;
	IntersectionPlus = IntersectionPlus;
	IsDataStoreSafe = IsDataStoreSafe;
	IsDateTime = IsDateTime;
	IsEnumItemOfType = IsEnumItemOfType;
	IsSet = IsSet;
	Set = IsSet;
	Union = UnionPlus;
	UnionPlus = UnionPlus;
})

export type DataStoreSafe = IsDataStoreSafe.DataStoreSafe
export type Set<K> = IsSet.Set<K>

return GreenTeaUtilities
