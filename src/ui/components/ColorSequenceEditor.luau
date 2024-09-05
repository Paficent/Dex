local Signal = require(script.Parent.Parent.Parent.packages.Signal)

local Lib, create = shared.Apps.Lib, shared.create

-- TODO: Convert to newer class model
local function new()
	local newMt = setmetatable({}, {})
	newMt.OnSelect = Signal.new()
	newMt.OnCancel = Signal.new()
	newMt.OnPreview = Signal.new()
	newMt.OnPickColor = Signal.new()

	local guiContents = create({
		{
			1,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Name = "Content",
				Position = UDim2.new(0, 0, 0, 20),
				Size = UDim2.new(1, 0, 1, -20),
			},
		},
		{
			2,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Name = "ColorLine",
				Parent = { 1 },
				Position = UDim2.new(0, 10, 0, 5),
				Size = UDim2.new(1, -20, 0, 70),
			},
		},
		{
			3,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Name = "Gradient",
				Parent = { 2 },
				Size = UDim2.new(1, 0, 1, 0),
			},
		},
		{ 4, "UIGradient", { Parent = { 3 } } },
		{
			5,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "Arrows",
				Parent = { 1 },
				Position = UDim2.new(0, 1, 0, 73),
				Size = UDim2.new(1, -2, 0, 16),
			},
		},
		{
			6,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0,
				Name = "Cursor",
				Parent = { 1 },
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(0, 1, 0, 80),
			},
		},
		{
			7,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Time",
				Parent = { 1 },
				Position = UDim2.new(0, 40, 0, 95),
				Size = UDim2.new(0, 100, 0, 20),
			},
		},
		{
			8,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				ClipsDescendants = true,
				Font = 3,
				Name = "Input",
				Parent = { 7 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 98, 0, 20),
				Text = "0",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			9,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 7 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Time",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			10,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Name = "ColorBox",
				Parent = { 1 },
				Position = UDim2.new(0, 220, 0, 95),
				Size = UDim2.new(0, 20, 0, 20),
			},
		},
		{
			11,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 10 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Color",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			12,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				BorderSizePixel = 0,
				Font = 3,
				Name = "Close",
				Parent = { 1 },
				Position = UDim2.new(1, -90, 0, 95),
				Size = UDim2.new(0, 80, 0, 20),
				Text = "Close",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
			},
		},
		{
			13,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				BorderSizePixel = 0,
				Font = 3,
				Name = "Reset",
				Parent = { 1 },
				Position = UDim2.new(1, -180, 0, 95),
				Size = UDim2.new(0, 80, 0, 20),
				Text = "Reset",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
			},
		},
		{
			14,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				BorderSizePixel = 0,
				Font = 3,
				Name = "Delete",
				Parent = { 1 },
				Position = UDim2.new(0, 280, 0, 95),
				Size = UDim2.new(0, 80, 0, 20),
				Text = "Delete",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
			},
		},
		{
			15,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 1 },
				Size = UDim2.new(0, 16, 0, 16),
				Visible = false,
			},
		},
		{
			16,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 15 },
				Position = UDim2.new(0, 8, 0, 3),
				Size = UDim2.new(0, 1, 0, 2),
			},
		},
		{
			17,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 15 },
				Position = UDim2.new(0, 7, 0, 5),
				Size = UDim2.new(0, 3, 0, 2),
			},
		},
		{
			18,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 15 },
				Position = UDim2.new(0, 6, 0, 7),
				Size = UDim2.new(0, 5, 0, 2),
			},
		},
		{
			19,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 15 },
				Position = UDim2.new(0, 5, 0, 9),
				Size = UDim2.new(0, 7, 0, 2),
			},
		},
		{
			20,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 15 },
				Position = UDim2.new(0, 4, 0, 11),
				Size = UDim2.new(0, 9, 0, 2),
			},
		},
	})
	local window = Lib.Window.new()
	window.Resizable = false
	window:Resize(650, 150)
	window:SetTitle("ColorSequence Editor")
	newMt.Window = window
	newMt.Gui = window.Gui
	for i, v in guiContents:GetChildren() do
		v.Parent = window.GuiElems.Content
	end
	local gui = window.Gui
	local pickerGui = gui.Main
	local pickerTopBar = pickerGui.TopBar
	local pickerFrame = pickerGui.Content
	local colorLine = pickerFrame.ColorLine
	local gradient = colorLine.Gradient.UIGradient
	local arrowFrame = pickerFrame.Arrows
	local arrow = pickerFrame.Arrow
	local cursor = pickerFrame.Cursor
	local timeBox = pickerFrame.Time.Input
	local colorBox = pickerFrame.ColorBox
	local deleteButton = pickerFrame.Delete
	local resetButton = pickerFrame.Reset
	local closeButton = pickerFrame.Close
	local topClose = pickerTopBar.Close

	local user = game:GetService("UserInputService")
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()

	local colors = {
		{ Color3.new(1, 0, 1), 0 },
		{ Color3.new(0.2, 0.9, 0.2), 0.2 },
		{ Color3.new(0.4, 0.5, 0.9), 0.7 },
		{ Color3.new(0.6, 1, 1), 1 },
	}
	local resetSequence = nil

	local beginPoint = colors[1]
	local endPoint = colors[#colors]

	local currentlySelected = nil
	local currentPoint = nil

	local sequenceLine = Instance.new("Frame")
	sequenceLine.BorderSizePixel = 0
	sequenceLine.Size = UDim2.new(0, 1, 1, 0)

	newMt.Sequence = ColorSequence.new(Color3.new(1, 1, 1))
	local function buildSequence(noupdate)
		local newPoints = {}
		table.sort(colors, function(a, b)
			return a[2] < b[2]
		end)
		for i, v in colors do
			table.insert(newPoints, ColorSequenceKeypoint.new(v[2], v[1]))
		end
		newMt.Sequence = ColorSequence.new(newPoints)
		if not noupdate then
			newMt.OnSelect:Fire(newMt.Sequence)
		end
	end

	local function round(num, places)
		local multi = 10 ^ places
		return math.floor(num * multi + 0.5) / multi
	end

	local function updateInputs(point)
		if point then
			currentPoint = point
			local raw = point[2]
			timeBox.Text = round(raw, (raw < 0.01 and 5) or (raw < 0.1 and 4) or 3)
			colorBox.BackgroundColor3 = point[1]
		end
	end

	local function placeArrow(ind, point)
		local newArrow = arrow:Clone()
		newArrow.Position = UDim2.new(0, ind - 1, 0, 0)
		newArrow.Visible = true
		newArrow.Parent = arrowFrame

		newArrow.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				cursor.Visible = true
				cursor.Position = UDim2.new(0, 9 + newArrow.Position.X.Offset, 0, 0)
			end
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				updateInputs(point)
				if point == beginPoint or point == endPoint or currentlySelected then
					return
				end

				local mouseEvent, releaseEvent
				currentlySelected = true

				releaseEvent = user.InputEnded:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end
					mouseEvent:Disconnect()
					releaseEvent:Disconnect()
					currentlySelected = nil
					cursor.Visible = false
				end)

				mouseEvent = user.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local maxSize = colorLine.AbsoluteSize.X - 1
						local relativeX = mouse.X - colorLine.AbsolutePosition.X
						if relativeX < 0 then
							relativeX = 0
						end
						if relativeX > maxSize then
							relativeX = maxSize
						end
						point[2] = relativeX / maxSize
						updateInputs(point)
						cursor.Visible = true
						cursor.Position = UDim2.new(0, 9 + newArrow.Position.X.Offset, 0, 0)
						buildSequence()
						newMt:Redraw()
					end
				end)
			end
		end)

		newArrow.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				cursor.Visible = false
			end
		end)

		return newArrow
	end

	local function placeArrows()
		for i, v in colors do
			v[3] = placeArrow(math.floor((colorLine.AbsoluteSize.X - 1) * v[2]) + 1, v)
		end
	end

	local function redraw(self)
		gradient.Color = newMt.Sequence or ColorSequence.new(Color3.new(1, 1, 1))

		for i = 2, #colors do
			local nextColor = colors[i]
			local endPos = math.floor((colorLine.AbsoluteSize.X - 1) * nextColor[2]) + 1
			nextColor[3].Position = UDim2.new(0, endPos, 0, 0)
		end
	end
	newMt.Redraw = redraw

	local function loadSequence(self, seq)
		resetSequence = seq
		for i, v in colors do
			if v[3] then
				v[3]:Destroy()
			end
		end
		colors = {}
		currentlySelected = nil
		for i, v in seq.Keypoints do
			local newPoint = { v.Value, v.Time }
			newPoint[3] = placeArrow(v.Time, newPoint)
			table.insert(colors, newPoint)
		end
		beginPoint = colors[1]
		endPoint = colors[#colors]
		currentlySelected = nil
		updateInputs(colors[1])
		buildSequence(true)
		redraw()
	end
	newMt.SetSequence = loadSequence

	local function buttonAnimations(button, inverse)
		button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				button.BackgroundTransparency = (inverse and 0.5 or 0.4)
			end
		end)
		button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				button.BackgroundTransparency = (inverse and 1 or 0)
			end
		end)
	end

	colorLine.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and #colors < 20 then
			local maxSize = colorLine.AbsoluteSize.X - 1
			local relativeX = mouse.X - colorLine.AbsolutePosition.X
			if relativeX < 0 then
				relativeX = 0
			end
			if relativeX > maxSize then
				relativeX = maxSize
			end

			local raw = relativeX / maxSize
			local fromColor = nil
			local toColor = nil
			for i, col in colors do
				if col[2] >= raw then
					fromColor = colors[math.max(i - 1, 1)]
					toColor = colors[i]
					break
				end
			end
			local lerpColor = fromColor[1]:lerp(toColor[1], (raw - fromColor[2]) / (toColor[2] - fromColor[2]))
			local newPoint = { lerpColor, raw }
			newPoint[3] = placeArrow(newPoint[2], newPoint)
			table.insert(colors, newPoint)
			updateInputs(newPoint)
			buildSequence()
			redraw()
		end
	end)

	colorLine.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local maxSize = colorLine.AbsoluteSize.X - 1
			local relativeX = mouse.X - colorLine.AbsolutePosition.X
			if relativeX < 0 then
				relativeX = 0
			end
			if relativeX > maxSize then
				relativeX = maxSize
			end
			cursor.Visible = true
			cursor.Position = UDim2.new(0, 10 + relativeX, 0, 0)
		end
	end)

	colorLine.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local inArrow = false
			for i, v in colors do
				if Lib.CheckMouseInGui(v[3]) then
					inArrow = v[3]
				end
			end
			cursor.Visible = inArrow and true or false
			if inArrow then
				cursor.Position = UDim2.new(0, 9 + inArrow.Position.X.Offset, 0, 0)
			end
		end
	end)

	timeBox:GetPropertyChangedSignal("Text"):Connect(function()
		local point = currentPoint
		local num = tonumber(timeBox.Text)
		if point and num and point ~= beginPoint and point ~= endPoint then
			num = math.clamp(num, 0, 1)
			point[2] = num
			buildSequence()
			redraw()
		end
	end)

	colorBox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local editor = newMt.ColorPicker
			if not editor then
				editor = Lib.ColorPicker.new()
				editor.Window:SetTitle("ColorSequence Color Picker")

				editor.OnSelect:Connect(function(col)
					if currentPoint then
						currentPoint[1] = col
					end
					buildSequence()
					redraw()
				end)

				newMt.ColorPicker = editor
			end

			editor.Window:ShowAndFocus()
		end
	end)

	deleteButton.MouseButton1Click:Connect(function()
		if currentPoint and currentPoint ~= beginPoint and currentPoint ~= endPoint then
			for i, v in colors do
				if v == currentPoint then
					v[3]:Destroy()
					table.remove(colors, i)
					break
				end
			end
			currentlySelected = nil
			updateInputs(colors[1])
			buildSequence()
			redraw()
		end
	end)

	resetButton.MouseButton1Click:Connect(function()
		if resetSequence then
			newMt:SetSequence(resetSequence)
		end
	end)

	closeButton.MouseButton1Click:Connect(function()
		window:Close()
	end)

	topClose.MouseButton1Click:Connect(function()
		window:Close()
	end)

	buttonAnimations(deleteButton)
	buttonAnimations(resetButton)
	buttonAnimations(closeButton)

	placeArrows()
	redraw()

	newMt.Show = function(self)
		window:Show()
	end

	return newMt
end

return { new = new }
