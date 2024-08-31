local Services = require(script.Parent.Parent.Parent.utils.Services)
local Signal = require(script.Parent.Parent.Parent.packages.Signal)

local Players: Players, TweenService: TweenService, UserInputService: UserInputService, RunService: RunService =
	Services:Get("Players", "TweenService", "UserInputService", "RunService")

local create, Lib, Main = shared.create, shared.Apps.Lib, shared.Main

local funcs = {}
local static = { MinWidth = 200, FreeWidth = 200 }
local mouse = Players.LocalPlayer:GetMouse()
local sidesGui, alignIndicator
local visibleWindows = {}
local leftSide = { Width = 300, Windows = {}, ResizeCons = {}, Hidden = true }
local rightSide = { Width = 300, Windows = {}, ResizeCons = {}, Hidden = true }

local displayOrderStart
local sideDisplayOrder
local sideTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweens = {}
local isA = game.IsA

local theme = {
	MainColor1 = Color3.fromRGB(52, 52, 52),
	MainColor2 = Color3.fromRGB(45, 45, 45),
	Button = Color3.fromRGB(60, 60, 60),
}

local function stopTweens()
	for i = 1, #tweens do
		tweens[i]:Cancel()
	end
	tweens = {}
end

local function resizeHook(self, resizer, dir)
	local guiMain = self.GuiElems.Main
	resizer.InputBegan:Connect(function(input)
		if not self.Dragging and not self.Resizing and self.Resizable and self.ResizableInternal then
			local isH = dir:find("[WE]") and true
			local isV = dir:find("[NS]") and true
			local signX = dir:find("W", 1, true) and -1 or 1
			local signY = dir:find("N", 1, true) and -1 or 1

			if self.Minimized and isV then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseMovement then
				resizer.BackgroundTransparency = 0.5
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				local releaseEvent, mouseEvent

				local offX = mouse.X - resizer.AbsolutePosition.X
				local offY = mouse.Y - resizer.AbsolutePosition.Y

				self.Resizing = resizer
				resizer.BackgroundTransparency = 1

				releaseEvent = UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						releaseEvent:Disconnect()
						mouseEvent:Disconnect()
						self.Resizing = false
						resizer.BackgroundTransparency = 1
					end
				end)

				mouseEvent = UserInputService.InputChanged:Connect(function(input)
					if
						self.Resizable
						and self.ResizableInternal
						and input.UserInputType == Enum.UserInputType.MouseMovement
					then
						self:StopTweens()
						local deltaX = input.Position.X - resizer.AbsolutePosition.X - offX
						local deltaY = input.Position.Y - resizer.AbsolutePosition.Y - offY

						if guiMain.AbsoluteSize.X + deltaX * signX < self.MinX then
							deltaX = signX * (self.MinX - guiMain.AbsoluteSize.X)
						end
						if guiMain.AbsoluteSize.Y + deltaY * signY < self.MinY then
							deltaY = signY * (self.MinY - guiMain.AbsoluteSize.Y)
						end
						if signY < 0 and guiMain.AbsolutePosition.Y + deltaY < 0 then
							deltaY = -guiMain.AbsolutePosition.Y
						end

						guiMain.Position = guiMain.Position
							+ UDim2.new(0, (signX < 0 and deltaX or 0), 0, (signY < 0 and deltaY or 0))
						self.SizeX = self.SizeX + (isH and deltaX * signX or 0)
						self.SizeY = self.SizeY + (isV and deltaY * signY or 0)
						guiMain.Size = UDim2.new(0, self.SizeX, 0, self.Minimized and 20 or self.SizeY)
					end
				end)
			end
		end
	end)

	resizer.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and self.Resizing ~= resizer then
			resizer.BackgroundTransparency = 1
		end
	end)
end

local updateWindows

local function moveToTop(window)
	local found = table.find(visibleWindows, window)
	if found then
		table.remove(visibleWindows, found)
		table.insert(visibleWindows, 1, window)
		updateWindows()
	end
end

