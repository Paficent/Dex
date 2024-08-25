--// This project thrives off of PR's and interaction via GitHub, if you want to add a config for dex fork the project and make a pull request

local Config = {}
Config.decompiler = {}

--// Decompilers
local fail = function(...)
	return "-- Dex failed to decompile this script"
end
Config.decompiler.default = function()
	return decompile or fail
end

Config.decompiler.oracle = function(key: string)
	-- TODO
end

return Config
