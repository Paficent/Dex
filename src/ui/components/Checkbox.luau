local Services = require(script.Parent.Parent.Parent.utils.Services)
local Signal = require(script.Parent.Parent.Parent.packages.Signal)

local Debris: Debris, TweenService: TweenService, UserInputService: UserInputService =
	Services:Get("Debris", "TweenService", "UserInputService")
local create, Lib = shared.create, shared.Apps.Lib

local funcs = {}
local c3 = Color3.fromRGB
local v2 = Vector2.new
local ud2s = UDim2.fromScale
local ud2o = UDim2.fromOffset
local ud = UDim.new
local max = math.max
local TweenSize = Instance.new("Frame").TweenSize
local ti = TweenInfo.new
local delay = delay

local function ripple(object, color)
	local circle = Instance.new("Frame")
	circle.BackgroundColor3 = color
	circle.BackgroundTransparency = 0.75
	circle.BorderSizePixel = 0
	circle.AnchorPoint = v2(0.5, 0.5)
	circle.Size = ud2o()
	circle.Position = ud2s(0.5, 0.5)
	circle.Parent = object
	local rounding = Instance.new("UICorner")
	rounding.CornerRadius = ud(1)
	rounding.Parent = circle

	local abssz = object.AbsoluteSize
	local size = max(abssz.X, abssz.Y) * 5 / 3

	TweenSize(circle, ud2o(size, size), "Out", "Quart", 0.4)
	TweenService
		:Create(circle, ti(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
		:Play()

	Debris:AddItem(circle, 0.4)
end

local function initGui(self, frame)
	local checkbox = frame
		or create({
			{
				1,
				"Frame",
				{
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Name = "Checkbox",
					Position = UDim2.new(0, 3, 0, 3),
					Size = UDim2.new(0, 16, 0, 16),
				},
			},
			{
				2,
				"Frame",
				{
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Name = "ripples",
					Parent = { 1 },
					Size = UDim2.new(1, 0, 1, 0),
				},
			},
			{
				3,
				"Frame",
				{
					BackgroundColor3 = Color3.new(0.10196078568697, 0.10196078568697, 0.10196078568697),
					BorderSizePixel = 0,
					Name = "outline",
					Parent = { 1 },
					Size = UDim2.new(0, 16, 0, 16),
				},
			},
			{
				4,
				"Frame",
				{
					BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462),
					BorderSizePixel = 0,
					Name = "filler",
					Parent = { 3 },
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(0, 14, 0, 14),
				},
			},
			{
				5,
				"Frame",
				{
					BackgroundColor3 = Color3.new(0.90196084976196, 0.90196084976196, 0.90196084976196),
					BorderSizePixel = 0,
					Name = "top",
					Parent = { 4 },
					Size = UDim2.new(0, 16, 0, 0),
				},
			},
			{
				6,
				"Frame",
				{
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = Color3.new(0.90196084976196, 0.90196084976196, 0.90196084976196),
					BorderSizePixel = 0,
					Name = "bottom",
					Parent = { 4 },
					Position = UDim2.new(0, 0, 0, 14),
					Size = UDim2.new(0, 16, 0, 0),
				},
			},
			{
				7,
				"Frame",
				{
					BackgroundColor3 = Color3.new(0.90196084976196, 0.90196084976196, 0.90196084976196),
					BorderSizePixel = 0,
					Name = "left",
					Parent = { 4 },
					Size = UDim2.new(0, 0, 0, 16),
				},
			},
			{
				8,
				"Frame",
				{
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = Color3.new(0.90196084976196, 0.90196084976196, 0.90196084976196),
					BorderSizePixel = 0,
					Name = "right",
					Parent = { 4 },
					Position = UDim2.new(0, 14, 0, 0),
					Size = UDim2.new(0, 0, 0, 16),
				},
			},
			{
				9,
				"Frame",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Name = "checkmark",
					Parent = { 4 },
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 0, 0, 20),
				},
			},
			{
				10,
				"ImageLabel",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = "rbxassetid://6234266378",
					Parent = { 9 },
					Position = UDim2.new(0.5, 0, 0.5, 0),
					ScaleType = 3,
					Size = UDim2.new(0, 15, 0, 11),
				},
			},
			{
				11,
				"ImageLabel",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					Image = "rbxassetid://6401617475",
					ImageColor3 = Color3.new(0.20784313976765, 0.69803923368454, 0.98431372642517),
					Name = "checkmark2",
					Parent = { 4 },
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 12, 0, 12),
					Visible = false,
				},
			},
			{
				12,
				"ImageLabel",
				{
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					Image = "rbxassetid://6425281788",
					ImageTransparency = 0.20000000298023,
					Name = "middle",
					Parent = { 4 },
					ScaleType = 2,
					Size = UDim2.new(1, 0, 1, 0),
					TileSize = UDim2.new(0, 2, 0, 2),
					Visible = false,
				},
			},
			{ 13, "UICorner", { CornerRadius = UDim.new(0, 2), Parent = { 3 } } },
		})
	local outline = checkbox.outline
	local filler = outline.filler
	local checkmark = filler.checkmark
	local ripples_container = checkbox.ripples

	-- walls
	local top, bottom, left, right = filler.top, filler.bottom, filler.left, filler.right

	self.Gui = checkbox
	self.GuiElems = {
		Top = top,
		Bottom = bottom,
		Left = left,
		Right = right,
		Outline = outline,
		Filler = filler,
		Checkmark = checkmark,
		Checkmark2 = filler.checkmark2,
		Middle = filler.middle,
	}

	checkbox.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			local release
			release = UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					release:Disconnect()

					if Lib.CheckMouseInGui(checkbox) then
						if self.Style == 0 then
							ripple(ripples_container, self.Disabled and self.Colors.Disabled or self.Colors.Primary)
						end

						if not self.Disabled then
							self:SetState(not self.Toggled, true)
						else
							self:Paint()
						end

						self.OnInput:Fire()
					end
				end
			end)
		end
	end)

	self:Paint()
