local utils = require(script.Parent.Parent.Parent.utils)

local Settings = shared.Settings

local props, funcs = {}, {}

local mt = utils.getGuiMT(props, funcs)

local function new()
	local fr = Instance.new("Frame")
	fr.BackgroundColor3 = Settings.Theme.Main1
	fr.BorderColor3 = Settings.Theme.Outline1
	fr.Size = UDim2.new(0, 50, 0, 50)

	local obj = setmetatable({
		Gui = fr,
	}, mt)
	return obj
end

return { new = new }
