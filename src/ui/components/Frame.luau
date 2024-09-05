local Settings = shared.Settings

local Frame = {}
Frame.__index = Frame

function Frame.new()
	local self = setmetatable({}, Frame)

	local fr = Instance.new("Frame")
	fr.BackgroundColor3 = Settings.Theme.Main1
	fr.BorderColor3 = Settings.Theme.Outline1
	fr.Size = UDim2.new(0, 50, 0, 50)

	self.Gui = fr

	return self
end

return {
	new = Frame.new,
}
