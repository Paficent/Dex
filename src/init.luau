-- local DexVersion = "Alpha 1.0.0"
local env, Services

local Main
local Lib, Apps, Settings
local plr, create

do
	shared.Main = {}
	shared.Apps = {}
	shared.Settings = {}
	shared.create = function(data)
		local insts = {}
		for i, v in data do
			insts[v[1]] = Instance.new(v[2])
		end

		for _, v in data do
			for prop, val in v[3] do
				if type(val) == "table" then
					insts[v[1]][prop] = insts[val[1]]
				else
					insts[v[1]][prop] = val
				end
			end
		end

		return insts[1]
	end

	shared.plr = game:GetService("Players").LocalPlayer

	Main = shared.Main
	Apps = shared.Apps
	Settings = shared.Settings
	create = shared.create
	plr = shared.plr
end

local function getDefaultConfig() -- TODO
	local config = require(script.config)

	return {
		decompiler = config.decompiler.default(),
		saveinstance = config.saveinstance.default(),
	}
end

-- Locals
local Explorer, Properties, ScriptViewer, RemoteSpy
local DefaultSettings = {
	Explorer = {
		_Recurse = true,
		Sorting = true,
		TeleportToOffset = Vector3.new(0, 0, 0),
		ClickToRename = true,
		AutoUpdateSearch = true,
		AutoUpdateMode = 0, -- 0 Default, 1 no tree update, 2 no descendant events, 3 frozen
		PartSelectionBox = true,
		GuiSelectionBox = true,
		CopyPathUseGetChildren = true,
	},
	Properties = {
		_Recurse = true,
		MaxConflictCheck = 50,
		ShowDeprecated = false,
		ShowHidden = false,
		ClearOnFocus = false,
		LoadstringInput = true,
		NumberRounding = 3,
		ShowAttributes = false,
		MaxAttributes = 50,
		ScaleType = 1, -- 0 Full Name Shown, 1 Equal Halves
	},
	Theme = {
		_Recurse = true,
		Main1 = Color3.fromRGB(52, 52, 52),
		Main2 = Color3.fromRGB(45, 45, 45),
		Outline1 = Color3.fromRGB(33, 33, 33), -- Mainly frames
		Outline2 = Color3.fromRGB(55, 55, 55), -- Mainly button
		Outline3 = Color3.fromRGB(30, 30, 30), -- Mainly textbox
		TextBox = Color3.fromRGB(38, 38, 38),
		Menu = Color3.fromRGB(32, 32, 32),
		ListSelection = Color3.fromRGB(11, 90, 175),
		Button = Color3.fromRGB(60, 60, 60),
		ButtonHover = Color3.fromRGB(68, 68, 68),
		ButtonPress = Color3.fromRGB(40, 40, 40),
		Highlight = Color3.fromRGB(75, 75, 75),
		Text = Color3.fromRGB(255, 255, 255),
		PlaceholderText = Color3.fromRGB(100, 100, 100),
		Important = Color3.fromRGB(255, 0, 0),
		ExplorerIconMap = "",
		MiscIconMap = "",
		Syntax = {
			Text = Color3.fromRGB(204, 204, 204),
			Background = Color3.fromRGB(36, 36, 36),
			Selection = Color3.fromRGB(255, 255, 255),
			SelectionBack = Color3.fromRGB(11, 90, 175),
			Operator = Color3.fromRGB(204, 204, 204),
			Number = Color3.fromRGB(255, 198, 0),
			String = Color3.fromRGB(173, 241, 149),
			Comment = Color3.fromRGB(102, 102, 102),
			Keyword = Color3.fromRGB(248, 109, 124),
			Error = Color3.fromRGB(255, 0, 0),
			FindBackground = Color3.fromRGB(141, 118, 0),
			MatchingWord = Color3.fromRGB(85, 85, 85),
			BuiltIn = Color3.fromRGB(132, 214, 247),
			CurrentLine = Color3.fromRGB(45, 50, 65),
			LocalMethod = Color3.fromRGB(253, 251, 172),
			LocalProperty = Color3.fromRGB(97, 161, 241),
			Nil = Color3.fromRGB(255, 198, 0),
			Bool = Color3.fromRGB(255, 198, 0),
			Function = Color3.fromRGB(248, 109, 124),
			Local = Color3.fromRGB(248, 109, 124),
			Self = Color3.fromRGB(248, 109, 124),
			FunctionName = Color3.fromRGB(253, 251, 172),
			Bracket = Color3.fromRGB(204, 204, 204),
		},
	},
}

