local Environment = {}
Environment.__index = Environment

--// Locals
local HttpService: HttpService = game:GetService("HttpService")
local Config = shared.Main.Config
local MissingEnv = {}
local elevated

Environment.IsElevated = function()
	elevated = elevated ~= nil and elevated
		or pcall(function()
			local _ = game:GetService("CoreGui"):GetFullName()
		end)
end

Environment.HttpGet = function(self, url)
	print(HttpService:GetAsync(url))
	return Environment.IsElevated() and game:HttpGet(url) or HttpService:GetAsync(url)
end

Environment.GetMissingEnv = function(self)
	return MissingEnv, #MissingEnv
end

do
	setmetatable(Environment, {
		__newindex = function(self, name, func)
			if not func then
				MissingEnv[#MissingEnv + 1] = name
				return
			end
			rawset(self, name, func)
		end,
	})
	-- file
	Environment.readfile = readfile
	Environment.writefile = writefile
	Environment.appendfile = appendfile
	Environment.makefolder = makefolder
	Environment.listfiles = listfiles
	Environment.loadfile = loadfile

	Environment.decompile = Config.decompiler or decompile
	Environment.saveinstance = Config.saveinstance or saveinstance

	-- debug
	Environment.getupvalues = debug.getupvalues or getupvalues
	Environment.getconstants = debug.getconstants or getconstants
	Environment.islclosure = islclosure or is_l_closure or function(closure)
		return not iscclosure(closure)
	end
	Environment.checkcaller = checkcaller
	Environment.getreg = getreg
	Environment.getgc = getgc

	-- other
	Environment.setfflag = setfflag

	Environment.protectgui = protect_gui
	Environment.gethui = gethui
	Environment.setclipboard = setclipboard
	Environment.getnilinstances = getnilinstances
	Environment.getloadedmodules = getloadedmodules
end

return Environment
