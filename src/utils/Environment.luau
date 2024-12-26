--!strict
--!native
--!optimize 2
--// Paficent \\-

type Function = (...any) -> any?

local Environment = {}
Environment.__index = Environment

local HttpService: HttpService = game:GetService("HttpService")
local missingEnv = {}
local elevated

function Environment:IsElevated(): boolean
	if elevated == nil then
		elevated = pcall(function()
			game:GetService("CoreGui"):GetFullName()
		end)
	end
	return elevated
end

function Environment:HttpEnabled(): boolean
	local didRun = pcall(function()
		HttpService:GetAsync("http://setup.roblox.com/versionQTStudio")
	end)
	return didRun
end

function Environment:HttpGet(url: string): string
	return if self:IsElevated() then game:HttpGet(url) else HttpService:GetAsync(url)
end

function Environment:GetMissing(): ({ string }, number)
	return missingEnv, #missingEnv
end

function Environment:Register(name: string, func: Function?)
	if not func then
		self.missingEnv[#self.missingEnv + 1] = name
	else
		self[name] = func
	end
end

function Environment:Refresh()
	-- FS
	Environment.isFile = isfile
	Environment.isFolder = isfolder
	Environment.readFile = readfile
	Environment.writeFile = writefile
	Environment.appendFile = appendfile
	Environment.makeFolder = makefolder
	Environment.listFiles = listfiles
	Environment.loadFile = loadfile
	Environment.getCustomAsset = getcustomasset

	Environment.getUpvalues = debug.getupvalues
	Environment.getConstants = debug.getconstants
	Environment.checkCaller = checkcaller
	Environment.getRegistry = getreg
	Environment.getGC = getgc
	Environment.setFFlag = setfflag
	Environment.getHUI = gethui
	Environment.setClipboard = setclipboard
	Environment.getNilInstances = getnilinstances
	Environment.getLoadedModules = getloadedmodules

	Environment.protectGui = protect_gui or protectgui
	Environment.decompile = decompile
	Environment.saveInstance = saveinstance

	Environment.cloneRef = function(obj: Instance): Instance
		return if cloneref then cloneref(obj) else obj
	end
	Environment.isCClosure = iscclosure or function(...)
		return debug.getinfo(...).what == "C"
	end
	Environment.isLClosure = islclosure or is_l_closure or function(...)
		return debug.getinfo(...).what == "Lua"
	end
end

Environment:Refresh()
return Environment
