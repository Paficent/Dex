local utils = require(script.Parent.Parent.Parent.utils)

local Settings = shared.Settings

local props = {}
local funcs = {}

local mt = utils.getGuiMT(props, funcs)

local function new()
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Settings.Theme.Text
	label.TextTransparency = 0.1
	label.Size = UDim2.new(0, 100, 0, 20)
	label.Font = Enum.Font.SourceSans
	label.TextSize = 14

	local obj = setmetatable({
		Gui = label,
	}, mt)

	return obj
end

return { new = new }
