local Signal = require(script.Parent.Parent.Parent.packages.Signal)

local Settings = shared.Settings
local Lib, create = shared.Apps.Lib, shared.create

local funcs = {
	Gui = newproxy(),
	Anim = newproxy(),
	Context = newproxy(),
	Selected = newproxy(),
	Disabled = false,
	CanBeEmpty = true,
	Options = {},
	GuiElems = {},
	OnSelect = Signal.new(),
}

funcs.Update = function(self)
	local options = self.Options

	if #options > 0 then
		if not self.Selected then
			if not self.CanBeEmpty then
				self.Selected = options[1]
				self.GuiElems.Label.Text = options[1]
			else
				self.GuiElems.Label.Text = "- Select -"
			end
		else
			self.GuiElems.Label.Text = self.Selected
		end
	else
		self.GuiElems.Label.Text = "- Select -"
	end
end

funcs.ShowOptions = function(self)
	local context = self.Context

	context.Width = self.Gui.AbsoluteSize.X
	context.ReverseYOffset = self.Gui.AbsoluteSize.Y
	context:Show(self.Gui.AbsolutePosition.X, self.Gui.AbsolutePosition.Y + context.ReverseYOffset)
end

funcs.SetOptions = function(self, opts)
	self.Options = opts

	local context = self.Context
	local options = self.Options
	context:Clear()

	local onClick = function(option)
		self.Selected = option
		self.OnSelect:Fire(option)
		self:Update()
	end

	if self.CanBeEmpty then
		context:Add({
			Name = "- Select -",
			OnClick = function()
				self.Selected = nil
				self.OnSelect:Fire(nil)
				self:Update()
			end,
		})
	end

	for i = 1, #options do
		context:Add({ Name = options[i], OnClick = onClick })
	end

	self:Update()
end

funcs.SetSelected = function(self, opt)
	self.Selected = type(opt) == "number" and self.Options[opt] or opt
	self:Update()
end

local function new()
	local f = Instance.new("TextButton")
	f.AutoButtonColor = false
	f.Text = ""
	f.Size = UDim2.new(0, 100, 0, 20)
	f.BackgroundColor3 = Settings.Theme.TextBox
	f.BorderColor3 = Settings.Theme.Outline3

	local label = require(script.Parent.Label).new()
	label.Position = UDim2.new(0, 2, 0, 0)
	label.Size = UDim2.new(1, -22, 1, 0)
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = f
	local arrow = create({
		{
			1,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "EnumArrow",
				Position = UDim2.new(1, -16, 0, 2),
				Size = UDim2.new(0, 16, 0, 16),
			},
		},
		{
			2,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 1 },
				Position = UDim2.new(0, 8, 0, 9),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			3,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 1 },
				Position = UDim2.new(0, 7, 0, 8),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			4,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 1 },
				Position = UDim2.new(0, 6, 0, 7),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
	})
	arrow.Parent = f

	local obj = setmetatable(funcs, {})
	obj.Gui = f
	obj.Anim = Lib.ButtonAnim(
		f,
		{ Mode = 2, StartColor = Settings.Theme.TextBox, LerpTo = Settings.Theme.Button, LerpDelta = 0.15 }
	)
	obj.Context = require(script.Parent.ContextMenu).new()
	obj.Context.Iconless = true
	obj.Context.MaxHeight = 200
	obj.Selected = nil
	obj.GuiElems = { Label = label }
	f.MouseButton1Down:Connect(function()
		obj:ShowOptions()
	end)
	obj:Update()
	return obj
end

return { new = new }