end

funcs.Collapse = function(self, anim)
	local guiElems = self.GuiElems
	if anim then
		TweenSize(guiElems.Top, ud2o(14, 14), "In", "Quart", 4 / 15, true)
		TweenSize(guiElems.Bottom, ud2o(14, 14), "In", "Quart", 4 / 15, true)
		TweenSize(guiElems.Left, ud2o(14, 14), "In", "Quart", 4 / 15, true)
		TweenSize(guiElems.Right, ud2o(14, 14), "In", "Quart", 4 / 15, true)
	else
		guiElems.Top.Size = ud2o(14, 14)
		guiElems.Bottom.Size = ud2o(14, 14)
		guiElems.Left.Size = ud2o(14, 14)
		guiElems.Right.Size = ud2o(14, 14)
	end
end

funcs.Expand = function(self, anim)
	local guiElems = self.GuiElems
	if anim then
		TweenSize(guiElems.Top, ud2o(14, 0), "InOut", "Quart", 4 / 15, true)
		TweenSize(guiElems.Bottom, ud2o(14, 0), "InOut", "Quart", 4 / 15, true)
		TweenSize(guiElems.Left, ud2o(0, 14), "InOut", "Quart", 4 / 15, true)
		TweenSize(guiElems.Right, ud2o(0, 14), "InOut", "Quart", 4 / 15, true)
	else
		guiElems.Top.Size = ud2o(14, 0)
		guiElems.Bottom.Size = ud2o(14, 0)
		guiElems.Left.Size = ud2o(0, 14)
		guiElems.Right.Size = ud2o(0, 14)
	end
end