Main.ModuleList = { "ObjectViewer", "Executor", "Console", "ScriptViewer", "RemoteSpy", "Explorer", "Properties" }
Main.MissingEnv = {}
Main.Version = "Beta 1.0.0"
Main.Mouse = plr:GetMouse()
Main.AppControls = {}
Main.Apps = Apps
Main.MenuApps = {}
Main.GitRepoName = "Paficent/DexRenewed"

Main.DisplayOrders = {
	SideWindow = 8,
	Window = 10,
	Menu = 100000,
	Core = 101000,
}

Main.Error = function(str)
	if rconsoleprint then
		rconsoleprint("DEX ERROR: " .. tostring(str) .. "\n")
		wait(9e9)
	else
		error(str)
	end
end

Main.LoadModule = function(name)
	local module = script.modules:WaitForChild(name, 2)
	if not module then
		Main.Error("CANNOT FIND MODULE " .. name)
	end

	module = require(module)

	Main.AppControls[name] = module
	Apps[name] = module
	return module
end

Main.LoadModules = function()
	for i, v in Main.ModuleList do
		local s, e = pcall(Main.LoadModule, v)
		if not s then
			Main.Error("FAILED LOADING " .. v .. " CAUSE " .. e)
		end
	end

	-- Init Major Apps and define them in modules
	Explorer = shared.Apps.Explorer
	Properties = shared.Apps.Properties
	RemoteSpy = shared.Apps.RemoteSpy
	Executor = shared.Apps.Executor
	Console = shared.Apps.Console
	ScriptViewer = shared.Apps.ScriptViewer
	ObjectViewer = shared.Apps.ObjectViewer
end

Main.LoadSettings = function()
	local s, data = pcall(env.readfile or error, "DexSettings.json")
	if s and data and data ~= "" then
		local _, decoded = Services.HttpService:JSONDecode(data)
		if s and decoded then
			-- TODO
		else
			-- TODO: Notification
		end
	else
		Main.ResetSettings()
	end
end

Main.ResetSettings = function()
	local function recur(t, res)
		for set, val in t do
			if type(val) == "table" and val._Recurse then
				if type(res[set]) ~= "table" then
					res[set] = {}
				end
				recur(val, res[set])
			else
				res[set] = val
			end
		end
		return res
	end
	recur(DefaultSettings, Settings)
end

