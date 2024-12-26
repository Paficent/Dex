local fs = require("@lune/fs")
local net = require("@lune/net")
local serde = require("@lune/serde")
local process = require("@lune/process")
local datetime = require("@lune/datetime")

local wallyData = serde.decode("toml", fs.readFile("wally.toml")).package
local projectData = serde.decode("json", fs.readFile("build.project.json"))
local projectName: string = projectData.name

local robloxVersion = net.request("http://setup.roblox.com/versionQTStudio").body
local toUpdate = {
	{
		file = "misc/assets/Version.luau",
		link = "http://setup.roblox.com/versionQTStudio",
		format = true,
	},
	{
		file = "misc/assets/API.luau",
		link = `http://setup.roblox.com/{robloxVersion}-API-Dump.json`,
		format = true,
	},
	{
		file = "misc/assets/RMD.luau",
		link = `https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/ReflectionMetadata.xml`,
		format = true,
	},
}

local handleSpecs
handleSpecs = function(dir)
	local readDirectory = fs.readDir(dir)
	for _, file in readDirectory do
		local fullPath = dir .. "/" .. file
		if fs.isDir(fullPath) then
			handleSpecs(fullPath)
		else
			local parts = file:split(".")
			if table.find(parts, "spec") then
				fs.removeFile(fullPath)
			end
		end
	end
end

if not fs.isDir("build") then
	print("Creating Build Folder")
	fs.writeDir("build")
end

print("Installing Packages")
do
	if fs.isDir("Packages") then
		fs.removeDir("Packages")
	end
	process.spawn("wally", { "install" })
	process.spawn("rojo", { "sourcemap", "-o", "sourcemap.json" })
	process.spawn("wally-package-types", { "--sourcemap", "sourcemap.json", "Packages/" })
	handleSpecs("Packages/_Index")
end

for i, data in pairs(toUpdate) do
	print(`Updating required dependencies {i}/{#toUpdate} ({data.file})`)
	local output = net.request(data.link).body

	if data.format then
		output = `return [[\n\n{output}\n\n]]`
	end
	fs.writeFile(data.file, output)
end

print("Building For Studio")
process.spawn("rojo", { "build", "--output", `build/{projectName}.rbxm`, "build.project.json" })

print("Bundling For Client")
process.spawn("lune", {
	"run",
	"wax",
	"bundle",
	`input=bundle.project.json`,
	`output=build/{projectName}.luau`,
	`env-name={projectName}Runtime`,
})

do
	local header = fs.readFile("misc/Header.txt")
	local date = datetime.now()
	fs.writeFile(
		`build/{projectName}.luau`,
		header
			.. `-- Updated: {date:formatLocalTime("%m/%d/%Y")}\n`
			.. `-- Version: {wallyData.version}\n`
			.. `-- License: {wallyData.license}\n`
			.. `\n\n\n\nlocal args = \{...}; __{projectName}__ = args[1]\n\n`
			.. fs.readFile(`build/{projectName}.luau`)
	)
end

print(`\nSuccessfully Built {projectName} For Production`)
