local Settings = shared.Settings

local Label = {}
Label.__index = Label

function Label.new()
	local self = setmetatable({}, Label)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Settings.Theme.Text
	label.TextTransparency = 0.1
	label.Size = UDim2.new(0, 100, 0, 20)
	label.Font = Enum.Font.SourceSans
	label.TextSize = 14

	self.Gui = label

	return self
end

return {
	new = Label.new,
}
