local Signal = require(script.Parent.Parent.Parent.packages.Signal)

local create, Lib = shared.create, shared.Apps.Lib

local function new() -- TODO: Convert to newer class model
	local newMt = setmetatable({}, {})
	newMt.OnSelect = Signal.new()
	newMt.OnCancel = Signal.new()
	newMt.OnPreview = Signal.new()

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
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Time",
				Parent = { 1 },
				Position = UDim2.new(0, 40, 0, 210),
				Size = UDim2.new(0, 60, 0, 20),
			},
		},
		{
			3,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				ClipsDescendants = true,
				Font = 3,
				Name = "Input",
				Parent = { 2 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 58, 0, 20),
				Text = "0",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			4,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 2 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Time",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			5,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Font = 3,
				Name = "Close",
				Parent = { 1 },
				Position = UDim2.new(1, -90, 0, 210),
				Size = UDim2.new(0, 80, 0, 20),
				Text = "Close",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
			},
		},
		{
			6,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Font = 3,
				Name = "Reset",
				Parent = { 1 },
				Position = UDim2.new(1, -180, 0, 210),
				Size = UDim2.new(0, 80, 0, 20),
				Text = "Reset",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
			},
		},
		{
			7,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Font = 3,
				Name = "Delete",
				Parent = { 1 },
				Position = UDim2.new(0, 380, 0, 210),
				Size = UDim2.new(0, 80, 0, 20),
				Text = "Delete",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
			},
		},
		{
			8,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Name = "NumberLineOutlines",
				Parent = { 1 },
				Position = UDim2.new(0, 10, 0, 20),
				Size = UDim2.new(1, -20, 0, 170),
			},
		},
		{
			9,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				Name = "NumberLine",
				Parent = { 1 },
				Position = UDim2.new(0, 10, 0, 20),
				Size = UDim2.new(1, -20, 0, 170),
			},
		},
		{
			10,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Value",
				Parent = { 1 },
				Position = UDim2.new(0, 170, 0, 210),
				Size = UDim2.new(0, 60, 0, 20),
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
				Text = "Value",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			12,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				ClipsDescendants = true,
				Font = 3,
				Name = "Input",
				Parent = { 10 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 58, 0, 20),
				Text = "0",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			13,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Envelope",
				Parent = { 1 },
				Position = UDim2.new(0, 300, 0, 210),
				Size = UDim2.new(0, 60, 0, 20),
			},
		},
		{
			14,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				ClipsDescendants = true,
				Font = 3,
				Name = "Input",
				Parent = { 13 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 58, 0, 20),
				Text = "0",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			15,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 13 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Envelope",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
	})
	local window = Lib.Window.new()
	window.Resizable = false
	window:Resize(680, 265)
	window:SetTitle("NumberSequence Editor")
	newMt.Window = window
	newMt.Gui = window.Gui
	for _, v in guiContents:GetChildren() do
		v.Parent = window.GuiElems.Content
	end
	local gui = window.Gui
	local pickerGui = gui.Main
	local pickerFrame = pickerGui.Content
	local numberLine = pickerFrame.NumberLine
	local numberLineOutlines = pickerFrame.NumberLineOutlines
	local timeBox = pickerFrame.Time.Input
	local valueBox = pickerFrame.Value.Input
	local envelopeBox = pickerFrame.Envelope.Input
	local deleteButton = pickerFrame.Delete
	local resetButton = pickerFrame.Reset
	local closeButton = pickerFrame.Close

	local points = { { 1, 0, 3 }, { 8, 0.05, 1 }, { 5, 0.6, 2 }, { 4, 0.7, 4 }, { 6, 1, 4 } }
	local lines = {}
	local eLines = {}
	local beginPoint = points[1]
	local endPoint = points[#points]
	local currentlySelected = nil
	local currentPoint = nil
	local resetSequence = nil

	local user = game:GetService("UserInputService")
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()

	for i = 2, 10 do
		local newLine = Instance.new("Frame")
		newLine.BackgroundTransparency = 0.5
		newLine.BackgroundColor3 = Color3.new(96 / 255, 96 / 255, 96 / 255)
		newLine.BorderSizePixel = 0
		newLine.Size = UDim2.new(0, 1, 1, 0)
		newLine.Position = UDim2.new((i - 1) / (11 - 1), 0, 0, 0)
		newLine.Parent = numberLineOutlines
	end

	for i = 2, 4 do
		local newLine = Instance.new("Frame")
		newLine.BackgroundTransparency = 0.5
		newLine.BackgroundColor3 = Color3.new(96 / 255, 96 / 255, 96 / 255)
		newLine.BorderSizePixel = 0
		newLine.Size = UDim2.new(1, 0, 0, 1)
		newLine.Position = UDim2.new(0, 0, (i - 1) / (5 - 1), 0)
		newLine.Parent = numberLineOutlines
	end

	local lineTemp = Instance.new("Frame")
	lineTemp.BackgroundColor3 = Color3.new(0, 0, 0)
	lineTemp.BorderSizePixel = 0
	lineTemp.Size = UDim2.new(0, 1, 0, 1)

	local sequenceLine = Instance.new("Frame")
	sequenceLine.BackgroundColor3 = Color3.new(0, 0, 0)
	sequenceLine.BorderSizePixel = 0
	sequenceLine.Size = UDim2.new(0, 1, 0, 0)

	for i = 1, numberLine.AbsoluteSize.X do
		local line = sequenceLine:Clone()
		eLines[i] = line
		line.Name = "E" .. tostring(i)
		line.BackgroundTransparency = 0.5
		line.BackgroundColor3 = Color3.new(199 / 255, 44 / 255, 28 / 255)
		line.Position = UDim2.new(0, i - 1, 0, 0)
		line.Parent = numberLine
	end

	for i = 1, numberLine.AbsoluteSize.X do
		local line = sequenceLine:Clone()
		lines[i] = line
		line.Name = tostring(i)
		line.Position = UDim2.new(0, i - 1, 0, 0)
		line.Parent = numberLine
	end

	local envelopeDrag = Instance.new("Frame")
	envelopeDrag.BackgroundTransparency = 1
	envelopeDrag.BackgroundColor3 = Color3.new(0, 0, 0)
	envelopeDrag.BorderSizePixel = 0
	envelopeDrag.Size = UDim2.new(0, 7, 0, 20)
	envelopeDrag.Visible = false
	envelopeDrag.ZIndex = 2
	local envelopeDragLine = Instance.new("Frame", envelopeDrag)
	envelopeDragLine.Name = "Line"
	envelopeDragLine.BackgroundColor3 = Color3.new(0, 0, 0)
	envelopeDragLine.BorderSizePixel = 0
	envelopeDragLine.Position = UDim2.new(0, 3, 0, 0)
	envelopeDragLine.Size = UDim2.new(0, 1, 0, 20)
	envelopeDragLine.ZIndex = 2

	local envelopeDragTop, envelopeDragBottom = envelopeDrag:Clone(), envelopeDrag:Clone()
	envelopeDragTop.Parent = numberLine
	envelopeDragBottom.Parent = numberLine

	local function buildSequence()
		local newPoints = {}
		for _, v in points do
			table.insert(newPoints, NumberSequenceKeypoint.new(v[2], v[1], v[3]))
		end
		newMt.Sequence = NumberSequence.new(newPoints)
		newMt.OnSelect:Fire(newMt.Sequence)
	end

	local function round(num, places)
		local multi = 10 ^ places
		return math.floor(num * multi + 0.5) / multi
	end

	local function updateInputs(point)
		if point then
			currentPoint = point
			local rawT, rawV, rawE = point[2], point[1], point[3]
			timeBox.Text = round(rawT, (rawT < 0.01 and 5) or (rawT < 0.1 and 4) or 3)
			valueBox.Text = round(rawV, (rawV < 0.01 and 5) or (rawV < 0.1 and 4) or (rawV < 1 and 3) or 2)
			envelopeBox.Text = round(rawE, (rawE < 0.01 and 5) or (rawE < 0.1 and 4) or (rawV < 1 and 3) or 2)

			local envelopeDistance = numberLine.AbsoluteSize.Y * (point[3] / 10)
			envelopeDragTop.Position =
				UDim2.new(0, point[4].Position.X.Offset - 1, 0, point[4].Position.Y.Offset - envelopeDistance - 17)
			envelopeDragTop.Visible = true
			envelopeDragBottom.Position =
				UDim2.new(0, point[4].Position.X.Offset - 1, 0, point[4].Position.Y.Offset + envelopeDistance + 2)
			envelopeDragBottom.Visible = true
		end
	end

	envelopeDragTop.InputBegan:Connect(function(input)
		if
			input.UserInputType ~= Enum.UserInputType.MouseButton1
			or not currentPoint
			or Lib.CheckMouseInGui(currentPoint[4].Select)
		then
			return
		end
		local mouseEvent, releaseEvent
		local maxSize = numberLine.AbsoluteSize.Y

		local mouseDelta = math.abs(envelopeDragTop.AbsolutePosition.Y - mouse.Y)

		envelopeDragTop.Line.Position = UDim2.new(0, 2, 0, 0)
		envelopeDragTop.Line.Size = UDim2.new(0, 3, 0, 20)

		releaseEvent = user.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			mouseEvent:Disconnect()
			releaseEvent:Disconnect()
			envelopeDragTop.Line.Position = UDim2.new(0, 3, 0, 0)
			envelopeDragTop.Line.Size = UDim2.new(0, 1, 0, 20)
		end)

		mouseEvent = user.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				local topDiff = (currentPoint[4].AbsolutePosition.Y + 2) - (mouse.Y - mouseDelta) - 19
				local newEnvelope = 10 * (math.max(topDiff, 0) / maxSize)
				local maxEnvelope = math.min(currentPoint[1], 10 - currentPoint[1])
				currentPoint[3] = math.min(newEnvelope, maxEnvelope)
				newMt:Redraw()
				buildSequence()
				updateInputs(currentPoint)
			end
		end)
	end)

	envelopeDragBottom.InputBegan:Connect(function(input)
		if
			input.UserInputType ~= Enum.UserInputType.MouseButton1
			or not currentPoint
			or Lib.CheckMouseInGui(currentPoint[4].Select)
		then
			return
		end
		local mouseEvent, releaseEvent
		local maxSize = numberLine.AbsoluteSize.Y

		local mouseDelta = math.abs(envelopeDragBottom.AbsolutePosition.Y - mouse.Y)

		envelopeDragBottom.Line.Position = UDim2.new(0, 2, 0, 0)
		envelopeDragBottom.Line.Size = UDim2.new(0, 3, 0, 20)

		releaseEvent = user.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			mouseEvent:Disconnect()
			releaseEvent:Disconnect()
			envelopeDragBottom.Line.Position = UDim2.new(0, 3, 0, 0)
			envelopeDragBottom.Line.Size = UDim2.new(0, 1, 0, 20)
		end)

		mouseEvent = user.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				local bottomDiff = (mouse.Y + (20 - mouseDelta)) - (currentPoint[4].AbsolutePosition.Y + 2) - 19
				local newEnvelope = 10 * (math.max(bottomDiff, 0) / maxSize)
				local maxEnvelope = math.min(currentPoint[1], 10 - currentPoint[1])
				currentPoint[3] = math.min(newEnvelope, maxEnvelope)
				newMt:Redraw()
				buildSequence()
				updateInputs(currentPoint)
			end
		end)
	end)

	local function placePoint(point)
		local newPoint = Instance.new("Frame")
		newPoint.Name = "Point"
		newPoint.BorderSizePixel = 0
		newPoint.Size = UDim2.new(0, 5, 0, 5)
		newPoint.Position = UDim2.new(
			0,
			math.floor((numberLine.AbsoluteSize.X - 1) * point[2]) - 2,
			0,
			numberLine.AbsoluteSize.Y * (10 - point[1]) / 10 - 2
		)
		newPoint.BackgroundColor3 = Color3.new(0, 0, 0)

		local newSelect = Instance.new("Frame")
		newSelect.Name = "Select"
		newSelect.BackgroundTransparency = 1
		newSelect.BackgroundColor3 = Color3.new(199 / 255, 44 / 255, 28 / 255)
		newSelect.Position = UDim2.new(0, -2, 0, -2)
		newSelect.Size = UDim2.new(0, 9, 0, 9)
		newSelect.Parent = newPoint

		newPoint.Parent = numberLine

		newSelect.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				for i, v in points do
					v[4].Select.BackgroundTransparency = 1
				end
				newSelect.BackgroundTransparency = 0
				updateInputs(point)
			end
			if input.UserInputType == Enum.UserInputType.MouseButton1 and not currentlySelected then
				currentPoint = point
				local mouseEvent, releaseEvent
				currentlySelected = true
				newSelect.BackgroundColor3 = Color3.new(249 / 255, 191 / 255, 59 / 255)

				local oldEnvelope = point[3]

				releaseEvent = user.InputEnded:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end
					mouseEvent:Disconnect()
					releaseEvent:Disconnect()
					currentlySelected = nil
					newSelect.BackgroundColor3 = Color3.new(199 / 255, 44 / 255, 28 / 255)
				end)

				mouseEvent = user.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local maxX = numberLine.AbsoluteSize.X - 1
						local relativeX = mouse.X - numberLine.AbsolutePosition.X
						if relativeX < 0 then
							relativeX = 0
						end
						if relativeX > maxX then
							relativeX = maxX
						end
						local maxY = numberLine.AbsoluteSize.Y - 1
						local relativeY = mouse.Y - numberLine.AbsolutePosition.Y
						if relativeY < 0 then
							relativeY = 0
						end
						if relativeY > maxY then
							relativeY = maxY
						end
						if point ~= beginPoint and point ~= endPoint then
							point[2] = relativeX / maxX
						end
						point[1] = 10 - (relativeY / maxY) * 10
						local maxEnvelope = math.min(point[1], 10 - point[1])
						point[3] = math.min(oldEnvelope, maxEnvelope)
						newMt:Redraw()
						updateInputs(point)
						for i, v in points do
							v[4].Select.BackgroundTransparency = 1
						end
						newSelect.BackgroundTransparency = 0
						buildSequence()
					end
				end)
			end
		end)

		return newPoint
	end

	local function placePoints()
		for i, v in points do
			v[4] = placePoint(v)
		end
	end

	local function redraw(self)
		local numberLineSize = numberLine.AbsoluteSize
		table.sort(points, function(a, b)
			return a[2] < b[2]
		end)
		for i, v in points do
			v[4].Position = UDim2.new(
				0,
				math.floor((numberLineSize.X - 1) * v[2]) - 2,
				0,
				(numberLineSize.Y - 1) * (10 - v[1]) / 10 - 2
			)
		end
		lines[1].Size = UDim2.new(0, 1, 0, 0)
		for i = 1, #points - 1 do
			local fromPoint = points[i]
			local toPoint = points[i + 1]
			local deltaY = toPoint[4].Position.Y.Offset - fromPoint[4].Position.Y.Offset
			local deltaX = toPoint[4].Position.X.Offset - fromPoint[4].Position.X.Offset
			local slope = deltaY / deltaX

			local fromEnvelope = fromPoint[3]
			local nextEnvelope = toPoint[3]

			local currentRise = math.abs(slope)
			local totalRise = 0
			local maxRise = math.abs(toPoint[4].Position.Y.Offset - fromPoint[4].Position.Y.Offset)

			for lineCount = math.min(fromPoint[4].Position.X.Offset + 1, toPoint[4].Position.X.Offset), toPoint[4].Position.X.Offset do
				if deltaX == 0 and deltaY == 0 then
					return
				end
				local riseNow = math.floor(currentRise)
				local line = lines[lineCount + 3]
				if line then
					if totalRise + riseNow > maxRise then
						riseNow = maxRise - totalRise
					end
					if math.sign(slope) == -1 then
						line.Position =
							UDim2.new(0, lineCount + 2, 0, fromPoint[4].Position.Y.Offset + -(totalRise + riseNow) + 2)
					else
						line.Position = UDim2.new(0, lineCount + 2, 0, fromPoint[4].Position.Y.Offset + totalRise + 2)
					end
					line.Size = UDim2.new(0, 1, 0, math.max(riseNow, 1))
				end
				totalRise = totalRise + riseNow
				currentRise = currentRise - riseNow + math.abs(slope)

				local envPercent = (lineCount - fromPoint[4].Position.X.Offset)
					/ (toPoint[4].Position.X.Offset - fromPoint[4].Position.X.Offset)
				local envLerp = fromEnvelope + (nextEnvelope - fromEnvelope) * envPercent
				local relativeSize = (envLerp / 10) * numberLineSize.Y

				line = eLines[lineCount + 3]
				if line then
					line.Position = UDim2.new(
						0,
						lineCount + 2,
						0,
						lines[lineCount + 3].Position.Y.Offset - math.floor(relativeSize)
					)
					line.Size = UDim2.new(0, 1, 0, math.floor(relativeSize * 2))
				end
			end
		end
	end
	newMt.Redraw = redraw

	local function loadSequence(self, seq)
		resetSequence = seq
		for i, v in points do
			if v[4] then
				v[4]:Destroy()
			end
		end
		points = {}
		for i, v in seq.Keypoints do
			local maxEnvelope = math.min(v.Value, 10 - v.Value)
			local newPoint = { v.Value, v.Time, math.min(v.Envelope, maxEnvelope) }
			newPoint[4] = placePoint(newPoint)
			table.insert(points, newPoint)
		end
		beginPoint = points[1]
		endPoint = points[#points]
		currentlySelected = nil
		redraw()
		envelopeDragTop.Visible = false
		envelopeDragBottom.Visible = false
	end
	newMt.SetSequence = loadSequence

	timeBox.FocusLost:Connect(function()
		local point = currentPoint
		local num = tonumber(timeBox.Text)
		if point and num and point ~= beginPoint and point ~= endPoint then
			num = math.clamp(num, 0, 1)
			point[2] = num
			redraw()
			buildSequence()
			updateInputs(point)
		end
	end)

	valueBox.FocusLost:Connect(function()
		local point = currentPoint
		local num = tonumber(valueBox.Text)
		if point and num then
			local oldEnvelope = point[3]
			num = math.clamp(num, 0, 10)
			point[1] = num
			local maxEnvelope = math.min(point[1], 10 - point[1])
			point[3] = math.min(oldEnvelope, maxEnvelope)
			redraw()
			buildSequence()
			updateInputs(point)
		end
	end)

	envelopeBox.FocusLost:Connect(function()
		local point = currentPoint
		local num = tonumber(envelopeBox.Text)
		if point and num then
			num = math.clamp(num, 0, 5)
			local maxEnvelope = math.min(point[1], 10 - point[1])
			point[3] = math.min(num, maxEnvelope)
			redraw()
			buildSequence()
			updateInputs(point)
		end
	end)

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

	numberLine.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and #points < 20 then
			if Lib.CheckMouseInGui(envelopeDragTop) or Lib.CheckMouseInGui(envelopeDragBottom) then
				return
			end
			for _, v in points do
				if Lib.CheckMouseInGui(v[4].Select) then
					return
				end
			end
			local maxX = numberLine.AbsoluteSize.X - 1
			local relativeX = mouse.X - numberLine.AbsolutePosition.X
			if relativeX < 0 then
				relativeX = 0
			end
			if relativeX > maxX then
				relativeX = maxX
			end
			local maxY = numberLine.AbsoluteSize.Y - 1
			local relativeY = mouse.Y - numberLine.AbsolutePosition.Y
			if relativeY < 0 then
				relativeY = 0
			end
			if relativeY > maxY then
				relativeY = maxY
			end

			local raw = relativeX / maxX
			local newPoint = { 10 - (relativeY / maxY) * 10, raw, 0 }
			newPoint[4] = placePoint(newPoint)
			table.insert(points, newPoint)
			redraw()
			buildSequence()
		end
	end)

	deleteButton.MouseButton1Click:Connect(function()
		if currentPoint and currentPoint ~= beginPoint and currentPoint ~= endPoint then
			for i, v in points do
				if v == currentPoint then
					v[4]:Destroy()
					table.remove(points, i)
					break
				end
			end
			currentlySelected = nil
			redraw()
			buildSequence()
			updateInputs(points[1])
		end
	end)

	resetButton.MouseButton1Click:Connect(function()
		if resetSequence then
			newMt:SetSequence(resetSequence)
			buildSequence()
		end
	end)

	closeButton.MouseButton1Click:Connect(function()
		window:Close()
	end)

	buttonAnimations(deleteButton)
	buttonAnimations(resetButton)
	buttonAnimations(closeButton)

	placePoints()
	redraw()

	newMt.Show = function(self)
		window:Show()
	end

	return newMt
end

return { new = new }
