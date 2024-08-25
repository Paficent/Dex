--// This project thrives off of PR's and interaction via GitHub, if you want to add a config for dex, fork the project and make a pull request

local Config = {}
Config.decompiler, Config.saveinstance = {}, {}

local env = {}
local elevated
env.IsElevated = function()
	elevated = elevated ~= nil and elevated
		or pcall(function()
			local _ = game:GetService("CoreGui"):GetFullName()
		end)
end
env.HttpGet = function(self, url)
	return env.IsElevated() and game:HttpGet(url) or game:GetService("HttpService"):GetAsync(url)
end

--// Decompilers
local fail = function(...)
	return "-- Dex failed to decompile this script"
end
Config.decompiler.default = function()
	return decompile or fail
end

Config.decompiler.oracle = function(key: string)
	local function decompile() -- TODO
	end
	return decompile or Config.decompiler.default()
end

--// Save Instance
Config.saveinstance.default = function()
	return saveinstance
end

Config.saveinstance.universalSyn = function()
	local Params = {
		RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
		SSI = "saveinstance",
	}

	return env.IsElevated() and loadstring(env:HttpGet(Params.RepoURL .. Params.SSI .. ".luau"), Params.SSI)()
		or Config.saveinstance.default()
end

return Config
