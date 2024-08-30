local fs = require("@lune/fs")
local net = require("@lune/net")
local process = require("@lune/process")

local defaultProject = fs.readFile("./default.project.json")
local projectName: string = net.jsonDecode(defaultProject).name
fs.writeFile("./default.project.json", string.format('{"name": "%s", "tree": { "$path": "src/" }}', projectName))

local robloxVersion = net.request("http://setup.roblox.com/versionQTStudio").body
local toUpdate = {
	{
		file = "src/assets/Version.luau",
		link = "http://setup.roblox.com/versionQTStudio",
		format = true,
	},
	{
		file = "src/assets/API.luau",
		link = `http://setup.roblox.com/{robloxVersion}-API-Dump.json`,
		format = true,
	},
	{
		file = "src/assets/RMD.luau",
		link = `https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/ReflectionMetadata.xml`,
		format = true,
	},
	{
		file = "src/utils/Lua/Fiu.luau",
		link = `https://raw.githubusercontent.com/rce-incorporated/Fiu/main/Source.lua`,
		format = false,
	},
	{
		file = "src/utils/Lua/Compiler.luau",
		link = `https://github.com/RealEthanPlayzDev/LuauCeption/releases/latest/download/Luau.LuauCeption.Compiler.0.631.luau`,
		format = true,
	},
}

if not fs.isDir("build") then
	print("Creating build folder")
	fs.writeDir("build")
end

print("Updating wally packages")
process.spawn("wally", { "update" })

for i, data in pairs(toUpdate) do
	local output = net.request(data.link).body

	if data.format then
		output = `return [[\n\n{output}\n\n]]`
	end
	fs.writeFile(data.file, output)
	print(`Updating required modules {i}/{#toUpdate} ({data.file})`)
end

process.spawn("rojo", { "build", "--output", `build/{projectName}.rbxm` })
process.spawn("lune", { "run", "wax", "bundle", `output=build/{projectName}.luau` })
fs.writeFile(
	`build/{projectName}.luau`,
	"local args = {...}; getgenv().___dex___ = args[1]\n\n" .. fs.readFile(`build/{projectName}.luau`)
)
fs.writeFile("./default.project.json", defaultProject)
print(`Successfully built {projectName}`)
