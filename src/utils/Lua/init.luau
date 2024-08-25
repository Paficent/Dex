--!native
--!optimize 2
--// Paficent \\--

local LuaUtils = {}
LuaUtils.__index = LuaUtils

local env = require(script.Parent.env)

local Compiler, Fiu
if not env.IsElevated() then
	Compiler = script:FindFirstChild("Compiler") and require(script.Compiler)
	Fiu = script:FindFirstChild("Fiu") and require(script.Fiu)
end

function LuaUtils.new(scr: LocalScript | ModuleScript | string)
	local isScript = type(scr) ~= "string"
		and typeof(scr) == "Instance"
		and (scr:IsA("LocalScript") or script:IsA("ModuleScript"))

	return setmetatable({
		Source = not isScript and scr or nil,
		Script = isScript and scr or nil,
		Bytecode = nil,
		Hash = nil,
	}, LuaUtils)
end

function LuaUtils:GetBytecode()
	if self.Bytecode then
		return self.Bytecode
	end

	if Compiler then
		self.Bytecode = Compiler.luau_compile(self.Source)
	else
		self.Bytecode = getscriptbytecode and getscriptbytecode(self.Script)
			or dumpstring and dumpstring(self.Script)
			or nil
	end

	return self.Bytecode
end

function LuaUtils:Decompile(): string
	if not self.Script then
		return "-- Attempted to decompile source??"
	end

	if self.Source then
		return self.Source
	end

	local ran, source = pcall(env.decompile, self.Script)
	if not ran or not source then
		source = "-- Dex failed to decompile this script"
	end

	return source
end

function LuaUtils:Run()
	local loaded
	if Fiu then
		if not self.Bytecode then
			return
		end

		loaded = Fiu.luau_load(self.Bytecode, getfenv(1))()
	else
		xpcall(function()
			loaded = loadstring(self.Source)
			loaded = loaded and loaded()
		end, function(err)
			print(err)
		end)
	end

	return loaded
end

return LuaUtils