Main.FetchAPI = function()
	local api, rawAPI
	if env.IsElevated() then
		if Main.LocalDepsUpToDate() then
			local localAPI = Lib.ReadFile("dex/rbx_api.dat")
			if localAPI then
				rawAPI = localAPI
			else
				Main.DepsVersionData[1] = ""
			end
		end
		rawAPI = rawAPI or game:HttpGet("http://setup.roblox.com/" .. Main.RobloxVersion .. "-API-Dump.json")
	else
		if script.assets:FindFirstChild("API") then
			rawAPI = require(script.assets.API)
		else
			error("NO API EXISTS")
		end
	end
	Main.RawAPI = rawAPI
	api = Services.HttpService:JSONDecode(rawAPI)

	local classes, enums = {}, {}
	local categoryOrder, seenCategories = {}, {}

	local function insertAbove(t, item, aboveItem)
		local findPos = table.find(t, item)
		if not findPos then
			return
		end
		table.remove(t, findPos)

		local pos = table.find(t, aboveItem)
		if not pos then
			return
		end
		table.insert(t, pos, item)
	end

	for _, class in api.Classes do
		local newClass = {}
		newClass.Name = class.Name
		newClass.Superclass = class.Superclass
		newClass.Properties = {}
		newClass.Functions = {}
		newClass.Events = {}
		newClass.Callbacks = {}
		newClass.Tags = {}

		if class.Tags then
			for c, tag in class.Tags do
				newClass.Tags[tag] = true
			end
		end
		for __, member in class.Members do
			local newMember = {}
			newMember.Name = member.Name
			newMember.Class = class.Name
			newMember.Security = member.Security
			newMember.Tags = {}
			if member.Tags then
				for c, tag in member.Tags do
					newMember.Tags[tag] = true
				end
			end

			local mType = member.MemberType
			if mType == "Property" then
				local propCategory = member.Category or "Other"
				propCategory = propCategory:match("^%s*(.-)%s*$")
				if not seenCategories[propCategory] then
					categoryOrder[#categoryOrder + 1] = propCategory
					seenCategories[propCategory] = true
				end
				newMember.ValueType = member.ValueType
				newMember.Category = propCategory
				newMember.Serialization = member.Serialization
				table.insert(newClass.Properties, newMember)
			elseif mType == "Function" then
				newMember.Parameters = {}
				newMember.ReturnType = member.ReturnType.Name
				for c, param in member.Parameters do
					table.insert(newMember.Parameters, { Name = param.Name, Type = param.Type.Name })
				end
				table.insert(newClass.Functions, newMember)
			elseif mType == "Event" then
				newMember.Parameters = {}
				for c, param in member.Parameters do
					table.insert(newMember.Parameters, { Name = param.Name, Type = param.Type.Name })
				end
				table.insert(newClass.Events, newMember)
			end
		end

		classes[class.Name] = newClass
	end

	for _, class in classes do
		class.Superclass = classes[class.Superclass]
	end

	for _, enum in api.Enums do
		local newEnum = {}
		newEnum.Name = enum.Name
		newEnum.Items = {}
		newEnum.Tags = {}

		if enum.Tags then
			for c, tag in enum.Tags do
				newEnum.Tags[tag] = true
			end
		end
		for __, item in enum.Items do
			local newItem = {}
			newItem.Name = item.Name
			newItem.Value = item.Value
			table.insert(newEnum.Items, newItem)
		end

		enums[enum.Name] = newEnum
	end

	local function getMember(class, member)
		if not classes[class] or not classes[class][member] then
			return
		end
		local result = {}

		local currentClass = classes[class]
		while currentClass do
			for _, entry in currentClass[member] do
				result[#result + 1] = entry
			end
			currentClass = currentClass.Superclass
		end

		table.sort(result, function(a, b)
			return a.Name < b.Name
		end)
		return result
	end

	insertAbove(categoryOrder, "Behavior", "Tuning")
	insertAbove(categoryOrder, "Appearance", "Data")
	insertAbove(categoryOrder, "Attachments", "Axes")
	insertAbove(categoryOrder, "Cylinder", "Slider")
	insertAbove(categoryOrder, "Localization", "Jump Settings")
	insertAbove(categoryOrder, "Surface", "Motion")
	insertAbove(categoryOrder, "Surface Inputs", "Surface")
	insertAbove(categoryOrder, "Part", "Surface Inputs")
	insertAbove(categoryOrder, "Assembly", "Surface Inputs")
	insertAbove(categoryOrder, "Character", "Controls")
	categoryOrder[#categoryOrder + 1] = "Unscriptable"
	categoryOrder[#categoryOrder + 1] = "Attributes"

	local categoryOrderMap = {}
	for i = 1, #categoryOrder do
		categoryOrderMap[categoryOrder[i]] = i
	end

	return {
		Classes = classes,
		Enums = enums,
		CategoryOrder = categoryOrderMap,
		GetMember = getMember,
	}
end

Main.FetchRMD = function()
	local rawXML
	if env.IsElevated() then
		if Main.LocalDepsUpToDate() then
			local localRMD = Lib.ReadFile("dex/rbx_rmd.dat")
			if localRMD then
				rawXML = localRMD
			else
				Main.DepsVersionData[1] = ""
			end
		end
		rawXML = rawXML
			or game:HttpGet(
				"https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/ReflectionMetadata.xml"
			)
	else
		if script.assets:FindFirstChild("RMD") then
			rawXML = require(script.assets.RMD)
		else
			error("NO RMD EXISTS")
		end
	end
	Main.RawRMD = rawXML
	local parsed = Lib.ParseXML(rawXML)
	local classList = parsed.children[1].children[1].children
	local enumList = parsed.children[1].children[2].children
	local propertyOrders = {}

	local classes, enums = {}, {}
	for _, class in classList do
		local className = ""
		for _, child in class.children do
			if child.tag == "Properties" then
				local data = { Properties = {}, Functions = {} }
				local props = child.children
				for _, prop in props do
					local name = prop.attrs.name
					name = name:sub(1, 1):upper() .. name:sub(2)
					data[name] = prop.children[1].text
				end
				className = data.Name
				classes[className] = data
			elseif child.attrs.class == "ReflectionMetadataProperties" then
				local members = child.children
				for _, member in members do
					if member.attrs.class == "ReflectionMetadataMember" then
						local data = {}
						if member.children[1].tag == "Properties" then
							local props = member.children[1].children
							for _, prop in props do
								if prop.attrs then
									local name = prop.attrs.name
									name = name:sub(1, 1):upper() .. name:sub(2)
									data[name] = prop.children[1].text
								end
							end
							if data.PropertyOrder then
								local orders = propertyOrders[className]
								if not orders then
									orders = {}
									propertyOrders[className] = orders
								end
								orders[data.Name] = tonumber(data.PropertyOrder)
							end
							classes[className].Properties[data.Name] = data
						end
					end
				end
			elseif child.attrs.class == "ReflectionMetadataFunctions" then
				local members = child.children
				for _, member in members do
					if member.attrs.class == "ReflectionMetadataMember" then
						local data = {}
						if member.children[1].tag == "Properties" then
							local props = member.children[1].children
							for _, prop in props do
								if prop.attrs then
									local name = prop.attrs.name
									name = name:sub(1, 1):upper() .. name:sub(2)
									data[name] = prop.children[1].text
								end
							end
							classes[className].Functions[data.Name] = data
						end
					end
				end
			end
		end
	end

	for _, enum in enumList do
		local enumName = ""
		for _, child in enum.children do
			if child.tag == "Properties" then
				local data = { Items = {} }
				local props = child.children
				for _, prop in props do
					local name = prop.attrs.name
					name = name:sub(1, 1):upper() .. name:sub(2)
					data[name] = prop.children[1].text
				end
				enumName = data.Name
				enums[enumName] = data
			elseif child.attrs.class == "ReflectionMetadataEnumItem" then
				local data = {}
				if child.children[1].tag == "Properties" then
					local props = child.children[1].children
					for _, prop in props do
						local name = prop.attrs.name
						name = name:sub(1, 1):upper() .. name:sub(2)
						data[name] = prop.children[1].text
					end
					enums[enumName].Items[data.Name] = data
				end
			end
		end
	end

	return { Classes = classes, Enums = enums, PropertyOrders = propertyOrders }
end

Main.ShowGui = function(gui)
	if env.protectgui then
		env.protectgui(gui)
	end
	gui.Parent = Main.GuiHolder
end

Main.CreateIntro = function(initStatus) -- TODO
	return {}
end

Main.CreateApp = function(data)
	if Main.MenuApps[data.Name] then
		return
	end -- TODO: Handle conflict
	local control = {}

	local app = Main.AppTemplate:Clone()

	local iconIndex = data.Icon
	if data.IconMap and iconIndex then
		if type(iconIndex) == "number" then
			data.IconMap:Display(app.Main.Icon, iconIndex)
		elseif type(iconIndex) == "string" then
			data.IconMap:DisplayByKey(app.Main.Icon, iconIndex)
		end
	elseif type(iconIndex) == "string" then
		app.Main.Icon.Image = iconIndex
	else
		app.Main.Icon.Image = ""
	end

	local function updateState()
		app.Main.BackgroundTransparency = data.Open and 0 or (Lib.CheckMouseInGui(app.Main) and 0 or 1)
		app.Main.Highlight.Visible = data.Open
	end

	local function enable(silent)
		if data.Open then
			return
		end
		data.Open = true
		updateState()
		if not silent then
			if data.Window then
				data.Window:Show()
			end
			if data.OnClick then
				data.OnClick(data.Open)
			end
		end
	end

	local function disable(silent)
		if not data.Open then
			return
		end
		data.Open = false
		updateState()
		if not silent then
			if data.Window then
				data.Window:Hide()
			end
			if data.OnClick then
				data.OnClick(data.Open)
			end
		end
	end

	updateState()

	local ySize = Services.TextService:GetTextSize(data.Name, 14, Enum.Font.SourceSans, Vector2.new(62, 999999)).Y
	app.Main.Size = UDim2.new(1, 0, 0, math.clamp(46 + ySize, 60, 74))
	app.Main.AppName.Text = data.Name

	app.Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			app.Main.BackgroundTransparency = 0
			app.Main.BackgroundColor3 = Settings.Theme.ButtonHover
		end
	end)

	app.Main.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			app.Main.BackgroundTransparency = data.Open and 0 or 1
			app.Main.BackgroundColor3 = Settings.Theme.Button
		end
	end)

	app.Main.MouseButton1Click:Connect(function()
		if data.Open then
			disable()
		else
			enable()
		end
	end)

	local window = data.Window
	if window then
		window.OnActivate:Connect(function()
			enable(true)
		end)
		window.OnDeactivate:Connect(function()
			disable(true)
		end)
	end

	app.Visible = true
	app.Parent = Main.AppsContainer
	Main.AppsFrame.CanvasSize = UDim2.new(0, 0, 0, Main.AppsContainerGrid.AbsoluteCellCount.Y * 82 + 8)

	control.Enable = enable
	control.Disable = disable
	Main.MenuApps[data.Name] = control
	return control
end

Main.SetMainGuiOpen = function(val)
	Main.MainGuiOpen = val

	Main.MainGui.OpenButton.Text = val and "X" or "Dex"
	if val then
		Main.MainGui.OpenButton.MainFrame.Visible = true
	end
	Main.MainGui.OpenButton.MainFrame:TweenSize(
		val and UDim2.new(0, 224, 0, 200) or UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.2,
		true
	)
	--Main.MainGui.OpenButton.BackgroundTransparency = val and 0 or (Lib.CheckMouseInGui(Main.MainGui.OpenButton) and 0 or 0.2)
	Services.TweenService
		:Create(
			Main.MainGui.OpenButton,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = val and 0 or (Lib.CheckMouseInGui(Main.MainGui.OpenButton) and 0 or 0.2) }
		)
		:Play()

	if Main.MainGuiMouseEvent then
		Main.MainGuiMouseEvent:Disconnect()
	end

	if not val then
		local startTime = tick()
		Main.MainGuiCloseTime = startTime
		coroutine.wrap(function()
			Lib.FastWait(0.2)
			if not Main.MainGuiOpen and startTime == Main.MainGuiCloseTime then
				Main.MainGui.OpenButton.MainFrame.Visible = false
			end
		end)()
	else
		Main.MainGuiMouseEvent = Services.UserInputService.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				and not Lib.CheckMouseInGui(Main.MainGui.OpenButton)
				and not Lib.CheckMouseInGui(Main.MainGui.OpenButton.MainFrame)
			then
				Main.SetMainGuiOpen(false)
			end
		end)
	end
