local Signal = require(script.Parent.Parent.Parent.packages.Signal)
local utils = require(script.Parent.Parent.Parent.utils)

local Settings, Lib = shared.Settings, shared.Apps.Lib

local props = {
	Gui = newproxy(),
	Anim = newproxy(),
	Disabled = false,
	OnClick = Signal.new(),
	OnDown = Signal.new(),
	OnUp = Signal.new(),
	AllowedButtons = { 1 },
}
local funcs = {}
local tableFind = table.find

funcs.Trigger = function(self, event, button)
	if not self.Disabled and tableFind(self.AllowedButtons, button) then
		self["On" .. event]:Fire(button)
	end
end

funcs.SetDisabled = function(self, dis)
	self.Disabled = dis

	if dis then
		self.Anim:Disable()
		self.Gui.TextTransparency = 0.5
	else
		self.Anim.Enable()
		self.Gui.TextTransparency = 0
	end
end

local mt = utils.getGuiMT(props, funcs)

local function new()
	local b = Instance.new("TextButton")
	b.AutoButtonColor = false
	b.TextColor3 = Settings.Theme.Text
	b.TextTransparency = 0.1
	b.Size = UDim2.new(0, 100, 0, 20)
	b.Font = Enum.Font.SourceSans
	b.TextSize = 14
	b.BackgroundColor3 = Settings.Theme.Button
	b.BorderColor3 = Settings.Theme.Outline2

	local obj = utils.initObj(props, mt)
	obj.Gui = b
	obj.Anim = Lib.ButtonAnim(b, {
		Mode = 2,
		StartColor = Settings.Theme.Button,
		HoverColor = Settings.Theme.ButtonHover,
		PressColor = Settings.Theme.ButtonPress,
		OutlineColor = Settings.Theme.Outline2,
	})

	b.MouseButton1Click:Connect(function()
		obj:Trigger("Click", 1)
	end)
	b.MouseButton1Down:Connect(function()
		obj:Trigger("Down", 1)
	end)
	b.MouseButton1Up:Connect(function()
		obj:Trigger("Up", 1)
	end)

	b.MouseButton2Click:Connect(function()
		obj:Trigger("Click", 2)
	end)
	b.MouseButton2Down:Connect(function()
		obj:Trigger("Down", 2)
	end)
	b.MouseButton2Up:Connect(function()
		obj:Trigger("Up", 2)
	end)

	return obj
end

return { new = new }
