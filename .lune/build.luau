local fs = require("@lune/fs")
local net = require("@lune/net")
local process = require("@lune/process")
local task = require("@lune/task")

local defaultProject = fs.readFile("./default.project.json")
local projectName: string = net.jsonDecode(defaultProject).name
fs.writeFile("./default.project.json", string.format('{"name": "%s", "tree": { "$path": "src/" }}', projectName))

local vrsn = net.request("http://setup.roblox.com/versionQTStudio").body
local exclude = {
	["assets/API.luau"] = "http://setup.roblox.com/" .. vrsn .. "-API-Dump.json",
	["assets/RMD.luau"] = "https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/ReflectionMetadata.xml",
	["assets/Version.luau"] = vrsn,
	["utils/Lua/Fiu.luau"] = "https://raw.githubusercontent.com/rce-incorporated/Fiu/main/Source.lua",
	["utils/Lua/Compiler.luau"] = "https://github.com/RealEthanPlayzDev/LuauCeption/releases/latest/download/Luau.LuauCeption.Compiler.0.631.luau",
}

if not fs.isDir("build") then
	print("Creating build folder")
	fs.writeDir("build")
end


-- Main build
process.spawn("rojo", { "build", "--output", ("build/%s.rbxm"):format(projectName) })

for toExclude, link in ipairs(exclude) do
	fs.removeFile(toExclude)
	print(toExclude)
end

task.wait(3)

process.spawn("lune", { "run", "wax", "bundle", ("output=build/%s.luau"):format(projectName) })
fs.writeFile(
	(("build/%s.luau"):format(projectName)),
	"local args = {...}; getgenv().___dex___ = args[1]\n\n" .. fs.readFile(("build/%s.luau"):format(projectName))
)
fs.writeFile("./default.project.json", defaultProject)

for toExclude, link in ipairs(exclude) do
	fs.writeFile(toExclude, net.request(link).body)
end
task.wait(1)
print(("Successfully built %s"):format(projectName))