end

Main.CreateMainGui = function()
	local gui = create({
		{ 1, "ScreenGui", { IgnoreGuiInset = true, Name = "MainMenu" } },
		{
			2,
			"TextButton",
			{
				AnchorPoint = Vector2.new(0.5, 0),
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				BorderSizePixel = 0,
				Font = 4,
				Name = "OpenButton",
				Parent = { 1 },
				Position = UDim2.new(0.5, 0, 0, 2),
				Size = UDim2.new(0, 32, 0, 32),
				Text = "Dex",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 16,
				TextTransparency = 0.20000000298023,
			},
		},
		{ 3, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 2 } } },
		{
			4,
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				ClipsDescendants = true,
				Name = "MainFrame",
				Parent = { 2 },
				Position = UDim2.new(0.5, 0, 1, -4),
				Size = UDim2.new(0, 224, 0, 200),
			},
		},
		{ 5, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 4 } } },
		{
			6,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394),
				Name = "BottomFrame",
				Parent = { 4 },
				Position = UDim2.new(0, 0, 1, -24),
				Size = UDim2.new(1, 0, 0, 24),
			},
		},
		{ 7, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 6 } } },
		{
			8,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394),
				BorderSizePixel = 0,
				Name = "CoverFrame",
				Parent = { 6 },
				Size = UDim2.new(1, 0, 0, 4),
			},
		},
		{
			9,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.1294117718935, 0.1294117718935, 0.1294117718935),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 8 },
				Position = UDim2.new(0, 0, 0, -1),
				Size = UDim2.new(1, 0, 0, 1),
			},
		},
		{
			10,
			"TextButton",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Settings",
				Parent = { 6 },
				Position = UDim2.new(1, -48, 0, 0),
				Size = UDim2.new(0, 24, 1, 0),
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
				Image = "rbxassetid://6578871732",
				ImageTransparency = 0.20000000298023,
				Name = "Icon",
				Parent = { 10 },
				Position = UDim2.new(0, 4, 0, 4),
				Size = UDim2.new(0, 16, 0, 16),
			},
		},
		{
			12,
			"TextButton",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "Information",
				Parent = { 6 },
				Position = UDim2.new(1, -24, 0, 0),
				Size = UDim2.new(0, 24, 1, 0),
				Text = "",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
			},
		},
		{
			13,
			"ImageLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Image = "rbxassetid://6578933307",
				ImageTransparency = 0.20000000298023,
				Name = "Icon",
				Parent = { 12 },
				Position = UDim2.new(0, 4, 0, 4),
				Size = UDim2.new(0, 16, 0, 16),
			},
		},
		{
			14,
			"ScrollingFrame",
			{
				Active = true,
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.1294117718935, 0.1294117718935, 0.1294117718935),
				BorderSizePixel = 0,
				Name = "AppsFrame",
				Parent = { 4 },
				Position = UDim2.new(0.5, 0, 0, 0),
				ScrollBarImageColor3 = Color3.new(0, 0, 0),
				ScrollBarThickness = 4,
				Size = UDim2.new(0, 222, 1, -25),
			},
		},
		{
			15,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Name = "Container",
				Parent = { 14 },
				Position = UDim2.new(0, 7, 0, 8),
				Size = UDim2.new(1, -14, 0, 2),
			},
		},
		{ 16, "UIGridLayout", { CellSize = UDim2.new(0, 66, 0, 74), Parent = { 15 }, SortOrder = 2 } },
		{
			17,
			"Frame",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Name = "App",
				Parent = { 1 },
				Size = UDim2.new(0, 100, 0, 100),
				Visible = false,
			},
		},
		{
			18,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.2352941185236, 0.2352941185236, 0.2352941185236),
				BorderSizePixel = 0,
				Font = 3,
				Name = "Main",
				Parent = { 17 },
				Size = UDim2.new(1, 0, 0, 60),
				Text = "",
				TextColor3 = Color3.new(0, 0, 0),
				TextSize = 14,
			},
		},
		{
			19,
			"ImageLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Image = "rbxassetid://6579106223",
				ImageRectSize = Vector2.new(32, 32),
				Name = "Icon",
				Parent = { 18 },
				Position = UDim2.new(0.5, -16, 0, 4),
				ScaleType = 4,
				Size = UDim2.new(0, 32, 0, 32),
			},
		},
		{
			20,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "AppName",
				Parent = { 18 },
				Position = UDim2.new(0, 2, 0, 38),
				Size = UDim2.new(1, -4, 1, -40),
				Text = "Explorer",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
				TextTransparency = 0.10000000149012,
				TextTruncate = 1,
				TextWrapped = true,
				TextYAlignment = 0,
			},
		},
		{
			21,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0, 0.66666668653488, 1),
				BorderSizePixel = 0,
				Name = "Highlight",
				Parent = { 18 },
				Position = UDim2.new(0, 0, 1, -2),
				Size = UDim2.new(1, 0, 0, 2),
			},
		},
	})
	Main.MainGui = gui
	Main.AppsFrame = gui.OpenButton.MainFrame.AppsFrame
	Main.AppsContainer = Main.AppsFrame.Container
	Main.AppsContainerGrid = Main.AppsContainer.UIGridLayout
	Main.AppTemplate = gui.App
	Main.MainGuiOpen = false

	local openButton = gui.OpenButton
	openButton.BackgroundTransparency = 0.2
	openButton.MainFrame.Size = UDim2.new(0, 0, 0, 0)
	openButton.MainFrame.Visible = false
	openButton.MouseButton1Click:Connect(function()
		Main.SetMainGuiOpen(not Main.MainGuiOpen)
	end)

	openButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			Services.TweenService
				:Create(
					Main.MainGui.OpenButton,
					TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ BackgroundTransparency = 0 }
				)
				:Play()
		end
	end)

	openButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			Services.TweenService
				:Create(
					Main.MainGui.OpenButton,
					TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ BackgroundTransparency = Main.MainGuiOpen and 0 or 0.2 }
				)
				:Play()
		end
	end)

	-- Create Main Apps

	Main.CreateApp({
		Name = "Explorer",
		IconMap = Main.LargeIcons,
		Icon = "Explorer",
		Open = true,
		Window = Explorer.Window,
	})

	Main.CreateApp({
		Name = "Properties",
		IconMap = Main.LargeIcons,
		Icon = "Properties",
		Open = true,
		Window = Properties.Window,
	})

	Main.CreateApp({
		Name = "Script Viewer",
		IconMap = Main.LargeIcons,
		Icon = "ScriptViewer",
		Window = ScriptViewer.Window,
	})

	-- Main.CreateApp({
	-- 	Name = "Object Viewer",
	-- 	IconMap = Main.LargeIcons,
	-- 	Icon = "ScriptViewer",
	-- 	Window = ObjectViewer.Window,
	-- })

	Main.CreateApp({
		Name = "Executor",
		IconMap = Main.LargeIcons,
		Icon = "Executor",
		Window = Executor.Window,
	})

	Main.CreateApp({
		Name = "Console",
		IconMap = Main.LargeIcons,
		Icon = "Console",
		Window = Console.Window,
	})

	Main.CreateApp({
		Name = "Remote Spy",
		IconMap = Main.LargeIcons,
		Icon = "RemoteSpy",
		Window = RemoteSpy.Window,
	})

	Lib.ShowGui(gui)
