local Services = require(script.Parent.Parent.Parent.utils.Services)
local Signal = require(script.Parent.Parent.Parent.Packages.Signal)

local Players: Players, UserInputService: UserInputService = Services:Get("Players", "UserInputService")
local Lib = shared.Apps.Lib

local funcs = {}
local user = UserInputService
local mouse = Players.LocalPlayer:GetMouse()
local checkMouseInGui = Lib.CheckMouseInGui
local createArrow = Lib.CreateArrow

local function drawThumb(self)
	local total = self.TotalSpace
	local visible = self.VisibleSpace
	local scrollThumb = self.GuiElems.ScrollThumb
	local scrollThumbFrame = self.GuiElems.ScrollThumbFrame

	if not (self:CanScrollUp() or self:CanScrollDown()) then
		scrollThumb.Visible = false
	else
		scrollThumb.Visible = true
	end

	if self.Horizontal then
		scrollThumb.Size = UDim2.new(visible / total, 0, 1, 0)
		if scrollThumb.AbsoluteSize.X < 16 then
			scrollThumb.Size = UDim2.new(0, 16, 1, 0)
		end
		local fs = scrollThumbFrame.AbsoluteSize.X
		local bs = scrollThumb.AbsoluteSize.X
		scrollThumb.Position = UDim2.new(self:GetScrollPercent() * (fs - bs) / fs, 0, 0, 0)
	else
		scrollThumb.Size = UDim2.new(1, 0, visible / total, 0)
		if scrollThumb.AbsoluteSize.Y < 16 then
			scrollThumb.Size = UDim2.new(1, 0, 0, 16)
		end
		local fs = scrollThumbFrame.AbsoluteSize.Y
		local bs = scrollThumb.AbsoluteSize.Y
		scrollThumb.Position = UDim2.new(0, 0, self:GetScrollPercent() * (fs - bs) / fs, 0)
	end
end