local function sideHasRoom(side, neededSize)
	local maxY = sidesGui.AbsoluteSize.Y - (math.max(0, #side.Windows - 1) * 4)
	local inc = 0
	for i, v in pairs(side.Windows) do
		inc = inc + (v.MinY or 100)
		if inc > maxY - neededSize then
			return false
		end
	end

	return true
end

local function getSideInsertPos(side, curY)
	local pos = #side.Windows + 1
	local range = { 0, sidesGui.AbsoluteSize.Y }

	for i, v in pairs(side.Windows) do
		local midPos = v.PosY + v.SizeY / 2
		if curY <= midPos then
			pos = i
			range[2] = midPos
			break
		else
			range[1] = midPos
		end
	end

	return pos, range
end

local function focusInput(self, obj)
	if isA(obj, "GuiButton") then
		obj.MouseButton1Down:Connect(function()
			moveToTop(self)
		end)
	elseif isA(obj, "TextBox") then
		obj.Focused:Connect(function()
			moveToTop(self)
		end)
	end
end

local createGui = function(self)
	local gui = create({
		{ 1, "ScreenGui", { Name = "Window" } },
		{
			2,
			"Frame",
			{
				Active = true,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "Main",
				Parent = { 1 },
				Position = UDim2.new(0.40000000596046, 0, 0.40000000596046, 0),
				Size = UDim2.new(0, 300, 0, 300),
			},
		},
		{
			3,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				BorderSizePixel = 0,
				Name = "Content",
				Parent = { 2 },
				Position = UDim2.new(0, 0, 0, 20),
				Size = UDim2.new(1, 0, 1, -20),
				ClipsDescendants = true,
			},
		},
		{
			4,
			"Frame",
			{
				BackgroundColor3 = Color3.fromRGB(33, 33, 33),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 3 },
				Size = UDim2.new(1, 0, 0, 1),
			},
		},
		{
			5,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394),
				BorderSizePixel = 0,
				Name = "TopBar",
				Parent = { 2 },
				Size = UDim2.new(1, 0, 0, 20),
			},
		},
		{
			6,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 5 },
				Position = UDim2.new(0, 5, 0, 0),
				Size = UDim2.new(1, -10, 0, 20),
				Text = "Window",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			7,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Close",
				Parent = { 5 },
				Position = UDim2.new(1, -18, 0, 2),
				Size = UDim2.new(0, 16, 0, 16),
				Text = "",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
			},
		},
		{
			8,
			"ImageLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Image = "rbxassetid://5054663650",
				Parent = { 7 },
				Position = UDim2.new(0, 3, 0, 3),
				Size = UDim2.new(0, 10, 0, 10),
			},
		},
		{ 9, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 7 } } },
		{
			10,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Minimize",
				Parent = { 5 },
				Position = UDim2.new(1, -36, 0, 2),
				Size = UDim2.new(0, 16, 0, 16),
				Text = "",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
			},
		},
		{
			11,
			"ImageLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Image = "rbxassetid://5034768003",
				Parent = { 10 },
				Position = UDim2.new(0, 3, 0, 3),
				Size = UDim2.new(0, 10, 0, 10),
			},
		},
		{ 12, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 10 } } },
		{
			13,
			"ImageLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "rbxassetid://1427967925",
				Name = "Outlines",
				Parent = { 2 },
				Position = UDim2.new(0, -5, 0, -5),
				ScaleType = 1,
				Size = UDim2.new(1, 10, 1, 10),
				SliceCenter = Rect.new(6, 6, 25, 25),
				TileSize = UDim2.new(0, 20, 0, 20),
			},
		},
		{
			14,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Name = "ResizeControls",
				Parent = { 2 },
				Position = UDim2.new(0, -5, 0, -5),
				Size = UDim2.new(1, 10, 1, 10),
			},
		},
		{
			15,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "North",
				Parent = { 14 },
				Position = UDim2.new(0, 5, 0, 0),
				Size = UDim2.new(1, -10, 0, 5),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			16,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "South",
				Parent = { 14 },
				Position = UDim2.new(0, 5, 1, -5),
				Size = UDim2.new(1, -10, 0, 5),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			17,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "NorthEast",
				Parent = { 14 },
				Position = UDim2.new(1, -5, 0, 0),
				Size = UDim2.new(0, 5, 0, 5),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			18,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "East",
				Parent = { 14 },
				Position = UDim2.new(1, -5, 0, 5),
				Size = UDim2.new(0, 5, 1, -10),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			19,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "West",
				Parent = { 14 },
				Position = UDim2.new(0, 0, 0, 5),
				Size = UDim2.new(0, 5, 1, -10),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			20,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "SouthEast",
				Parent = { 14 },
				Position = UDim2.new(1, -5, 1, -5),
				Size = UDim2.new(0, 5, 0, 5),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			21,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "NorthWest",
				Parent = { 14 },
				Size = UDim2.new(0, 5, 0, 5),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			22,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.27450981736183, 0.27450981736183, 0.27450981736183),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "SouthWest",
				Parent = { 14 },
				Position = UDim2.new(0, 0, 1, -5),
				Size = UDim2.new(0, 5, 0, 5),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
	})

	local guiMain = gui.Main
	local guiTopBar = guiMain.TopBar
	local guiResizeControls = guiMain.ResizeControls

	self.GuiElems.Main = guiMain
	self.GuiElems.TopBar = guiMain.TopBar
	self.GuiElems.Content = guiMain.Content
	self.GuiElems.Line = guiMain.Content.Line
	self.GuiElems.Outlines = guiMain.Outlines
	self.GuiElems.Title = guiTopBar.Title
	self.GuiElems.Close = guiTopBar.Close
	self.GuiElems.Minimize = guiTopBar.Minimize
	self.GuiElems.ResizeControls = guiResizeControls
	self.ContentPane = guiMain.Content

	guiTopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and self.Draggable then
			local releaseEvent, mouseEvent

			local maxX = sidesGui.AbsoluteSize.X
			local initX = guiMain.AbsolutePosition.X
			local initY = guiMain.AbsolutePosition.Y
			local offX = mouse.X - initX
			local offY = mouse.Y - initY

			local alignInsertPos, alignInsertSide

			guiDragging = true

			releaseEvent = game:GetService("UserInputService").InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					releaseEvent:Disconnect()
					mouseEvent:Disconnect()
					guiDragging = false
					alignIndicator.Parent = nil
					if alignInsertSide then
						local targetSide = (alignInsertSide == "left" and leftSide)
							or (alignInsertSide == "right" and rightSide)
						self:AlignTo(targetSide, alignInsertPos)
					end
				end
			end)

			mouseEvent = game:GetService("UserInputService").InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and self.Draggable and not self.Closed then
					if self.Aligned then
						if leftSide.Resizing or rightSide.Resizing then
							return
						end
						local posX, posY = input.Position.X - offX, input.Position.Y - offY
						local delta = math.sqrt((posX - initX) ^ 2 + (posY - initY) ^ 2)
						if delta >= 5 then
							self:SetAligned(false)
						end
					else
						local inputX, inputY = input.Position.X, input.Position.Y
						local posX, posY = inputX - offX, inputY - offY
						if posY < 0 then
							posY = 0
						end
						guiMain.Position = UDim2.new(0, posX, 0, posY)

						if self.Resizable and self.Alignable then
							if inputX < 25 then
								if sideHasRoom(leftSide, self.MinY or 100) then
									local insertPos, range = getSideInsertPos(leftSide, inputY)
									alignIndicator.Indicator.Position = UDim2.new(0, -15, 0, range[1])
									alignIndicator.Indicator.Size = UDim2.new(0, 40, 0, range[2] - range[1])
									Lib.ShowGui(alignIndicator)
									alignInsertPos = insertPos
									alignInsertSide = "left"
									return
								end
							elseif inputX >= maxX - 25 then
								if sideHasRoom(rightSide, self.MinY or 100) then
									local insertPos, range = getSideInsertPos(rightSide, inputY)
									alignIndicator.Indicator.Position = UDim2.new(0, maxX - 25, 0, range[1])
									alignIndicator.Indicator.Size = UDim2.new(0, 40, 0, range[2] - range[1])
									Lib.ShowGui(alignIndicator)
									alignInsertPos = insertPos
									alignInsertSide = "right"
									return
								end
							end
						end
						alignIndicator.Parent = nil
						alignInsertPos = nil
						alignInsertSide = nil
					end
				end
			end)
		end
	end)

	guiTopBar.Close.MouseButton1Click:Connect(function()
		if self.Closed then
			return
		end
		self:Close()
	end)

	guiTopBar.Minimize.MouseButton1Click:Connect(function()
		if self.Closed then
			return
		end
		if self.Aligned then
			self:SetAligned(false)
		else
			self:SetMinimized()
		end
	end)

	guiTopBar.Minimize.MouseButton2Click:Connect(function()
		if self.Closed then
			return
		end
		if not self.Aligned then
			self:SetMinimized(nil, 2)
			guiTopBar.Minimize.BackgroundTransparency = 1
		end
	end)

	guiMain.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.Aligned and not self.Closed then
			moveToTop(self)
		end
	end)

	guiMain:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		local absPos = guiMain.AbsolutePosition
		self.PosX = absPos.X
		self.PosY = absPos.Y
	end)

	resizeHook(self, guiResizeControls.North, "N")
	resizeHook(self, guiResizeControls.NorthEast, "NE")
	resizeHook(self, guiResizeControls.East, "E")
	resizeHook(self, guiResizeControls.SouthEast, "SE")
	resizeHook(self, guiResizeControls.South, "S")
	resizeHook(self, guiResizeControls.SouthWest, "SW")
	resizeHook(self, guiResizeControls.West, "W")
	resizeHook(self, guiResizeControls.NorthWest, "NW")

	guiMain.Size = UDim2.new(0, self.SizeX, 0, self.SizeY)

	gui.DescendantAdded:Connect(function(obj)
		focusInput(self, obj)
	end)
	local descs = gui:GetDescendants()
	for i = 1, #descs do
		focusInput(self, descs[i])
	end

	self.MinimizeAnim = Lib.ButtonAnim(guiTopBar.Minimize)
	self.CloseAnim = Lib.ButtonAnim(guiTopBar.Close)

	return gui
