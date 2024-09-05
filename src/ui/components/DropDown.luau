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

function funcs:Update()
	local options = self.Options
	local label = self.GuiElems.Label

	if #options > 0 then
		if not self.Selected then
			label.Text = self.CanBeEmpty and "- Select -" or options[1]
			if not self.CanBeEmpty then
				self.Selected = options[1]
			end
		else
			label.Text = self.Selected
		end
	else
		label.Text = "- Select -"
	end
end

function funcs:ShowOptions()
	local context = self.Context
	local guiPosition = self.Gui.AbsolutePosition
	local guiSize = self.Gui.AbsoluteSize

	context.Width = guiSize.X
	context.ReverseYOffset = guiSize.Y
	context:Show(guiPosition.X, guiPosition.Y + context.ReverseYOffset)
end

function funcs:SetOptions(opts)
	self.Options = opts
	self.Context:Clear()

	local context = self.Context
	local options = self.Options

	local function onClick(option)
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

	for _, option in options do
		context:Add({ Name = option, OnClick = onClick })
	end

	self:Update()
end

function funcs:SetSelected(opt)
	self.Selected = type(opt) == "number" and self.Options[opt] or opt
	self:Update()
end

local function new()
	local button = Instance.new("TextButton")
	button.AutoButtonColor = false
	button.Text = ""
	button.Size = UDim2.new(0, 100, 0, 20)
	button.BackgroundColor3 = Settings.Theme.TextBox
	button.BorderColor3 = Settings.Theme.Outline3

	local label = require(script.Parent.Label).new()
	label.Position = UDim2.new(0, 2, 0, 0)
	label.Size = UDim2.new(1, -22, 1, 0)
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = button

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
				BackgroundColor3 = Color3.fromRGB(220, 220, 220),
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
				BackgroundColor3 = Color3.fromRGB(220, 220, 220),
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
				BackgroundColor3 = Color3.fromRGB(220, 220, 220),
				BorderSizePixel = 0,
				Parent = { 1 },
				Position = UDim2.new(0, 6, 0, 7),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
	})
	arrow.Parent = button

	local obj = setmetatable(funcs, {})
	obj.Gui = button
	obj.Anim = Lib.ButtonAnim(
		button,
		{ Mode = 2, StartColor = Settings.Theme.TextBox, LerpTo = Settings.Theme.Button, LerpDelta = 0.15 }
	)
	obj.Context = require(script.Parent.ContextMenu).new()
	obj.Context.Iconless = true
	obj.Context.MaxHeight = 200
	obj.Selected = nil
	obj.GuiElems = { Label = label }

	button.MouseButton1Down:Connect(function()
		obj:ShowOptions()
	end)

	obj:Update()
	return obj
end

return { new = new }