local function createFrame(self)
	local newFrame = Instance.new("Frame")
	newFrame.Style = 0
	newFrame.Active = true
	newFrame.AnchorPoint = Vector2.new(0, 0)
	newFrame.BackgroundColor3 = Color3.new(0.35294118523598, 0.35294118523598, 0.35294118523598)
	newFrame.BackgroundTransparency = 0
	newFrame.BorderColor3 = Color3.new(0.10588236153126, 0.16470588743687, 0.20784315466881)
	newFrame.BorderSizePixel = 0
	newFrame.ClipsDescendants = false
	newFrame.Draggable = false
	newFrame.Position = UDim2.new(1, -16, 0, 0)
	newFrame.Rotation = 0
	newFrame.Selectable = false
	newFrame.Size = UDim2.new(0, 16, 1, 0)
	newFrame.SizeConstraint = 0
	newFrame.Visible = true
	newFrame.ZIndex = 1
	newFrame.Name = "ScrollBar"
	local button1 = nil
	local button2 = nil

	if self.Horizontal then
		newFrame.Size = UDim2.new(1, 0, 0, 16)
		button1 = Instance.new("ImageButton")
		button1.Parent = newFrame
		button1.Name = "Left"
		button1.Size = UDim2.new(0, 16, 0, 16)
		button1.BackgroundTransparency = 1
		button1.BorderSizePixel = 0
		button1.AutoButtonColor = false
		createArrow(16, 4, "left").Parent = button1

		button2 = Instance.new("ImageButton")
		button2.Parent = newFrame
		button2.Name = "Right"
		button2.Position = UDim2.new(1, -16, 0, 0)
		button2.Size = UDim2.new(0, 16, 0, 16)
		button2.BackgroundTransparency = 1
		button2.BorderSizePixel = 0
		button2.AutoButtonColor = false
		createArrow(16, 4, "right").Parent = button2
	else
		newFrame.Size = UDim2.new(0, 16, 1, 0)

		button1 = Instance.new("ImageButton")
		button1.Parent = newFrame
		button1.Name = "Up"
		button1.Size = UDim2.new(0, 16, 0, 16)
		button1.BackgroundTransparency = 1
		button1.BorderSizePixel = 0
		button1.AutoButtonColor = false
		createArrow(16, 4, "up").Parent = button1

		button2 = Instance.new("ImageButton")
		button2.Parent = newFrame
		button2.Name = "Down"
		button2.Position = UDim2.new(0, 0, 1, -16)
		button2.Size = UDim2.new(0, 16, 0, 16)
		button2.BackgroundTransparency = 1
		button2.BorderSizePixel = 0
		button2.AutoButtonColor = false
		createArrow(16, 4, "down").Parent = button2
	end

	local scrollThumbFrame = Instance.new("Frame")
	scrollThumbFrame.BackgroundTransparency = 1
	scrollThumbFrame.Parent = newFrame
	if self.Horizontal then
		scrollThumbFrame.Position = UDim2.new(0, 16, 0, 0)
		scrollThumbFrame.Size = UDim2.new(1, -32, 1, 0)
	else
		scrollThumbFrame.Position = UDim2.new(0, 0, 0, 16)
		scrollThumbFrame.Size = UDim2.new(1, 0, 1, -32)
	end

	local scrollThumb = Instance.new("Frame")
	scrollThumb.BackgroundColor3 = Color3.new(120 / 255, 120 / 255, 120 / 255)
	scrollThumb.BorderSizePixel = 0
	scrollThumb.Parent = scrollThumbFrame

	local markerFrame = Instance.new("Frame")
	markerFrame.BackgroundTransparency = 1
	markerFrame.Name = "Markers"
	markerFrame.Size = UDim2.new(1, 0, 1, 0)
	markerFrame.Parent = scrollThumbFrame

	local buttonPress = false
	local thumbPress = false
	local thumbFramePress = false

	--local thumbColor = Color3.new(120/255,120/255,120/255)
	--local thumbSelectColor = Color3.new(140/255,140/255,140/255)
	button1.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress and self:CanScrollUp() then
			button1.BackgroundTransparency = 0.8
		end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not self:CanScrollUp() then
			return
		end
		buttonPress = true
		button1.BackgroundTransparency = 0.5
		if self:CanScrollUp() then
			self:ScrollUp()
			self.Scrolled:Fire()
		end
		local buttonTick = tick()
		local releaseEvent
		releaseEvent = user.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			releaseEvent:Disconnect()
			if checkMouseInGui(button1) and self:CanScrollUp() then
				button1.BackgroundTransparency = 0.8
			else
				button1.BackgroundTransparency = 1
			end
			buttonPress = false
		end)
		while buttonPress do
			if tick() - buttonTick >= 0.3 and self:CanScrollUp() then
				self:ScrollUp()
				self.Scrolled:Fire()
			end
			wait()
		end
	end)
	button1.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress then
			button1.BackgroundTransparency = 1
		end
	end)
	button2.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress and self:CanScrollDown() then
			button2.BackgroundTransparency = 0.8
		end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not self:CanScrollDown() then
			return
		end
		buttonPress = true
		button2.BackgroundTransparency = 0.5
		if self:CanScrollDown() then
			self:ScrollDown()
			self.Scrolled:Fire()
		end
		local buttonTick = tick()
		local releaseEvent
		releaseEvent = user.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			releaseEvent:Disconnect()
			if checkMouseInGui(button2) and self:CanScrollDown() then
				button2.BackgroundTransparency = 0.8
			else
				button2.BackgroundTransparency = 1
			end
			buttonPress = false
		end)
		while buttonPress do
			if tick() - buttonTick >= 0.3 and self:CanScrollDown() then
				self:ScrollDown()
				self.Scrolled:Fire()
			end
			wait()
		end
	end)
	button2.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress then
			button2.BackgroundTransparency = 1
		end
	end)

	scrollThumb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and not thumbPress then
			scrollThumb.BackgroundTransparency = 0.2
			scrollThumb.BackgroundColor3 = self.ThumbSelectColor
		end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		local dir = self.Horizontal and "X" or "Y"
		local lastThumbPos = nil

		buttonPress = false
		thumbFramePress = false
		thumbPress = true
		scrollThumb.BackgroundTransparency = 0
		local mouseOffset = mouse[dir] - scrollThumb.AbsolutePosition[dir]
		local releaseEvent
		local mouseEvent
		releaseEvent = user.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			releaseEvent:Disconnect()
			if mouseEvent then
				mouseEvent:Disconnect()
			end
			if checkMouseInGui(scrollThumb) then
				scrollThumb.BackgroundTransparency = 0.2
			else
				scrollThumb.BackgroundTransparency = 0
				scrollThumb.BackgroundColor3 = self.ThumbColor
			end
			thumbPress = false
		end)
		self:Update()

		mouseEvent = user.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and thumbPress and releaseEvent.Connected then
				local thumbFrameSize = scrollThumbFrame.AbsoluteSize[dir] - scrollThumb.AbsoluteSize[dir]
				local pos = mouse[dir] - scrollThumbFrame.AbsolutePosition[dir] - mouseOffset
				if pos > thumbFrameSize then
					pos = thumbFrameSize
				elseif pos < 0 then
					pos = 0
				end
				if lastThumbPos ~= pos then
					lastThumbPos = pos
					self:ScrollTo(math.floor(0.5 + pos / thumbFrameSize * (self.TotalSpace - self.VisibleSpace)))
				end
				wait()
			end
		end)
	end)
	scrollThumb.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and not thumbPress then
			scrollThumb.BackgroundTransparency = 0
			scrollThumb.BackgroundColor3 = self.ThumbColor
		end
	end)
	scrollThumbFrame.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 or checkMouseInGui(scrollThumb) then
			return
		end

		local dir = self.Horizontal and "X" or "Y"
		local scrollDir = 0
		if mouse[dir] >= scrollThumb.AbsolutePosition[dir] + scrollThumb.AbsoluteSize[dir] then
			scrollDir = 1
		end

		local function doTick()
			local scrollSize = self.VisibleSpace - 1
			if scrollDir == 0 and mouse[dir] < scrollThumb.AbsolutePosition[dir] then
				self:ScrollTo(self.Index - scrollSize)
			elseif
				scrollDir == 1 and mouse[dir] >= scrollThumb.AbsolutePosition[dir] + scrollThumb.AbsoluteSize[dir]
			then
				self:ScrollTo(self.Index + scrollSize)
			end
		end

		thumbPress = false
		thumbFramePress = true
		doTick()
		local thumbFrameTick = tick()
		local releaseEvent
		releaseEvent = user.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			releaseEvent:Disconnect()
			thumbFramePress = false
		end)
		while thumbFramePress do
			if tick() - thumbFrameTick >= 0.3 and checkMouseInGui(scrollThumbFrame) then
				doTick()
			end
			wait()
		end
	end)

	newFrame.MouseWheelForward:Connect(function()
		self:ScrollTo(self.Index - self.WheelIncrement)
	end)

	newFrame.MouseWheelBackward:Connect(function()
		self:ScrollTo(self.Index + self.WheelIncrement)
	end)

	self.GuiElems.ScrollThumb = scrollThumb
	self.GuiElems.ScrollThumbFrame = scrollThumbFrame
	self.GuiElems.Button1 = button1
	self.GuiElems.Button2 = button2
	self.GuiElems.MarkerFrame = markerFrame

	return newFrame
