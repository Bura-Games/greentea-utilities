--!optimize 2
--!strict

local IntersectionPlus = require(script.IntersectionPlus)
local IsDataStoreSafe = require(script.IsDataStoreSafe)
local IsDateTime = require(script.IsDateTime)
local IsEnumItemOfType = require(script.IsEnumItemOfType)
local IsInstanceWithChildren = require(script.IsInstanceWithChildren)
local IsMap = require(script.IsMap)
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
	IsInstanceWithChildren = IsInstanceWithChildren;
	IsMap = IsMap;
	IsSet = IsSet;
	Map = IsMap;
	Set = IsSet;
	Union = UnionPlus;
	UnionPlus = UnionPlus;
})

export type DataStoreSafe = IsDataStoreSafe.DataStoreSafe
export type Set<K> = IsSet.Set<K>
export type Map<K, V> = IsMap.Map<K, V>

return GreenTeaUtilities
