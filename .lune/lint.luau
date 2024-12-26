local process = require("@lune/process")

print(process.spawn("rojo", { "sourcemap", "default.project.json", "-o", "sourcemap.json" }).stdout)
print(process.spawn("selene", #process.args == 0 and { "src" } or process.args).stdout)
