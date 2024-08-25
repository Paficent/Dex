local env = {}
env.__index = env

--// Locals
local HttpService: HttpService = game:GetService("HttpService")
local Config = shared.Main.Config
local MissingEnv = {}
local elevated

env.IsElevated = function()
	elevated = elevated ~= nil and elevated
		or pcall(function()
			local _ = game:GetService("CoreGui"):GetFullName()
		end)
end

env.HttpGet = function(self, url)
	return env.IsElevated() and game:HttpGet(url) or HttpService:GetAsync(url)
end

env.GetMissingEnv = function(self)
	return MissingEnv, #MissingEnv
end

do
	setmetatable(env, {
		__newindex = function(self, name, func)
			if not func then
				MissingEnv[#MissingEnv + 1] = name
				return
			end
			rawset(self, name, func)
		end,
	})

	env.getcustomasset = getcustomasset
	env.isfile = isfile
	env.readfile = readfile
	env.writefile = writefile
	env.appendfile = appendfile
	env.makefolder = makefolder
	env.listfiles = listfiles
	env.loadfile = loadfile

	env.decompile = Config.decompiler or decompile
	env.saveinstance = Config.saveinstance or saveinstance
	env.cloneref = function(obj: Instance): Instance
		if cloneref then
			return cloneref(obj)
		end

		return obj
	end

	env.getupvalues = debug.getupvalues or getupvalues
	env.getconstants = debug.getconstants or getconstants
	env.islclosure = islclosure or is_l_closure or function(closure)
		return not iscclosure(closure)
	end
	env.checkcaller = checkcaller
	env.getreg = getreg
	env.getgc = getgc

	env.setfflag = setfflag
	env.protectgui = protect_gui
	env.gethui = gethui
	env.setclipboard = setclipboard
	env.getnilinstances = getnilinstances
	env.getloadedmodules = getloadedmodules
end

return env
