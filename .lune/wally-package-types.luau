--!optimize 2
--!strict
--[=[ lunar
	about = "Runs a less buggy version of the Wally package types CLI."
	args = ""
]=]

local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local WallyPackageTypes = require("@utilities/WallyPackageTypes")
local process = require("@lune/process")

local Path = PathFileSystem.Path
local console = LuauPolyfill.console

local packagesPath = Path.new("Packages")
if not PathFileSystem.IsDirectory(packagesPath) then
	console.error("Packages folder not found. Try running `wally install` first.")
	process.exit(1)
end
WallyPackageTypes(packagesPath)

local devPackagesPath = Path.new("DevPackages")
if PathFileSystem.IsDirectory(devPackagesPath) then
	WallyPackageTypes(devPackagesPath)
end
