--!native
--!optimize 2
--// Paficent \\-

local function clone(obj: Instance): Instance
	if cloneref then
		return cloneref(obj)
	end

	return obj
end

--// Module Declaration
local Services = {}
Services.__index = Services
setmetatable(Services, {
	-- Handles dynamic service creation or retrieval
	__index = function(self, name: string)
		local service
		if name == "VirtualInputManager" or name == "VirtualUser" then
			service = clone(Instance.new(name))
		else
			service = clone(game:GetService(name))
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
