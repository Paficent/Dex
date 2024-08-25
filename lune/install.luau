local fs = require("@lune/fs")
local task = require("@lune/task")
local process = require("@lune/process")
local serde = require("@lune/serde")

local installDir = "./Packages"
local dependencies = serde.decode("toml", fs.readFile("wally.toml")).dependencies
if next(dependencies) == nil then
	print("Skipping installation, no rojo dependencies")
	return
end

local function movePackages(srcDir, destDir)
	if not fs.isFile(".lune/wax.luau") then -- Don't move packages if we're not running a wax bundled project
		return
	end

	if fs.isDir(destDir) then
		fs.removeDir(destDir)
	end

	fs.move(srcDir, destDir)
	installDir = "./src/packages"
end

print("Installing rojo packages")
print(process.spawn("wally", { "install" }).stdout)
repeat
	task.wait()
until fs.isDir("Packages")
task.wait(1)
movePackages("Packages", "src/packages")
if fs.isDir("Packages") then
	fs.removeDir("Packages")
end

print(`Successfully installed rojo packages to {installDir}`)