end

Main.SetupFilesystem = function()
	if not env.makefolder then
		return
	end

	env.makefolder("dex")
	env.makefolder("dex/assets")
	env.makefolder("dex/saved")
	env.makefolder("dex/plugins")
	env.makefolder("dex/ModuleCache")
end

Main.LocalDepsUpToDate = function()
	return Main.DepsVersionData and Main.ClientVersion == Main.DepsVersionData[1]
end

Main.Init = function(config: { any }?)
	shared.Config = shared.Config or config or getDefaultConfig()
	Services = require(script.utils.Services)
	env = require(script.utils.env)

	Main.GuiHolder = env.IsElevated() and Services.CoreGui or plr:FindFirstChildOfClass("PlayerGui")

	Main.LoadSettings()
	Main.SetupFilesystem()

	-- Load Lib
	-- local intro = Main.CreateIntro("Initializing Library")
	Lib = Main.LoadModule("Lib")
	Lib.FastWait()

	-- Init icons
	Main.MiscIcons = require(script.ui.components.IconMap).new("rbxassetid://6511490623", 256, 256, 16, 16)
	Main.MiscIcons:SetDict({
		Reference = 0,
		Cut = 1,
		Cut_Disabled = 2,
		Copy = 3,
		Copy_Disabled = 4,
		Paste = 5,
		Paste_Disabled = 6,
		Delete = 7,
		Delete_Disabled = 8,
		Group = 9,
		Group_Disabled = 10,
		Ungroup = 11,
		Ungroup_Disabled = 12,
		TeleportTo = 13,
		Rename = 14,
		JumpToParent = 15,
		ExploreData = 16,
		Save = 17,
		CallFunction = 18,
		CallRemote = 19,
		Undo = 20,
		Undo_Disabled = 21,
		Redo = 22,
		Redo_Disabled = 23,
		Expand_Over = 24,
		Expand = 25,
		Collapse_Over = 26,
		Collapse = 27,
		SelectChildren = 28,
		SelectChildren_Disabled = 29,
		InsertObject = 30,
		ViewScript = 31,
		AddStar = 32,
		RemoveStar = 33,
		Script_Disabled = 34,
		LocalScript_Disabled = 35,
		Play = 36,
		Pause = 37,
		Rename_Disabled = 38,
	})
	Main.LargeIcons = require(script.ui.components.IconMap).new("rbxassetid://6579106223", 256, 256, 32, 32)
	Main.LargeIcons:SetDict({
		Explorer = 0,
		Properties = 1,
		ScriptViewer = 2,
		RemoteSpy = 3,
		Console = 4,
		Executor = 5,
		ApiReference = 6,
	})

	-- Fetch version only if build
	-- intro.SetProgress("Fetching Roblox Version", 0.2)
	if env.IsElevated() then
		local fileVer = Lib.ReadFile("dex/deps_version.dat")
		Main.ClientVersion = Version()
		if fileVer then
			Main.DepsVersionData = string.split(fileVer, "\n")
			if Main.LocalDepsUpToDate() then
				Main.RobloxVersion = Main.DepsVersionData[2]
			end
		end
		Main.RobloxVersion = Main.RobloxVersion or game:HttpGet("http://setup.roblox.com/versionQTStudio")
	end

	-- Fetch external deps

	-- intro.SetProgress("Fetching API", 0.35)
	shared.API = Main.FetchAPI()
	Lib.FastWait()
	-- intro.SetProgress("Fetching RMD", 0.5)
	shared.RMD = Main.FetchRMD()
	Lib.FastWait()

	-- Save external deps locally if needed
	if env.IsElevated() and env.writefile and not Main.LocalDepsUpToDate() then
		env.writefile("dex/deps_version.dat", Main.ClientVersion .. "\n" .. Main.RobloxVersion)
		env.writefile("dex/rbx_api.dat", Main.RawAPI)
		env.writefile("dex/rbx_rmd.dat", Main.RawRMD)
	end

	-- Load other modules
	-- intro.SetProgress("Loading Modules", 0.75)
	-- Main.AppControls.Lib.InitDeps(Main.GetInitDeps()) -- Missing deps now available
	Main.LoadModules()
	Lib.FastWait()

	-- Init other modules
	-- intro.SetProgress("Initializing Modules", 0.9)

	Explorer.Init()
	Properties.Init()
	ScriptViewer.Init()
	ObjectViewer.Init()
	Executor.Init()
	Console.Init()
	RemoteSpy.Init()
	Lib.FastWait()

	-- Done
	-- intro.SetProgress("Complete", 1)
	coroutine.wrap(function()
		Lib.FastWait(1.25)
		-- intro.Close()
	end)()

	-- Init window system, create main menu, show explorer and properties
	require(script.ui.components.Window).Init()
	Main.CreateMainGui()
	Explorer.Window:Show({ Align = "right", Pos = 1, Size = 0.5, Silent = true })
	Properties.Window:Show({ Align = "right", Pos = 2, Size = 0.5, Silent = true })
	Lib.DeferFunc(function()
		require(script.ui.components.Window).ToggleSide("right")
	end)

	return true
end

-- Setup config in bundled versions
local Dex
if pcall(function()
	local _ = game:GetService("CoreGui"):GetFullName()
end) then
	if getgenv and getgenv() then
		getgenv().___dex___ = nil
	end
	Dex = Main.Init(getgenv().___dex___)
else
	Dex = Main.Init
end

return Dex