funcs.Paint = function(self)
	local guiElems = self.GuiElems

	if self.Style == 0 then
		local color_base = self.Disabled and self.Colors.Disabled
		guiElems.Outline.BackgroundColor3 = color_base
			or (self.Toggled and self.Colors.Primary)
			or self.Colors.Secondary
		local walls_color = color_base or self.Colors.Primary
		guiElems.Top.BackgroundColor3 = walls_color
		guiElems.Bottom.BackgroundColor3 = walls_color
		guiElems.Left.BackgroundColor3 = walls_color
		guiElems.Right.BackgroundColor3 = walls_color
	else
		guiElems.Outline.BackgroundColor3 = self.Disabled and self.Colors.Disabled or self.Colors.Secondary
		guiElems.Filler.BackgroundColor3 = self.Disabled and self.Colors.DisabledBackground or self.Colors.Background
		guiElems.Checkmark2.ImageColor3 = self.Disabled and self.Colors.DisabledCheck or self.Colors.Primary
	end
end

funcs.SetState = function(self, val, anim)
	self.Toggled = val

	if self.OutlineColorTween then
		self.OutlineColorTween:Cancel()
	end
	local setStateTime = tick()
	self.LastSetStateTime = setStateTime

	if self.Toggled then
		if self.Style == 0 then
			if anim then
				self.OutlineColorTween = TweenService:Create(
					self.GuiElems.Outline,
					ti(4 / 15, Enum.EasingStyle.Circular, Enum.EasingDirection.Out),
					{ BackgroundColor3 = self.Colors.Primary }
				)
				self.OutlineColorTween:Play()
				delay(0.15, function()
					if setStateTime ~= self.LastSetStateTime then
						return
					end
					self:Paint()
					TweenSize(self.GuiElems.Checkmark, ud2o(14, 20), "Out", "Bounce", 2 / 15, true)
				end)
			else
				self.GuiElems.Outline.BackgroundColor3 = self.Colors.Primary
				self:Paint()
				self.GuiElems.Checkmark.Size = ud2o(14, 20)
			end
			self:Collapse(anim)
		else
			self:Paint()
			self.GuiElems.Checkmark2.Visible = true
			self.GuiElems.Middle.Visible = false
		end
	else
		if self.Style == 0 then
			if anim then
				self.OutlineColorTween = TweenService:Create(
					self.GuiElems.Outline,
					ti(4 / 15, Enum.EasingStyle.Circular, Enum.EasingDirection.In),
					{ BackgroundColor3 = self.Colors.Secondary }
				)
				self.OutlineColorTween:Play()
				delay(0.15, function()
					if setStateTime ~= self.LastSetStateTime then
						return
					end
					self:Paint()
					TweenSize(self.GuiElems.Checkmark, ud2o(0, 20), "Out", "Quad", 1 / 15, true)
				end)
			else
				self.GuiElems.Outline.BackgroundColor3 = self.Colors.Secondary
				self:Paint()
				self.GuiElems.Checkmark.Size = ud2o(0, 20)
			end
			self:Expand(anim)
		else
			self:Paint()
			self.GuiElems.Checkmark2.Visible = false
			self.GuiElems.Middle.Visible = self.Toggled == nil
		end
	end
end

local mt = { __index = funcs }

local function new(style)
	local obj = setmetatable({
		Toggled = false,
		Disabled = false,
		OnInput = Signal.new(),
		Style = style or 0,
		Colors = {
			Background = c3(36, 36, 36),
			Primary = c3(49, 176, 230),
			Secondary = c3(25, 25, 25),
			Disabled = c3(64, 64, 64),
			DisabledBackground = c3(52, 52, 52),
			DisabledCheck = c3(80, 80, 80),
		},
	}, mt)
	initGui(obj)
	return obj
end

local function fromFrame(frame)
	local obj = setmetatable({
		Toggled = false,
		Disabled = false,
		Colors = {
			Background = c3(36, 36, 36),
			Primary = c3(49, 176, 230),
			Secondary = c3(25, 25, 25),
			Disabled = c3(64, 64, 64),
			DisabledBackground = c3(52, 52, 52),
		},
	}, mt)
	initGui(obj, frame)
	return obj
end

return { new = new, fromFrame }
