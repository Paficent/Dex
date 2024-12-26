-- TODO: Convert to newer class model
local Signal = require(script.Parent.Parent.Parent.Packages.Signal)

local Lib, create = shared.Apps.Lib, shared.create

local function new()
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
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Name = "BasicColors",
				Parent = { 1 },
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, 180, 0, 200),
			},
		},
		{
			3,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 2 },
				Position = UDim2.new(0, 0, 0, -5),
				Size = UDim2.new(1, 0, 0, 26),
				Text = "Basic Colors",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			4,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Blue",
				Parent = { 1 },
				Position = UDim2.new(1, -63, 0, 255),
				Size = UDim2.new(0, 52, 0, 16),
			},
		},
		{
			5,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				Font = 3,
				Name = "Input",
				Parent = { 4 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 50, 0, 16),
				Text = "0",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			6,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "ArrowFrame",
				Parent = { 5 },
				Position = UDim2.new(1, -16, 0, 0),
				Size = UDim2.new(0, 16, 1, 0),
			},
		},
		{
			7,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Up",
				Parent = { 6 },
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			8,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 7 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			9,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 8 },
				Position = UDim2.new(0, 8, 0, 3),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			10,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 8 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			11,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 8 },
				Position = UDim2.new(0, 6, 0, 5),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			12,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Down",
				Parent = { 6 },
				Position = UDim2.new(0, 0, 0, 8),
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			13,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 12 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			14,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 13 },
				Position = UDim2.new(0, 8, 0, 5),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			15,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 13 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			16,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 13 },
				Position = UDim2.new(0, 6, 0, 3),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			17,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 4 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Blue:",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			18,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Name = "ColorSpaceFrame",
				Parent = { 1 },
				Position = UDim2.new(1, -261, 0, 4),
				Size = UDim2.new(0, 222, 0, 202),
			},
		},
		{
			19,
			"ImageLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				BorderSizePixel = 0,
				Image = "rbxassetid://1072518406",
				Name = "ColorSpace",
				Parent = { 18 },
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(0, 220, 0, 200),
			},
		},
		{
			20,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "Scope",
				Parent = { 19 },
				Position = UDim2.new(0, 210, 0, 190),
				Size = UDim2.new(0, 20, 0, 20),
			},
		},
		{
			21,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 20 },
				Position = UDim2.new(0, 9, 0, 0),
				Size = UDim2.new(0, 2, 0, 20),
			},
		},
		{
			22,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 20 },
				Position = UDim2.new(0, 0, 0, 9),
				Size = UDim2.new(0, 20, 0, 2),
			},
		},
		{
			23,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Name = "CustomColors",
				Parent = { 1 },
				Position = UDim2.new(0, 5, 0, 210),
				Size = UDim2.new(0, 180, 0, 90),
			},
		},
		{
			24,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 23 },
				Size = UDim2.new(1, 0, 0, 20),
				Text = "Custom Colors (RC = Set)",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			25,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Green",
				Parent = { 1 },
				Position = UDim2.new(1, -63, 0, 233),
				Size = UDim2.new(0, 52, 0, 16),
			},
		},
		{
			26,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				Font = 3,
				Name = "Input",
				Parent = { 25 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 50, 0, 16),
				Text = "0",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			27,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "ArrowFrame",
				Parent = { 26 },
				Position = UDim2.new(1, -16, 0, 0),
				Size = UDim2.new(0, 16, 1, 0),
			},
		},
		{
			28,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Up",
				Parent = { 27 },
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			29,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 28 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			30,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 29 },
				Position = UDim2.new(0, 8, 0, 3),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			31,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 29 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			32,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 29 },
				Position = UDim2.new(0, 6, 0, 5),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			33,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Down",
				Parent = { 27 },
				Position = UDim2.new(0, 0, 0, 8),
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			34,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 33 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			35,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 34 },
				Position = UDim2.new(0, 8, 0, 5),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			36,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 34 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			37,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 34 },
				Position = UDim2.new(0, 6, 0, 3),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			38,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 25 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Green:",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			39,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Hue",
				Parent = { 1 },
				Position = UDim2.new(1, -180, 0, 211),
				Size = UDim2.new(0, 52, 0, 16),
			},
		},
		{
			40,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				Font = 3,
				Name = "Input",
				Parent = { 39 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 50, 0, 16),
				Text = "0",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			41,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "ArrowFrame",
				Parent = { 40 },
				Position = UDim2.new(1, -16, 0, 0),
				Size = UDim2.new(0, 16, 1, 0),
			},
		},
		{
			42,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Up",
				Parent = { 41 },
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			43,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 42 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			44,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 43 },
				Position = UDim2.new(0, 8, 0, 3),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			45,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 43 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			46,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 43 },
				Position = UDim2.new(0, 6, 0, 5),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			47,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Down",
				Parent = { 41 },
				Position = UDim2.new(0, 0, 0, 8),
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			48,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 47 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			49,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 48 },
				Position = UDim2.new(0, 8, 0, 5),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			50,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 48 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			51,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 48 },
				Position = UDim2.new(0, 6, 0, 3),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			52,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 39 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Hue:",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			53,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Name = "Preview",
				Parent = { 1 },
				Position = UDim2.new(1, -260, 0, 211),
				Size = UDim2.new(0, 35, 1, -245),
			},
		},
		{
			54,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Red",
				Parent = { 1 },
				Position = UDim2.new(1, -63, 0, 211),
				Size = UDim2.new(0, 52, 0, 16),
			},
		},
		{
			55,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				Font = 3,
				Name = "Input",
				Parent = { 54 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 50, 0, 16),
				Text = "0",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			56,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "ArrowFrame",
				Parent = { 55 },
				Position = UDim2.new(1, -16, 0, 0),
				Size = UDim2.new(0, 16, 1, 0),
			},
		},
		{
			57,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Up",
				Parent = { 56 },
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			58,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 57 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			59,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 58 },
				Position = UDim2.new(0, 8, 0, 3),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			60,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 58 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			61,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 58 },
				Position = UDim2.new(0, 6, 0, 5),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			62,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Down",
				Parent = { 56 },
				Position = UDim2.new(0, 0, 0, 8),
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			63,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 62 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			64,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 63 },
				Position = UDim2.new(0, 8, 0, 5),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			65,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 63 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			66,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 63 },
				Position = UDim2.new(0, 6, 0, 3),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			67,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 54 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Red:",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			68,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Sat",
				Parent = { 1 },
				Position = UDim2.new(1, -180, 0, 233),
				Size = UDim2.new(0, 52, 0, 16),
			},
		},
		{
			69,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				Font = 3,
				Name = "Input",
				Parent = { 68 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 50, 0, 16),
				Text = "0",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			70,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "ArrowFrame",
				Parent = { 69 },
				Position = UDim2.new(1, -16, 0, 0),
				Size = UDim2.new(0, 16, 1, 0),
			},
		},
		{
			71,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Up",
				Parent = { 70 },
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			72,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 71 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			73,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 72 },
				Position = UDim2.new(0, 8, 0, 3),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			74,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 72 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			75,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 72 },
				Position = UDim2.new(0, 6, 0, 5),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			76,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Down",
				Parent = { 70 },
				Position = UDim2.new(0, 0, 0, 8),
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			77,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 76 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			78,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 77 },
				Position = UDim2.new(0, 8, 0, 5),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			79,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 77 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			80,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 77 },
				Position = UDim2.new(0, 6, 0, 3),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			81,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 68 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Sat:",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			82,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.12549020349979, 0.12549020349979, 0.12549020349979),
				Name = "Val",
				Parent = { 1 },
				Position = UDim2.new(1, -180, 0, 255),
				Size = UDim2.new(0, 52, 0, 16),
			},
		},
		{
			83,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(0.25098040699959, 0.25098040699959, 0.25098040699959),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.37647062540054, 0.37647062540054, 0.37647062540054),
				Font = 3,
				Name = "Input",
				Parent = { 82 },
				Position = UDim2.new(0, 2, 0, 0),
				Size = UDim2.new(0, 50, 0, 16),
				Text = "255",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{
			84,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "ArrowFrame",
				Parent = { 83 },
				Position = UDim2.new(1, -16, 0, 0),
				Size = UDim2.new(0, 16, 1, 0),
			},
		},
		{
			85,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Up",
				Parent = { 84 },
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			86,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 85 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			87,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 86 },
				Position = UDim2.new(0, 8, 0, 3),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			88,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 86 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			89,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 86 },
				Position = UDim2.new(0, 6, 0, 5),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			90,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "Down",
				Parent = { 84 },
				Position = UDim2.new(0, 0, 0, 8),
				Size = UDim2.new(1, 0, 0, 8),
				Text = "",
				TextSize = 14,
			},
		},
		{
			91,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 90 },
				Size = UDim2.new(0, 16, 0, 8),
			},
		},
		{
			92,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 91 },
				Position = UDim2.new(0, 8, 0, 5),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			93,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 91 },
				Position = UDim2.new(0, 7, 0, 4),
				Size = UDim2.new(0, 3, 0, 1),
			},
		},
		{
			94,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.86274510622025, 0.86274510622025, 0.86274510622025),
				BorderSizePixel = 0,
				Parent = { 91 },
				Position = UDim2.new(0, 6, 0, 3),
				Size = UDim2.new(0, 5, 0, 1),
			},
		},
		{
			95,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Title",
				Parent = { 82 },
				Position = UDim2.new(0, -40, 0, 0),
				Size = UDim2.new(0, 34, 1, 0),
				Text = "Val:",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			96,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Font = 3,
				Name = "Cancel",
				Parent = { 1 },
				Position = UDim2.new(1, -105, 1, -28),
				Size = UDim2.new(0, 100, 0, 25),
				Text = "Cancel",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
			},
		},
		{
			97,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Font = 3,
				Name = "Ok",
				Parent = { 1 },
				Position = UDim2.new(1, -210, 1, -28),
				Size = UDim2.new(0, 100, 0, 25),
				Text = "OK",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
			},
		},
		{
			98,
			"ImageLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderColor3 = Color3.new(0.21568627655506, 0.21568627655506, 0.21568627655506),
				Image = "rbxassetid://1072518502",
				Name = "ColorStrip",
				Parent = { 1 },
				Position = UDim2.new(1, -30, 0, 5),
				Size = UDim2.new(0, 13, 0, 200),
			},
		},
		{
			99,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.3137255012989, 0.3137255012989, 0.3137255012989),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "ArrowFrame",
				Parent = { 1 },
				Position = UDim2.new(1, -16, 0, 1),
				Size = UDim2.new(0, 5, 0, 208),
			},
		},
		{
			100,
			"Frame",
			{
				BackgroundTransparency = 1,
				Name = "Arrow",
				Parent = { 99 },
				Position = UDim2.new(0, -2, 0, -4),
				Size = UDim2.new(0, 8, 0, 16),
			},
		},
		{
			101,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Parent = { 100 },
				Position = UDim2.new(0, 2, 0, 8),
				Size = UDim2.new(0, 1, 0, 1),
			},
		},
		{
			102,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Parent = { 100 },
				Position = UDim2.new(0, 3, 0, 7),
				Size = UDim2.new(0, 1, 0, 3),
			},
		},
		{
			103,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Parent = { 100 },
				Position = UDim2.new(0, 4, 0, 6),
				Size = UDim2.new(0, 1, 0, 5),
			},
		},
		{
			104,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Parent = { 100 },
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, 1, 0, 7),
			},
		},
		{
			105,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Parent = { 100 },
				Position = UDim2.new(0, 6, 0, 4),
				Size = UDim2.new(0, 1, 0, 9),
			},
		},
	})
	local window = Lib.Window.new()
	window.Resizable = false
	window.Alignable = false
	window:SetTitle("Color Picker")
	window:Resize(450, 330)
	for i, v in guiContents:GetChildren() do
		v.Parent = window.GuiElems.Content
	end
	newMt.Window = window
	newMt.Gui = window.Gui
	local pickerGui = window.Gui.Main
	local pickerFrame = pickerGui.Content
	local colorSpace = pickerFrame.ColorSpaceFrame.ColorSpace
	local colorStrip = pickerFrame.ColorStrip
	local previewFrame = pickerFrame.Preview
	local basicColorsFrame = pickerFrame.BasicColors
	local customColorsFrame = pickerFrame.CustomColors
	local okButton = pickerFrame.Ok
	local cancelButton = pickerFrame.Cancel

	local colorScope = colorSpace.Scope
	local colorArrow = pickerFrame.ArrowFrame.Arrow

	local hueInput = pickerFrame.Hue.Input
	local satInput = pickerFrame.Sat.Input
	local valInput = pickerFrame.Val.Input

	local redInput = pickerFrame.Red.Input
	local greenInput = pickerFrame.Green.Input
	local blueInput = pickerFrame.Blue.Input

	local user = game:GetService("UserInputService")
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()

	local hue, sat, val = 0, 0, 1
	local red, green, blue = 1, 1, 1
	local chosenColor = Color3.new(0, 0, 0)

	local basicColors = {
		Color3.new(0, 0, 0),
		Color3.new(0.66666668653488, 0, 0),
		Color3.new(0, 0.33333334326744, 0),
		Color3.new(0.66666668653488, 0.33333334326744, 0),
		Color3.new(0, 0.66666668653488, 0),
		Color3.new(0.66666668653488, 0.66666668653488, 0),
		Color3.new(0, 1, 0),
		Color3.new(0.66666668653488, 1, 0),
		Color3.new(0, 0, 0.49803924560547),
		Color3.new(0.66666668653488, 0, 0.49803924560547),
		Color3.new(0, 0.33333334326744, 0.49803924560547),
		Color3.new(0.66666668653488, 0.33333334326744, 0.49803924560547),
		Color3.new(0, 0.66666668653488, 0.49803924560547),
		Color3.new(0.66666668653488, 0.66666668653488, 0.49803924560547),
		Color3.new(0, 1, 0.49803924560547),
		Color3.new(0.66666668653488, 1, 0.49803924560547),
		Color3.new(0, 0, 1),
		Color3.new(0.66666668653488, 0, 1),
		Color3.new(0, 0.33333334326744, 1),
		Color3.new(0.66666668653488, 0.33333334326744, 1),
		Color3.new(0, 0.66666668653488, 1),
		Color3.new(0.66666668653488, 0.66666668653488, 1),
		Color3.new(0, 1, 1),
		Color3.new(0.66666668653488, 1, 1),
		Color3.new(0.33333334326744, 0, 0),
		Color3.new(1, 0, 0),
		Color3.new(0.33333334326744, 0.33333334326744, 0),
		Color3.new(1, 0.33333334326744, 0),
		Color3.new(0.33333334326744, 0.66666668653488, 0),
		Color3.new(1, 0.66666668653488, 0),
		Color3.new(0.33333334326744, 1, 0),
		Color3.new(1, 1, 0),
		Color3.new(0.33333334326744, 0, 0.49803924560547),
		Color3.new(1, 0, 0.49803924560547),
		Color3.new(0.33333334326744, 0.33333334326744, 0.49803924560547),
		Color3.new(1, 0.33333334326744, 0.49803924560547),
		Color3.new(0.33333334326744, 0.66666668653488, 0.49803924560547),
		Color3.new(1, 0.66666668653488, 0.49803924560547),
		Color3.new(0.33333334326744, 1, 0.49803924560547),
		Color3.new(1, 1, 0.49803924560547),
		Color3.new(0.33333334326744, 0, 1),
		Color3.new(1, 0, 1),
		Color3.new(0.33333334326744, 0.33333334326744, 1),
		Color3.new(1, 0.33333334326744, 1),
		Color3.new(0.33333334326744, 0.66666668653488, 1),
		Color3.new(1, 0.66666668653488, 1),
		Color3.new(0.33333334326744, 1, 1),
		Color3.new(1, 1, 1),
	}
	local customColors = {}

	local function updateColor(noupdate)
		local relativeX, relativeY, relativeStripY = 219 - hue * 219, 199 - sat * 199, 199 - val * 199

		if noupdate == 2 or not noupdate then
			hueInput.Text = tostring(math.ceil(359 * hue))
			satInput.Text = tostring(math.ceil(255 * sat))
			valInput.Text = tostring(math.floor(255 * val))
		end
		if noupdate == 1 or not noupdate then
			redInput.Text = tostring(math.floor(255 * red))
			greenInput.Text = tostring(math.floor(255 * green))
			blueInput.Text = tostring(math.floor(255 * blue))
		end

		chosenColor = Color3.new(red, green, blue)

		colorScope.Position = UDim2.new(0, relativeX - 9, 0, relativeY - 9)
		colorStrip.ImageColor3 = Color3.fromHSV(hue, sat, 1)
		colorArrow.Position = UDim2.new(0, -2, 0, relativeStripY - 4)
		previewFrame.BackgroundColor3 = chosenColor

		newMt.Color = chosenColor
		newMt.OnPreview:Fire(chosenColor)
	end

	local function colorSpaceInput()
		local relativeX = mouse.X - colorSpace.AbsolutePosition.X
		local relativeY = mouse.Y - colorSpace.AbsolutePosition.Y

		if relativeX < 0 then
			relativeX = 0
		elseif relativeX > 219 then
			relativeX = 219
		end
		if relativeY < 0 then
			relativeY = 0
		elseif relativeY > 199 then
			relativeY = 199
		end

		hue = (219 - relativeX) / 219
		sat = (199 - relativeY) / 199

		local hsvColor = Color3.fromHSV(hue, sat, val)
		red, green, blue = hsvColor.r, hsvColor.g, hsvColor.b

		updateColor()
	end

	local function colorStripInput()
		local relativeY = mouse.Y - colorStrip.AbsolutePosition.Y

		if relativeY < 0 then
			relativeY = 0
		elseif relativeY > 199 then
			relativeY = 199
		end

		val = (199 - relativeY) / 199

		local hsvColor = Color3.fromHSV(hue, sat, val)
		red, green, blue = hsvColor.r, hsvColor.g, hsvColor.b

		updateColor()
	end

	local function hookButtons(frame, func)
		frame.ArrowFrame.Up.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				frame.ArrowFrame.Up.BackgroundTransparency = 0.5
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				local releaseEvent

				local startTime = tick()
				local pressing = true
				local startNum = tonumber(frame.Text)

				if not startNum then
					return
				end

				releaseEvent = user.InputEnded:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end
					releaseEvent:Disconnect()
					pressing = false
				end)

				startNum = startNum + 1
				func(startNum)
				while pressing do
					if tick() - startTime > 0.3 then
						startNum = startNum + 1
						func(startNum)
					end
					wait(0.1)
				end
			end
		end)

		frame.ArrowFrame.Up.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				frame.ArrowFrame.Up.BackgroundTransparency = 1
			end
		end)

		frame.ArrowFrame.Down.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				frame.ArrowFrame.Down.BackgroundTransparency = 0.5
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				local releaseEvent

				local startTime = tick()
				local pressing = true
				local startNum = tonumber(frame.Text)

				if not startNum then
					return
				end

				releaseEvent = user.InputEnded:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end
					releaseEvent:Disconnect()
					pressing = false
				end)

				startNum = startNum - 1
				func(startNum)
				while pressing do
					if tick() - startTime > 0.3 then
						startNum = startNum - 1
						func(startNum)
					end
					wait(0.1)
				end
			end
		end)

		frame.ArrowFrame.Down.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				frame.ArrowFrame.Down.BackgroundTransparency = 1
			end
		end)
	end

	colorSpace.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local releaseEvent, mouseEvent

			releaseEvent = user.InputEnded:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return
				end
				releaseEvent:Disconnect()
				mouseEvent:Disconnect()
			end)

			mouseEvent = user.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					colorSpaceInput()
				end
			end)

			colorSpaceInput()
		end
	end)

	colorStrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local releaseEvent, mouseEvent

			releaseEvent = user.InputEnded:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return
				end
				releaseEvent:Disconnect()
				mouseEvent:Disconnect()
			end)

			mouseEvent = user.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					colorStripInput()
				end
			end)

			colorStripInput()
		end
	end)

	local function updateHue(str)
		local num = tonumber(str)
		if num then
			hue = math.clamp(math.floor(num), 0, 359) / 359
			local hsvColor = Color3.fromHSV(hue, sat, val)
			red, green, blue = hsvColor.r, hsvColor.g, hsvColor.b
			hueInput.Text = tostring(hue * 359)
			updateColor(1)
		end
	end
	hueInput.FocusLost:Connect(function()
		updateHue(hueInput.Text)
	end)
	hookButtons(hueInput, updateHue)

	local function updateSat(str)
		local num = tonumber(str)
		if num then
			sat = math.clamp(math.floor(num), 0, 255) / 255
			local hsvColor = Color3.fromHSV(hue, sat, val)
			red, green, blue = hsvColor.r, hsvColor.g, hsvColor.b
			satInput.Text = tostring(sat * 255)
			updateColor(1)
		end
	end
	satInput.FocusLost:Connect(function()
		updateSat(satInput.Text)
	end)
	hookButtons(satInput, updateSat)

	local function updateVal(str)
		local num = tonumber(str)
		if num then
			val = math.clamp(math.floor(num), 0, 255) / 255
			local hsvColor = Color3.fromHSV(hue, sat, val)
			red, green, blue = hsvColor.r, hsvColor.g, hsvColor.b
			valInput.Text = tostring(val * 255)
			updateColor(1)
		end
	end
	valInput.FocusLost:Connect(function()
		updateVal(valInput.Text)
	end)
	hookButtons(valInput, updateVal)

	local function updateRed(str)
		local num = tonumber(str)
		if num then
			red = math.clamp(math.floor(num), 0, 255) / 255
			local newColor = Color3.new(red, green, blue)
			hue, sat, val = Color3.toHSV(newColor)
			redInput.Text = tostring(red * 255)
			updateColor(2)
		end
	end
	redInput.FocusLost:Connect(function()
		updateRed(redInput.Text)
	end)
	hookButtons(redInput, updateRed)

	local function updateGreen(str)
		local num = tonumber(str)
		if num then
			green = math.clamp(math.floor(num), 0, 255) / 255
			local newColor = Color3.new(red, green, blue)
			hue, sat, val = Color3.toHSV(newColor)
			greenInput.Text = tostring(green * 255)
			updateColor(2)
		end
	end
	greenInput.FocusLost:Connect(function()
		updateGreen(greenInput.Text)
	end)
	hookButtons(greenInput, updateGreen)

	local function updateBlue(str)
		local num = tonumber(str)
		if num then
			blue = math.clamp(math.floor(num), 0, 255) / 255
			local newColor = Color3.new(red, green, blue)
			hue, sat, val = Color3.toHSV(newColor)
			blueInput.Text = tostring(blue * 255)
			updateColor(2)
		end
	end
	blueInput.FocusLost:Connect(function()
		updateBlue(blueInput.Text)
	end)
	hookButtons(blueInput, updateBlue)

	local colorChoice = Instance.new("TextButton")
	colorChoice.Name = "Choice"
	colorChoice.Size = UDim2.new(0, 25, 0, 18)
	colorChoice.BorderColor3 = Color3.fromRGB(55, 55, 55)
	colorChoice.Text = ""
	colorChoice.AutoButtonColor = false

	local row = 0
	local column = 0
	for i, v in basicColors do
		local newColor = colorChoice:Clone()
		newColor.BackgroundColor3 = v
		newColor.Position = UDim2.new(0, 1 + 30 * column, 0, 21 + 23 * row)

		newColor.MouseButton1Click:Connect(function()
			red, green, blue = v.r, v.g, v.b
			local newColor = Color3.new(red, green, blue)
			hue, sat, val = Color3.toHSV(newColor)
			updateColor()
		end)

		newColor.Parent = basicColorsFrame
		column = column + 1
		if column == 6 then
			row = row + 1
			column = 0
		end
	end

	row = 0
	column = 0
	for i = 1, 12 do
		local color = customColors[i] or Color3.new(0, 0, 0)
		local newColor = colorChoice:Clone()
		newColor.BackgroundColor3 = color
		newColor.Position = UDim2.new(0, 1 + 30 * column, 0, 20 + 23 * row)

		newColor.MouseButton1Click:Connect(function()
			local curColor = customColors[i] or Color3.new(0, 0, 0)
			red, green, blue = curColor.r, curColor.g, curColor.b
			hue, sat, val = Color3.toHSV(curColor)
			updateColor()
		end)

		newColor.MouseButton2Click:Connect(function()
			customColors[i] = chosenColor
			newColor.BackgroundColor3 = chosenColor
		end)

		newColor.Parent = customColorsFrame
		column = column + 1
		if column == 6 then
			row = row + 1
			column = 0
		end
	end

	okButton.MouseButton1Click:Connect(function()
		newMt.OnSelect:Fire(chosenColor)
		window:Close()
	end)
	okButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			okButton.BackgroundTransparency = 0.4
		end
	end)
	okButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			okButton.BackgroundTransparency = 0
		end
	end)

	cancelButton.MouseButton1Click:Connect(function()
		newMt.OnCancel:Fire()
		window:Close()
	end)
	cancelButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			cancelButton.BackgroundTransparency = 0.4
		end
	end)
	cancelButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			cancelButton.BackgroundTransparency = 0
		end
	end)

	updateColor()

	newMt.SetColor = function(self, color)
		red, green, blue = color.r, color.g, color.b
		hue, sat, val = Color3.toHSV(color)
		updateColor()
	end

	newMt.Show = function(self)
		self.Window:Show()
	end

	return newMt
end

return { new = new }
