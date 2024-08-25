--!native
--!optimize 2
--// Paficent \\-

--// Imports
local env = require(script.Parent.env)

--// Module Declaration
local Services = {}
Services.__index = Services
setmetatable(Services, {
	-- Handles dynamic service creation or retrieval
	__index = function(self, name: string)
		local service
		if name == "VirtualInputManager" or name == "VirtualUser" then
			service = env.cloneref(Instance.new(name))
		else
			service = env.cloneref(game:GetService(name))
		end

		rawset(self, name, service)
		return service
	end,

	-- Handles retrieval of multiple services
	__call = function(self, ...: string)
		local toReturn: { any } = {}

		for _, serviceName in ipairs({ ... }) do
			table.insert(toReturn, self[serviceName])
		end

		return table.unpack(toReturn)
	end,
})

-- Alternative Syntax, proxy for __call
function Services:Get(...: string)
	local toReturn: { any } = {}

	for _, serviceName in ipairs({ ... }) do
		table.insert(toReturn, self[serviceName])
	end

	return table.unpack(toReturn)
end

return Services