end

funcs.Update = function(self, nocallback)
	local total = self.TotalSpace
	local visible = self.VisibleSpace
	local button1 = self.GuiElems.Button1
	local button2 = self.GuiElems.Button2

	self.Index = math.clamp(self.Index, 0, math.max(0, total - visible))

	if self.LastTotalSpace ~= self.TotalSpace then
		self.LastTotalSpace = self.TotalSpace
		self:UpdateMarkers()
	end

	if self:CanScrollUp() then
		for i, v in button1.Arrow:GetChildren() do
			v.BackgroundTransparency = 0
		end
	else
		button1.BackgroundTransparency = 1
		for i, v in button1.Arrow:GetChildren() do
			v.BackgroundTransparency = 0.5
		end
	end
	if self:CanScrollDown() then
		for i, v in button2.Arrow:GetChildren() do
			v.BackgroundTransparency = 0
		end
	else
		button2.BackgroundTransparency = 1
		for i, v in button2.Arrow:GetChildren() do
			v.BackgroundTransparency = 0.5
		end
	end

	drawThumb(self)
end

funcs.UpdateMarkers = function(self)
	local markerFrame = self.GuiElems.MarkerFrame
	markerFrame:ClearAllChildren()

	for i, v in self.Markers do
		if i < self.TotalSpace then
			local frame = Instance.new("Frame")

			frame.BackgroundTransparency = 0
			frame.BackgroundColor3 = v
			frame.BorderSizePixel = 0
			frame.Size = self.Horizontal and UDim2.new(0, 1, 0, 6) or UDim2.new(0, 6, 0, 1)
			frame.Name = "Marker" .. tostring(i)
			frame.Parent = markerFrame
			frame.Position = self.Horizontal and UDim2.new(i / self.TotalSpace, 0, 1, -6)
				or UDim2.new(1, -6, i / self.TotalSpace, 0)
		end
	end
