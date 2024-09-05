local Signal = require(script.Parent.Parent.Parent.packages.Signal)
local Settings, Lib = shared.Settings, shared.Apps.Lib

-- Define the Button class
local Button = {}
Button.__index = Button

-- Constructor for Button
function Button.new()
	local self = setmetatable({}, Button)

	local b = Instance.new("TextButton")
	b.AutoButtonColor = false
	b.TextColor3 = Settings.Theme.Text
	b.TextTransparency = 0.1
	b.Size = UDim2.new(0, 100, 0, 20)
	b.Font = Enum.Font.SourceSans
	b.TextSize = 14
	b.BackgroundColor3 = Settings.Theme.Button
	b.BorderColor3 = Settings.Theme.Outline2

	self.Gui = b
	self.Anim = Lib.ButtonAnim(b, {
		Mode = 2,
		StartColor = Settings.Theme.Button,
		HoverColor = Settings.Theme.ButtonHover,
		PressColor = Settings.Theme.ButtonPress,
		OutlineColor = Settings.Theme.Outline2,
	})
	self.Disabled = false
	self.OnClick = Signal.new()
	self.OnDown = Signal.new()
	self.OnUp = Signal.new()
	self.AllowedButtons = { 1 }

	b.MouseButton1Click:Connect(function()
		self:Trigger("Click", 1)
	end)
	b.MouseButton1Down:Connect(function()
		self:Trigger("Down", 1)
	end)
	b.MouseButton1Up:Connect(function()
		self:Trigger("Up", 1)
	end)

	b.MouseButton2Click:Connect(function()
		self:Trigger("Click", 2)
	end)
	b.MouseButton2Down:Connect(function()
		self:Trigger("Down", 2)
	end)
	b.MouseButton2Up:Connect(function()
		self:Trigger("Up", 2)
	end)

	return self
end

-- Method to trigger events
function Button:Trigger(event, button)
	if not self.Disabled and table.find(self.AllowedButtons, button) then
		if self["On" .. event] then
			self["On" .. event]:Fire(button)
		else
			warn("Attempt to call missing method 'On" .. event .. "' of table")
		end
	end
end

-- Method to set disabled state
function Button:SetDisabled(dis)
	self.Disabled = dis

	if dis then
		self.Anim:Disable()
		self.Gui.TextTransparency = 0.5
	else
		self.Anim:Enable()
		self.Gui.TextTransparency = 0
	end
end

return {
	new = Button.new,
}
