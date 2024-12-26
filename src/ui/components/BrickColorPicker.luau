local Services = require(script.Parent.Parent.Parent.utils.Services)
local Signal = require(script.Parent.Parent.Parent.Packages.Signal)

local Players: Players, UserInputService: UserInputService = Services:Get("Players", "UserInputService")
local create, Lib = shared.create, shared.Apps.Lib

local funcs = {}
local paletteCount = 0
local mouse = Players.LocalPlayer:GetMouse()
local hexStartX = 4
local hexSizeX = 27
local hexTriangleStart = 1
local hexTriangleSize = 8

local bottomColors = {
	Color3.fromRGB(17, 17, 17),
	Color3.fromRGB(99, 95, 98),
	Color3.fromRGB(163, 162, 165),
	Color3.fromRGB(205, 205, 205),
	Color3.fromRGB(223, 223, 222),
	Color3.fromRGB(237, 234, 234),
	Color3.fromRGB(27, 42, 53),
	Color3.fromRGB(91, 93, 105),
	Color3.fromRGB(159, 161, 172),
	Color3.fromRGB(202, 203, 209),
	Color3.fromRGB(231, 231, 236),
	Color3.fromRGB(248, 248, 248),
}

local function isMouseInHexagon(hex)
	local relativeX = mouse.X - hex.AbsolutePosition.X
	local relativeY = mouse.Y - hex.AbsolutePosition.Y
	if relativeX >= hexStartX and relativeX < hexStartX + hexSizeX then
		relativeX = relativeX - 4
		local relativeWidth = (13 - math.min(relativeX, 26 - relativeX)) / 13
		if
			relativeY >= hexTriangleStart + hexTriangleSize * relativeWidth
			and relativeY < hex.AbsoluteSize.Y - hexTriangleStart - hexTriangleSize * relativeWidth
		then
			return true
		end
	end

	return false
end

local function hexInput(self, hex, color)
	hex.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and isMouseInHexagon(hex) then
			self.OnSelect:Fire(color)
			self:Close()
		end
	end)

	hex.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and isMouseInHexagon(hex) then
			self.OnPreview:Fire(color)
		end
	end)
end

local function createGui(self)
	local gui = create({
		{ 1, "ScreenGui", { Name = "BrickColor" } },
		{
			2,
			"Frame",
			{
				Active = true,
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				BorderColor3 = Color3.new(0.1294117718935, 0.1294117718935, 0.1294117718935),
				Parent = { 1 },
				Position = UDim2.new(0.40000000596046, 0, 0.40000000596046, 0),
				Size = UDim2.new(0, 337, 0, 380),
			},
		},
		{
			3,
			"TextButton",
			{
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				BorderSizePixel = 0,
				Font = 3,
				Name = "MoreColors",
				Parent = { 2 },
				Position = UDim2.new(0, 5, 1, -30),
				Size = UDim2.new(1, -10, 0, 25),
				Text = "More Colors",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
			},
		},
		{
			4,
			"ImageLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "rbxassetid://1281023007",
				ImageColor3 = Color3.new(0.33333334326744, 0.33333334326744, 0.49803924560547),
				Name = "Hex",
				Parent = { 2 },
				Size = UDim2.new(0, 35, 0, 35),
				Visible = false,
			},
		},
	})
	local colorFrame = gui.Frame
	local hex = colorFrame.Hex

	for row = 1, 13 do
		local columns = math.min(row, 14 - row) + 6
		for column = 1, columns do
			local nextColor = BrickColor.palette(paletteCount).Color
			local newHex = hex:Clone()
			newHex.Position = UDim2.new(0, (column - 1) * 25 - (columns - 7) * 13 + 3 * 26 + 1, 0, (row - 1) * 23 + 4)
			newHex.ImageColor3 = nextColor
			newHex.Visible = true
			hexInput(self, newHex, nextColor)
			newHex.Parent = colorFrame
			paletteCount = paletteCount + 1
		end
	end

	for column = 1, 12 do
		local nextColor = bottomColors[column]
		local newHex = hex:Clone()
		newHex.Position = UDim2.new(0, (column - 1) * 25 - (12 - 7) * 13 + 3 * 26 + 3, 0, 308)
		newHex.ImageColor3 = nextColor
		newHex.Visible = true
		hexInput(self, newHex, nextColor)
		newHex.Parent = colorFrame
		paletteCount = paletteCount + 1
	end

	colorFrame.MoreColors.MouseButton1Click:Connect(function()
		self.OnMoreColors:Fire()
		self:Close()
	end)

	self.Gui = gui
end

funcs.SetMoreColorsVisible = function(self, vis)
	local colorFrame = self.Gui.Frame
	colorFrame.Size = UDim2.new(0, 337, 0, 380 - (not vis and 33 or 0))
	colorFrame.MoreColors.Visible = vis
end

funcs.Show = function(self, x, y, prevColor)
	self.PrevColor = prevColor or self.PrevColor

	local reverseY = false

	x, y = x or mouse.X, y or mouse.Y
	local maxX, maxY = mouse.ViewSizeX, mouse.ViewSizeY
	Lib.ShowGui(self.Gui)
	local sizeX, sizeY = self.Gui.Frame.AbsoluteSize.X, self.Gui.Frame.AbsoluteSize.Y

	if x + sizeX > maxX then
		x = self.ReverseX and x - sizeX or maxX - sizeX
	end
	if y + sizeY > maxY then
		reverseY = true
	end

	local closable = false
	if self.CloseEvent then
		self.CloseEvent:Disconnect()
	end
	self.CloseEvent = UserInputService.InputBegan:Connect(function(input)
		if not closable or input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		if not Lib.CheckMouseInGui(self.Gui.Frame) then
			self.CloseEvent:Disconnect()
			self:Close()
		end
	end)

	if reverseY then
		local newY = y - sizeY - (self.ReverseYOffset or 0)
		y = newY >= 0 and newY or 0
	end

	self.Gui.Frame.Position = UDim2.new(0, x, 0, y)

	Lib.FastWait()
	closable = true
end

funcs.Close = function(self)
	self.Gui.Parent = nil
	self.OnCancel:Fire()
end

local mt = { __index = funcs }

local function new()
	local obj = setmetatable({
		OnPreview = Signal.new(),
		OnSelect = Signal.new(),
		OnCancel = Signal.new(),
		OnMoreColors = Signal.new(),
		PrevColor = Color3.new(0, 0, 0),
	}, mt)
	createGui(obj)
	return obj
end

return { new = new }
