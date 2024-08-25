local Utils = {}

-- TODO rewrite classes so this isnt neccessary anymore
function Utils.initObj(props, mt)
	local type = type
	local function copy(t)
		local res = {}
		for i, v in pairs(t) do
			if type(v) == "table" then
				res[i] = copy(v)
			else
				res[i] = v
			end
		end
		return res
	end

	local newObj = copy(props)
	return setmetatable(newObj, mt)
end

function Utils.getGuiMT(props, funcs)
	return {
		__index = function(self, ind)
			if not props[ind] then
				return funcs[ind] or self.Gui[ind]
			end
			return nil
		end,
		__newindex = function(self, ind, val)
			if not props[ind] then
				self.Gui[ind] = val
			else
				rawset(self, ind, val)
			end
		end,
	}
end

Utils.env = require(script.env)
Utils.Lua = require(script.Lua)
Utils.Services = require(script.Services)

return Utils