end

funcs.AddMarker = function(self, ind, color)
	self.Markers[ind] = color or Color3.new(0, 0, 0)
end

funcs.ScrollTo = function(self, ind, nocallback)
	self.Index = ind
	self:Update()
	if not nocallback then
		self.Scrolled:Fire()
	end
end

funcs.ScrollUp = function(self)
	self.Index = self.Index - self.Increment
	self:Update()
end

funcs.ScrollDown = function(self)
	self.Index = self.Index + self.Increment
	self:Update()
end
funcs.CanScrollUp = function(self)
	return self.Index > 0
end
funcs.CanScrollDown = function(self)
	return self.Index + self.VisibleSpace < self.TotalSpace
end
funcs.GetScrollPercent = function(self)
	return self.Index / (self.TotalSpace - self.VisibleSpace)
end
funcs.SetScrollPercent = function(self, perc)
	self.Index = math.floor(perc * (self.TotalSpace - self.VisibleSpace))
	self:Update()
end

funcs.Texture = function(self, data)
	self.ThumbColor = data.ThumbColor or Color3.new(0, 0, 0)
	self.ThumbSelectColor = data.ThumbSelectColor or Color3.new(0, 0, 0)
	self.GuiElems.ScrollThumb.BackgroundColor3 = data.ThumbColor or Color3.new(0, 0, 0)
	self.Gui.BackgroundColor3 = data.FrameColor or Color3.new(0, 0, 0)
	self.GuiElems.Button1.BackgroundColor3 = data.ButtonColor or Color3.new(0, 0, 0)
	self.GuiElems.Button2.BackgroundColor3 = data.ButtonColor or Color3.new(0, 0, 0)
	for i, v in self.GuiElems.Button1.Arrow:GetChildren() do
		v.BackgroundColor3 = data.ArrowColor or Color3.new(0, 0, 0)
	end
	for i, v in self.GuiElems.Button2.Arrow:GetChildren() do
		v.BackgroundColor3 = data.ArrowColor or Color3.new(0, 0, 0)
	end
end

funcs.SetScrollFrame = function(self, frame)
	if self.ScrollUpEvent then
		self.ScrollUpEvent:Disconnect()
		self.ScrollUpEvent = nil
	end
	if self.ScrollDownEvent then
		self.ScrollDownEvent:Disconnect()
		self.ScrollDownEvent = nil
	end
	self.ScrollUpEvent = frame.MouseWheelForward:Connect(function()
		self:ScrollTo(self.Index - self.WheelIncrement)
	end)
	self.ScrollDownEvent = frame.MouseWheelBackward:Connect(function()
		self:ScrollTo(self.Index + self.WheelIncrement)
	end)
end

local mt = {}
mt.__index = funcs

local function new(hor)
	local obj = setmetatable({
		Index = 0,
		VisibleSpace = 0,
		TotalSpace = 0,
		Increment = 1,
		WheelIncrement = 1,
		Markers = {},
		GuiElems = {},
		Horizontal = hor,
		LastTotalSpace = 0,
		Scrolled = Signal.new(),
	}, mt)
	obj.Gui = createFrame(obj)
	obj:Texture({
		ThumbColor = Color3.fromRGB(60, 60, 60),
		ThumbSelectColor = Color3.fromRGB(75, 75, 75),
		ArrowColor = Color3.new(1, 1, 1),
		FrameColor = Color3.fromRGB(40, 40, 40),
		ButtonColor = Color3.fromRGB(75, 75, 75),
	})
	return obj
end

return { new = new }