end

local function updateSideFrames(noTween)
	stopTweens()
	leftSide.Frame.Size = UDim2.new(0, leftSide.Width, 1, 0)
	rightSide.Frame.Size = UDim2.new(0, rightSide.Width, 1, 0)
	leftSide.Frame.Resizer.Position = UDim2.new(0, leftSide.Width, 0, 0)
	rightSide.Frame.Resizer.Position = UDim2.new(0, -5, 0, 0)

	local leftHidden = #leftSide.Windows == 0 or leftSide.Hidden
	local rightHidden = #rightSide.Windows == 0 or rightSide.Hidden
	local leftPos = (leftHidden and UDim2.new(0, -leftSide.Width - 10, 0, 0) or UDim2.new(0, 0, 0, 0))
	local rightPos = (rightHidden and UDim2.new(1, 10, 0, 0) or UDim2.new(1, -rightSide.Width, 0, 0))

	sidesGui.LeftToggle.Text = leftHidden and ">" or "<"
	sidesGui.RightToggle.Text = rightHidden and "<" or ">"

	if not noTween then
		local function insertTween(...)
			local tween = TweenService:Create(...)
			tweens[#tweens + 1] = tween
			tween:Play()
		end
		insertTween(leftSide.Frame, sideTweenInfo, { Position = leftPos })
		insertTween(rightSide.Frame, sideTweenInfo, { Position = rightPos })
		insertTween(
			sidesGui.LeftToggle,
			sideTweenInfo,
			{ Position = UDim2.new(0, #leftSide.Windows == 0 and -16 or 0, 0, -36) }
		)
		insertTween(
			sidesGui.RightToggle,
			sideTweenInfo,
			{ Position = UDim2.new(1, #rightSide.Windows == 0 and 0 or -16, 0, -36) }
		)
	else
		leftSide.Frame.Position = leftPos
		rightSide.Frame.Position = rightPos
		sidesGui.LeftToggle.Position = UDim2.new(0, #leftSide.Windows == 0 and -16 or 0, 0, -36)
		sidesGui.RightToggle.Position = UDim2.new(1, #rightSide.Windows == 0 and 0 or -16, 0, -36)
	end
end

local function getSideFramePos(side)
	local leftHidden = #leftSide.Windows == 0 or leftSide.Hidden
	local rightHidden = #rightSide.Windows == 0 or rightSide.Hidden
	if side == leftSide then
		return (leftHidden and UDim2.new(0, -leftSide.Width - 10, 0, 0) or UDim2.new(0, 0, 0, 0))
	else
		return (rightHidden and UDim2.new(1, 10, 0, 0) or UDim2.new(1, -rightSide.Width, 0, 0))
	end
end

local function sideResized(side)
	local currentPos = 0
	local sideFramePos = getSideFramePos(side)
	for i, v in pairs(side.Windows) do
		v.SizeX = side.Width
		v.GuiElems.Main.Size = UDim2.new(0, side.Width, 0, v.SizeY)
		v.GuiElems.Main.Position = UDim2.new(sideFramePos.X.Scale, sideFramePos.X.Offset, 0, currentPos)
		currentPos = currentPos + v.SizeY + 4
	end
end

local function sideResizerHook(resizer, dir, side, pos)
	local mouse = Main.Mouse
	local windows = side.Windows

	resizer.InputBegan:Connect(function(input)
		if not side.Resizing then
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				resizer.BackgroundColor3 = theme.MainColor2
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				local releaseEvent, mouseEvent

				local offX = mouse.X - resizer.AbsolutePosition.X
				local offY = mouse.Y - resizer.AbsolutePosition.Y

				side.Resizing = resizer
				resizer.BackgroundColor3 = theme.MainColor2

				releaseEvent = UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						releaseEvent:Disconnect()
						mouseEvent:Disconnect()
						side.Resizing = false
						resizer.BackgroundColor3 = theme.Button
					end
				end)

				mouseEvent = UserInputService.InputChanged:Connect(function(input)
					if not resizer.Parent then
						releaseEvent:Disconnect()
						mouseEvent:Disconnect()
						side.Resizing = false
						return
					end
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if dir == "V" then
							local delta = input.Position.Y - resizer.AbsolutePosition.Y - offY

							if delta > 0 then
								local neededSize = delta
								for i = pos + 1, #windows do
									local window = windows[i]
									local newSize = math.max(window.SizeY - neededSize, (window.MinY or 100))
									neededSize = neededSize - (window.SizeY - newSize)
									window.SizeY = newSize
								end
								windows[pos].SizeY = windows[pos].SizeY + math.max(0, delta - neededSize)
							else
								local neededSize = -delta
								for i = pos, 1, -1 do
									local window = windows[i]
									local newSize = math.max(window.SizeY - neededSize, (window.MinY or 100))
									neededSize = neededSize - (window.SizeY - newSize)
									window.SizeY = newSize
								end
								windows[pos + 1].SizeY = windows[pos + 1].SizeY + math.max(0, -delta - neededSize)
							end

							updateSideFrames()
							sideResized(side)
						elseif dir == "H" then
							local maxWidth = math.max(300, sidesGui.AbsoluteSize.X - static.FreeWidth)
							local otherSide = (side == leftSide and rightSide or leftSide)
							local delta = input.Position.X - resizer.AbsolutePosition.X - offX
							delta = (side == leftSide and delta or -delta)

							local proposedSize = math.max(static.MinWidth, side.Width + delta)
							if proposedSize + otherSide.Width <= maxWidth then
								side.Width = proposedSize
							else
								local newOtherSize = maxWidth - proposedSize
								if newOtherSize >= static.MinWidth then
									side.Width = proposedSize
									otherSide.Width = newOtherSize
								else
									side.Width = maxWidth - static.MinWidth
									otherSide.Width = static.MinWidth
								end
							end

							updateSideFrames(true)
							sideResized(side)
							sideResized(otherSide)
						end
					end
				end)
			end
		end
	end)

	resizer.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and side.Resizing ~= resizer then
			resizer.BackgroundColor3 = theme.Button
		end
	end)
end

local function renderSide(side, noTween) -- TODO: Use existing resizers
	local currentPos = 0
	local sideFramePos = getSideFramePos(side)
	local template = side.WindowResizer:Clone()
	for i, v in pairs(side.ResizeCons) do
		v:Disconnect()
	end
	for i, v in pairs(side.Frame:GetChildren()) do
		if v.Name == "WindowResizer" then
			v:Destroy()
		end
	end
	side.ResizeCons = {}
	side.Resizing = nil

	for i, v in pairs(side.Windows) do
		v.SidePos = i
		local isEnd = i == #side.Windows
		local size = UDim2.new(0, side.Width, 0, v.SizeY)
		local pos = UDim2.new(sideFramePos.X.Scale, sideFramePos.X.Offset, 0, currentPos)
		Lib.ShowGui(v.Gui)
		if noTween then
			v.GuiElems.Main.Size = size
			v.GuiElems.Main.Position = pos
		else
			local tween = TweenService:Create(v.GuiElems.Main, sideTweenInfo, { Size = size, Position = pos })
			tweens[#tweens + 1] = tween
			tween:Play()
		end
		currentPos = currentPos + v.SizeY + 4

		if not isEnd then
			local newTemplate = template:Clone()
			newTemplate.Position = UDim2.new(1, -side.Width, 0, currentPos - 4)
			side.ResizeCons[#side.ResizeCons + 1] = v.Gui.Main:GetPropertyChangedSignal("Size"):Connect(function()
				newTemplate.Position =
					UDim2.new(1, -side.Width, 0, v.GuiElems.Main.Position.Y.Offset + v.GuiElems.Main.Size.Y.Offset)
			end)
			side.ResizeCons[#side.ResizeCons + 1] = v.Gui.Main:GetPropertyChangedSignal("Position"):Connect(function()
				newTemplate.Position =
					UDim2.new(1, -side.Width, 0, v.GuiElems.Main.Position.Y.Offset + v.GuiElems.Main.Size.Y.Offset)
			end)
			sideResizerHook(newTemplate, "V", side, i)
			newTemplate.Parent = side.Frame
		end
	end
end

local function updateSide(side, noTween)
	local oldHeight = 0
	local currentPos = 0
	local neededSize = 0
	local windows = side.Windows
	local height = sidesGui.AbsoluteSize.Y - (math.max(0, #windows - 1) * 4)

	for i, v in pairs(windows) do
		oldHeight = oldHeight + v.SizeY
	end
	for i, v in pairs(windows) do
		if i == #windows then
			v.SizeY = height - currentPos
			neededSize = math.max(0, (v.MinY or 100) - v.SizeY)
		else
			v.SizeY = math.max(math.floor(v.SizeY / oldHeight * height), v.MinY or 100)
		end
		currentPos = currentPos + v.SizeY
	end

	if neededSize > 0 then
		for i = #windows - 1, 1, -1 do
			local window = windows[i]
			local newSize = math.max(window.SizeY - neededSize, (window.MinY or 100))
			neededSize = neededSize - (window.SizeY - newSize)
			window.SizeY = newSize
		end
		local lastWindow = windows[#windows]
		lastWindow.SizeY = (lastWindow.MinY or 100) - neededSize
	end
	renderSide(side, noTween)
end

updateWindows = function(noTween)
	updateSideFrames(noTween)
	updateSide(leftSide, noTween)
	updateSide(rightSide, noTween)
	local count = 0
	for i = #visibleWindows, 1, -1 do
		visibleWindows[i].Gui.DisplayOrder = displayOrderStart + count
		Lib.ShowGui(visibleWindows[i].Gui)
		count = count + 1
	end
end

funcs.SetMinimized = function(self, set, mode)
	local oldVal = self.Minimized
	local newVal
	if set == nil then
		newVal = not self.Minimized
	else
		newVal = set
	end
	self.Minimized = newVal
	if not mode then
		mode = 1
	end

	local resizeControls = self.GuiElems.ResizeControls
	local minimizeControls = { "North", "NorthEast", "NorthWest", "South", "SouthEast", "SouthWest" }
	for i = 1, #minimizeControls do
		local control = resizeControls:FindFirstChild(minimizeControls[i])
		if control then
			control.Visible = not newVal
		end
	end

	if mode == 1 or mode == 2 then
		self:StopTweens()
		if mode == 1 then
			self.GuiElems.Main:TweenSize(
				UDim2.new(0, self.SizeX, 0, newVal and 20 or self.SizeY),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quart,
				0.25,
				true
			)
		else
			local maxY = sidesGui.AbsoluteSize.Y
			local newPos = UDim2.new(
				0,
				self.PosX,
				0,
				newVal and math.min(maxY - 20, self.PosY + self.SizeY - 20) or math.max(0, self.PosY - self.SizeY + 20)
			)

			self.GuiElems.Main:TweenPosition(newPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
			self.GuiElems.Main:TweenSize(
				UDim2.new(0, self.SizeX, 0, newVal and 20 or self.SizeY),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quart,
				0.25,
				true
			)
		end
		self.GuiElems.Minimize.ImageLabel.Image = newVal and "rbxassetid://5060023708" or "rbxassetid://5034768003"
	end

	if oldVal ~= newVal then
		if newVal then
			self.OnMinimize:Fire()
		else
			self.OnRestore:Fire()
		end
	end
end

funcs.Resize = function(self, sizeX, sizeY)
	self.SizeX = sizeX or self.SizeX
	self.SizeY = sizeY or self.SizeY
	self.GuiElems.Main.Size = UDim2.new(0, self.SizeX, 0, self.SizeY)
end

funcs.SetSize = funcs.Resize

funcs.SetTitle = function(self, title)
	self.GuiElems.Title.Text = title
end

funcs.SetResizable = function(self, val)
	self.Resizable = val
	self.GuiElems.ResizeControls.Visible = self.Resizable and self.ResizableInternal
end

funcs.SetResizableInternal = function(self, val)
	self.ResizableInternal = val
	self.GuiElems.ResizeControls.Visible = self.Resizable and self.ResizableInternal
end

funcs.SetAligned = function(self, val)
	self.Aligned = val
	self:SetResizableInternal(not val)
	self.GuiElems.Main.Active = not val
	self.GuiElems.Main.Outlines.Visible = not val
	if not val then
		for i, v in pairs(leftSide.Windows) do
			if v == self then
				table.remove(leftSide.Windows, i)
				break
			end
		end
		for i, v in pairs(rightSide.Windows) do
			if v == self then
				table.remove(rightSide.Windows, i)
				break
			end
		end
		if not table.find(visibleWindows, self) then
			table.insert(visibleWindows, 1, self)
		end
		self.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://5034768003"
		self.Side = nil
		updateWindows()
	else
		self:SetMinimized(false, 3)
		for i, v in pairs(visibleWindows) do
			if v == self then
				table.remove(visibleWindows, i)
				break
			end
		end
		self.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://5448127505"
	end
end

funcs.Add = function(self, obj, name)
	if type(obj) == "table" and obj.Gui and obj.Gui:IsA("GuiObject") then
		obj.Gui.Parent = self.ContentPane
	else
		obj.Parent = self.ContentPane
	end
	if name then
		self.Elements[name] = obj
	end
end

funcs.GetElement = function(self, obj, name)
	return self.Elements[name]
end

funcs.AlignTo = function(self, side, pos, size, silent)
	if table.find(side.Windows, self) or self.Closed then
		return
	end

	size = size or self.SizeY
	if size > 0 and size <= 1 then
		local totalSideHeight = 0
		for i, v in pairs(side.Windows) do
			totalSideHeight = totalSideHeight + v.SizeY
		end
		self.SizeY = (totalSideHeight > 0 and totalSideHeight * size * 2) or size
	else
		self.SizeY = (size > 0 and size or 100)
	end

	self:SetAligned(true)
	self.Side = side
	self.SizeX = side.Width
	self.Gui.DisplayOrder = sideDisplayOrder + 1
	for i, v in pairs(side.Windows) do
		v.Gui.DisplayOrder = sideDisplayOrder
	end
	pos = math.min(#side.Windows + 1, pos or 1)
	self.SidePos = pos
	table.insert(side.Windows, pos, self)

	if not silent then
		side.Hidden = false
	end
	updateWindows(silent)
end

funcs.Close = function(self)
	self.Closed = true
	self:SetResizableInternal(false)

	Lib.FindAndRemove(leftSide.Windows, self)
	Lib.FindAndRemove(rightSide.Windows, self)
	Lib.FindAndRemove(visibleWindows, self)

	self.MinimizeAnim.Disable()
	self.CloseAnim.Disable()
	self.ClosedSide = self.Side
	self.Side = nil
	self.OnDeactivate:Fire()

	if not self.Aligned then
		self:StopTweens()
		local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local closeTime = tick()
		self.LastClose = closeTime

		self:DoTween(self.GuiElems.Main, ti, { Size = UDim2.new(0, self.SizeX, 0, 20) })
		self:DoTween(self.GuiElems.Title, ti, { TextTransparency = 1 })
		self:DoTween(self.GuiElems.Minimize.ImageLabel, ti, { ImageTransparency = 1 })
		self:DoTween(self.GuiElems.Close.ImageLabel, ti, { ImageTransparency = 1 })
		Lib.FastWait(0.2)
		if closeTime ~= self.LastClose then
			return
		end

		self:DoTween(self.GuiElems.TopBar, ti, { BackgroundTransparency = 1 })
		self:DoTween(self.GuiElems.Outlines, ti, { ImageTransparency = 1 })
		Lib.FastWait(0.2)
		if closeTime ~= self.LastClose then
			return
		end
	end

	self.Aligned = false
	self.Gui.Parent = nil
	updateWindows(true)
end

funcs.Hide = funcs.Close

funcs.IsVisible = function(self)
	return not self.Closed and ((self.Side and not self.Side.Hidden) or not self.Side)
end

funcs.IsContentVisible = function(self)
	return self:IsVisible() and not self.Minimized
end

funcs.Focus = function(self)
	moveToTop(self)
end

funcs.MoveInBoundary = function(self)
	local posX, posY = self.PosX, self.PosY
	local maxX, maxY = sidesGui.AbsoluteSize.X, sidesGui.AbsoluteSize.Y
	posX = math.min(posX, maxX - self.SizeX)
	posY = math.min(posY, maxY - 20)
	self.GuiElems.Main.Position = UDim2.new(0, posX, 0, posY)
end

funcs.DoTween = function(self, ...)
	local tween = TweenService:Create(...)
	self.Tweens[#self.Tweens + 1] = tween
	tween:Play()
end

funcs.StopTweens = function(self)
	for i, v in pairs(self.Tweens) do
		v:Cancel()
	end
	self.Tweens = {}
end

funcs.Show = function(self, data)
	return static.ShowWindow(self, data)
end

funcs.ShowAndFocus = function(self, data)
	static.ShowWindow(self, data)
	RunService.RenderStepped:Wait()
	self:Focus()
end

static.ShowWindow = function(window, data)
	data = data or {}
	local align = data.Align
	local pos = data.Pos
	local size = data.Size
	local targetSide = (align == "left" and leftSide) or (align == "right" and rightSide)

	if not window.Closed then
		if not window.Aligned then
			window:SetMinimized(false)
		elseif window.Side and not data.Silent then
			static.SetSideVisible(window.Side, true)
		end
		return
	end

	window.Closed = false
	window.LastClose = tick()
	window.GuiElems.Title.TextTransparency = 0
	window.GuiElems.Minimize.ImageLabel.ImageTransparency = 0
	window.GuiElems.Close.ImageLabel.ImageTransparency = 0
	window.GuiElems.TopBar.BackgroundTransparency = 0
	window.GuiElems.Outlines.ImageTransparency = 0
	window.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://5034768003"
	window.GuiElems.Main.Active = true
	window.GuiElems.Main.Outlines.Visible = true
	window:SetMinimized(false, 3)
	window:SetResizableInternal(true)
	window.MinimizeAnim.Enable()
	window.CloseAnim.Enable()

	if align then
		window:AlignTo(targetSide, pos, size, data.Silent)
	else
		if align == nil and window.ClosedSide then -- Regular open
			window:AlignTo(window.ClosedSide, window.SidePos, size, true)
			static.SetSideVisible(window.ClosedSide, true)
		else
			if table.find(visibleWindows, window) then
				return
			end

			-- TODO: make better
			window.GuiElems.Main.Size = UDim2.new(0, window.SizeX, 0, 20)
			local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			window:StopTweens()
			window:DoTween(window.GuiElems.Main, ti, { Size = UDim2.new(0, window.SizeX, 0, window.SizeY) })

			window.SizeY = size or window.SizeY
			table.insert(visibleWindows, 1, window)
			updateWindows()
		end
	end

	window.ClosedSide = nil
	window.OnActivate:Fire()
end

static.ToggleSide = function(name)
	local side = (name == "left" and leftSide or rightSide)
	side.Hidden = not side.Hidden
	for i, v in pairs(side.Windows) do
		if side.Hidden then
			v.OnDeactivate:Fire()
		else
			v.OnActivate:Fire()
		end
	end
	updateWindows()
end

static.SetSideVisible = function(s, vis)
	local side = (type(s) == "table" and s) or (s == "left" and leftSide or rightSide)
	side.Hidden = not vis
	for i, v in pairs(side.Windows) do
		if side.Hidden then
			v.OnDeactivate:Fire()
		else
			v.OnActivate:Fire()
		end
	end
	updateWindows()
end

static.Init = function()
	displayOrderStart = Main.DisplayOrders.Window
	sideDisplayOrder = Main.DisplayOrders.SideWindow

	sidesGui = Instance.new("ScreenGui")
	local leftFrame = create({
		{
			1,
			"Frame",
			{
				Active = true,
				Name = "LeftSide",
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				BorderSizePixel = 0,
			},
		},
		{
			2,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2549019753933, 0.2549019753933, 0.2549019753933),
				BorderSizePixel = 0,
				Font = 3,
				Name = "Resizer",
				Parent = { 1 },
				Size = UDim2.new(0, 5, 1, 0),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			3,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 2 },
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 1, 1, 0),
			},
		},
		{
			4,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2549019753933, 0.2549019753933, 0.2549019753933),
				BorderSizePixel = 0,
				Font = 3,
				Name = "WindowResizer",
				Parent = { 1 },
				Position = UDim2.new(1, -300, 0, 0),
				Size = UDim2.new(1, 0, 0, 4),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			5,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 4 },
				Size = UDim2.new(1, 0, 0, 1),
			},
		},
	})
	leftSide.Frame = leftFrame
	leftFrame.Position = UDim2.new(0, -leftSide.Width - 10, 0, 0)
	leftSide.WindowResizer = leftFrame.WindowResizer
	leftFrame.WindowResizer.Parent = nil
	leftFrame.Parent = sidesGui

	local rightFrame = create({
		{
			1,
			"Frame",
			{
				Active = true,
				Name = "RightSide",
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				BorderSizePixel = 0,
			},
		},
		{
			2,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2549019753933, 0.2549019753933, 0.2549019753933),
				BorderSizePixel = 0,
				Font = 3,
				Name = "Resizer",
				Parent = { 1 },
				Size = UDim2.new(0, 5, 1, 0),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			3,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 2 },
				Position = UDim2.new(0, 4, 0, 0),
				Size = UDim2.new(0, 1, 1, 0),
			},
		},
		{
			4,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2549019753933, 0.2549019753933, 0.2549019753933),
				BorderSizePixel = 0,
				Font = 3,
				Name = "WindowResizer",
				Parent = { 1 },
				Position = UDim2.new(1, -300, 0, 0),
				Size = UDim2.new(1, 0, 0, 4),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			5,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 4 },
				Size = UDim2.new(1, 0, 0, 1),
			},
		},
	})
	rightSide.Frame = rightFrame
	rightFrame.Position = UDim2.new(1, 10, 0, 0)
	rightSide.WindowResizer = rightFrame.WindowResizer
	rightFrame.WindowResizer.Parent = nil
	rightFrame.Parent = sidesGui

	sideResizerHook(leftFrame.Resizer, "H", leftSide)
	sideResizerHook(rightFrame.Resizer, "H", rightSide)

	alignIndicator = Instance.new("ScreenGui")
	alignIndicator.DisplayOrder = Main.DisplayOrders.Core
	local indicator = Instance.new("Frame", alignIndicator)
	indicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	indicator.BorderSizePixel = 0
	indicator.BackgroundTransparency = 0.8
	indicator.Name = "Indicator"
	local corner = Instance.new("UICorner", indicator)
	corner.CornerRadius = UDim.new(0, 10)

	local leftToggle = create({
		{
			1,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394),
				BorderColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462),
				BorderMode = 2,
				Font = 10,
				Name = "LeftToggle",
				Position = UDim2.new(0, 0, 0, -36),
				Size = UDim2.new(0, 16, 0, 36),
				Text = "<",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
			},
		},
	})
	local rightToggle = leftToggle:Clone()
	rightToggle.Name = "RightToggle"
	rightToggle.Position = UDim2.new(1, -16, 0, -36)
	Lib.ButtonAnim(leftToggle, { Mode = 2, PressColor = Color3.fromRGB(32, 32, 32) })
	Lib.ButtonAnim(rightToggle, { Mode = 2, PressColor = Color3.fromRGB(32, 32, 32) })

	leftToggle.MouseButton1Click:Connect(function()
		static.ToggleSide("left")
	end)

	rightToggle.MouseButton1Click:Connect(function()
		static.ToggleSide("right")
	end)

	leftToggle.Parent = sidesGui
	rightToggle.Parent = sidesGui

	sidesGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local maxWidth = math.max(300, sidesGui.AbsoluteSize.X - static.FreeWidth)
		leftSide.Width = math.max(static.MinWidth, math.min(leftSide.Width, maxWidth - rightSide.Width))
		rightSide.Width = math.max(static.MinWidth, math.min(rightSide.Width, maxWidth - leftSide.Width))
		for i = 1, #visibleWindows do
			visibleWindows[i]:MoveInBoundary()
		end
		updateWindows(true)
	end)

	sidesGui.DisplayOrder = sideDisplayOrder - 1
	Lib.ShowGui(sidesGui)
	updateSideFrames()
end

local mt = { __index = funcs }
static.new = function()
	local obj = setmetatable({
		Minimized = false,
		Dragging = false,
		Resizing = false,
		Aligned = false,
		Draggable = true,
		Resizable = true,
		ResizableInternal = true,
		Alignable = true,
		Closed = true,
		SizeX = 300,
		SizeY = 300,
		MinX = 200,
		MinY = 200,
		PosX = 0,
		PosY = 0,
		GuiElems = {},
		Tweens = {},
		Elements = {},
		OnActivate = Signal.new(),
		OnDeactivate = Signal.new(),
		OnMinimize = Signal.new(),
		OnRestore = Signal.new(),
	}, mt)
	obj.Gui = createGui(obj)
	return obj
end

return static
