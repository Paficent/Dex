local Services = require(script.Parent.Parent.Parent.utils.Services)

local Main, Settings = shared.Main, shared.Settings -- Main Containers
local Lib, create = shared.Apps.Lib, shared.create
local Players: Players, TextService: TextService, UserInputService: UserInputService =
	Services:Get("Players", "TextService", "UserInputService")
local funcs = {}
local mouse

local function createGui(self)
	local contextGui = create({
		{ 1, "ScreenGui", { DisplayOrder = 1000000, Name = "Context", ZIndexBehavior = 1 } },
		{
			2,
			"Frame",
			{
				Active = true,
				BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462),
				BorderColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462),
				Name = "Main",
				Parent = { 1 },
				Position = UDim2.new(0.5, -100, 0.5, -150),
				Size = UDim2.new(0, 200, 0, 100),
			},
		},
		{ 3, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 2 } } },
		{
			4,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.17647059261799, 0.17647059261799, 0.17647059261799),
				Name = "Container",
				Parent = { 2 },
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
			},
		},
		{ 5, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 4 } } },
		{
			6,
			"ScrollingFrame",
			{
				Active = true,
				BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				Name = "List",
				Parent = { 4 },
				Position = UDim2.new(0, 2, 0, 2),
				ScrollBarImageColor3 = Color3.new(0, 0, 0),
				ScrollBarThickness = 4,
				Size = UDim2.new(1, -4, 1, -4),
				VerticalScrollBarInset = 1,
			},
		},
		{ 7, "UIListLayout", { Parent = { 6 }, SortOrder = 2 } },
		{
			8,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394),
				BorderSizePixel = 0,
				Name = "SearchFrame",
				Parent = { 4 },
				Size = UDim2.new(1, 0, 0, 24),
				Visible = false,
			},
		},
		{
			9,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14901961386204, 0.14901961386204, 0.14901961386204),
				BorderColor3 = Color3.new(0.1176470592618, 0.1176470592618, 0.1176470592618),
				BorderSizePixel = 0,
				Name = "SearchContainer",
				Parent = { 8 },
				Position = UDim2.new(0, 3, 0, 3),
				Size = UDim2.new(1, -6, 0, 18),
			},
		},
		{
			10,
			"TextBox",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Font = 3,
				Name = "SearchBox",
				Parent = { 9 },
				PlaceholderColor3 = Color3.new(0.39215689897537, 0.39215689897537, 0.39215689897537),
				PlaceholderText = "Search",
				Position = UDim2.new(0, 4, 0, 0),
				Size = UDim2.new(1, -8, 0, 18),
				Text = "",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
				TextXAlignment = 0,
			},
		},
		{ 11, "UICorner", { CornerRadius = UDim.new(0, 2), Parent = { 9 } } },
		{
			12,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.14117647707462, 0.14117647707462, 0.14117647707462),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 8 },
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 1),
			},
		},
		{
			13,
			"TextButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0.33725491166115, 0.49019610881805, 0.73725491762161),
				BorderSizePixel = 0,
				Font = 3,
				Name = "Entry",
				Parent = { 1 },
				Size = UDim2.new(1, 0, 0, 22),
				Text = "",
				TextSize = 14,
				Visible = false,
			},
		},
		{
			14,
			"TextLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "EntryName",
				Parent = { 13 },
				Position = UDim2.new(0, 24, 0, 0),
				Size = UDim2.new(1, -24, 1, 0),
				Text = "Duplicate",
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
				Name = "Shortcut",
				Parent = { 13 },
				Position = UDim2.new(0, 24, 0, 0),
				Size = UDim2.new(1, -30, 1, 0),
				Text = "Ctrl+D",
				TextColor3 = Color3.new(0.86274516582489, 0.86274516582489, 0.86274516582489),
				TextSize = 14,
				TextXAlignment = 1,
			},
		},
		{
			16,
			"ImageLabel",
			{
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				ImageRectOffset = Vector2.new(304, 0),
				ImageRectSize = Vector2.new(16, 16),
				Name = "Icon",
				Parent = { 13 },
				Position = UDim2.new(0, 2, 0, 3),
				ScaleType = 4,
				Size = UDim2.new(0, 16, 0, 16),
			},
		},
		{ 17, "UICorner", { CornerRadius = UDim.new(0, 4), Parent = { 13 } } },
		{
			18,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.21568629145622, 0.21568629145622, 0.21568629145622),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Name = "Divider",
				Parent = { 1 },
				Position = UDim2.new(0, 0, 0, 20),
				Size = UDim2.new(1, 0, 0, 7),
				Visible = false,
			},
		},
		{
			19,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.20392157137394, 0.20392157137394, 0.20392157137394),
				BorderSizePixel = 0,
				Name = "Line",
				Parent = { 18 },
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 1),
			},
		},
		{
			20,
			"TextLabel",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = 3,
				Name = "DividerName",
				Parent = { 18 },
				Position = UDim2.new(0, 2, 0.5, 0),
				Size = UDim2.new(1, -4, 1, 0),
				Text = "Objects",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
				TextTransparency = 0.60000002384186,
				TextXAlignment = 0,
				Visible = false,
			},
		},
	})
	self.GuiElems.Main = contextGui.Main
	self.GuiElems.List = contextGui.Main.Container.List
	self.GuiElems.Entry = contextGui.Entry
	self.GuiElems.Divider = contextGui.Divider
	self.GuiElems.SearchFrame = contextGui.Main.Container.SearchFrame
	self.GuiElems.SearchBar = self.GuiElems.SearchFrame.SearchContainer.SearchBox
	require(script.Parent.ViewportTextBox).convert(self.GuiElems.SearchBar)

	self.GuiElems.SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
		local lower, find = string.lower, string.find
		local searchText = lower(self.GuiElems.SearchBar.Text)
		local items = self.Items
		local map = self.ItemToEntryMap

		if searchText ~= "" then
			local results = {}
			local count = 1
			for i = 1, #items do
				local item = items[i]
				local entry = map[item]
				if entry then
					if not item.Divider and find(lower(item.Name), searchText, 1, true) then
						results[count] = item
						count = count + 1
					else
						entry.Visible = false
					end
				end
			end
			table.sort(results, function(a, b)
				return a.Name < b.Name
			end)
			for i = 1, #results do
				local entry = map[results[i]]
				entry.LayoutOrder = i
				entry.Visible = true
			end
		else
			for i = 1, #items do
				local entry = map[items[i]]
				if entry then
					entry.LayoutOrder = i
					entry.Visible = true
				end
			end
		end

		local toSize = self.GuiElems.List.UIListLayout.AbsoluteContentSize.Y + 6
		self.GuiElems.List.CanvasSize = UDim2.new(0, 0, 0, toSize - 6)
	end)

	return contextGui
end

funcs.Add = function(self, item)
	local newItem = {
		Name = item.Name or "Item",
		Icon = item.Icon or "",
		Shortcut = item.Shortcut or "",
		OnClick = item.OnClick,
		OnHover = item.OnHover,
		Disabled = item.Disabled or false,
		DisabledIcon = item.DisabledIcon or "",
		IconMap = item.IconMap,
		OnRightClick = item.OnRightClick,
	}
	if self.QueuedDivider then
		local text = self.QueuedDividerText and #self.QueuedDividerText > 0
		self:AddDivider(text)
	end
	self.Items[#self.Items + 1] = newItem
	self.Updated = nil
end

funcs.AddRegistered = function(self, name, disabled)
	if not self.Registered[name] then
		error(name .. " is not registered")
	end

	if self.QueuedDivider then
		local text = self.QueuedDividerText and #self.QueuedDividerText > 0
		self:AddDivider(text)
	end
	self.Registered[name].Disabled = disabled
	self.Items[#self.Items + 1] = self.Registered[name]
	self.Updated = nil
end

funcs.Register = function(self, name, item)
	self.Registered[name] = {
		Name = item.Name or "Item",
		Icon = item.Icon or "",
		Shortcut = item.Shortcut or "",
		OnClick = item.OnClick,
		OnHover = item.OnHover,
		DisabledIcon = item.DisabledIcon or "",
		IconMap = item.IconMap,
		OnRightClick = item.OnRightClick,
	}
end

funcs.UnRegister = function(self, name)
	self.Registered[name] = nil
end

funcs.AddDivider = function(self, text)
	self.QueuedDivider = false
	local textWidth = text and TextService:GetTextSize(text, 14, Enum.Font.SourceSans, Vector2.new(999999999, 20)).X
		or nil
	table.insert(self.Items, { Divider = true, Text = text, TextSize = textWidth and textWidth + 4 })
	self.Updated = nil
end

funcs.QueueDivider = function(self, text)
	self.QueuedDivider = true
	self.QueuedDividerText = text or ""
end

funcs.Clear = function(self)
	self.Items = {}
	self.Updated = nil
end

funcs.Refresh = function(self)
	for i, v in self.GuiElems.List:GetChildren() do
		if not v:IsA("UIListLayout") then
			v:Destroy()
		end
	end
	local map = {}
	self.ItemToEntryMap = map

	local dividerFrame = self.GuiElems.Divider
	local contextList = self.GuiElems.List
	local entryFrame = self.GuiElems.Entry
	local items = self.Items

	for i = 1, #items do
		local item = items[i]
		if item.Divider then
			local newDivider = dividerFrame:Clone()
			newDivider.Line.BackgroundColor3 = self.Theme.DividerColor
			if item.Text then
				newDivider.Size = UDim2.new(1, 0, 0, 20)
				newDivider.Line.Position = UDim2.new(0, item.TextSize, 0.5, 0)
				newDivider.Line.Size = UDim2.new(1, -item.TextSize, 0, 1)
				newDivider.DividerName.TextColor3 = self.Theme.TextColor
				newDivider.DividerName.Text = item.Text
				newDivider.DividerName.Visible = true
			end
			newDivider.Visible = true
			map[item] = newDivider
			newDivider.Parent = contextList
		else
			local newEntry = entryFrame:Clone()
			newEntry.BackgroundColor3 = self.Theme.HighlightColor
			newEntry.EntryName.TextColor3 = self.Theme.TextColor
			newEntry.EntryName.Text = item.Name
			newEntry.Shortcut.Text = item.Shortcut
			if item.Disabled then
				newEntry.EntryName.TextColor3 = Color3.new(150 / 255, 150 / 255, 150 / 255)
				newEntry.Shortcut.TextColor3 = Color3.new(150 / 255, 150 / 255, 150 / 255)
			end

			if self.Iconless then
				newEntry.EntryName.Position = UDim2.new(0, 2, 0, 0)
				newEntry.EntryName.Size = UDim2.new(1, -4, 0, 20)
				newEntry.Icon.Visible = false
			else
				local iconIndex = item.Disabled and item.DisabledIcon or item.Icon
				if item.IconMap then
					if type(iconIndex) == "number" then
						item.IconMap:Display(newEntry.Icon, iconIndex)
					elseif type(iconIndex) == "string" then
						item.IconMap:DisplayByKey(newEntry.Icon, iconIndex)
					end
				elseif type(iconIndex) == "string" then
					newEntry.Icon.Image = iconIndex
				end
			end

			if not item.Disabled then
				if item.OnClick then
					newEntry.MouseButton1Click:Connect(function()
						item.OnClick(item.Name)
						if not item.NoHide then
							self:Hide()
						end
					end)
				end

				if item.OnRightClick then
					newEntry.MouseButton2Click:Connect(function()
						item.OnRightClick(item.Name)
						if not item.NoHide then
							self:Hide()
						end
					end)
				end
			end

			newEntry.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					newEntry.BackgroundTransparency = 0
				end
			end)

			newEntry.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					newEntry.BackgroundTransparency = 1
				end
			end)

			newEntry.Visible = true
			map[item] = newEntry
			newEntry.Parent = contextList
		end
	end
	self.Updated = true
end

funcs.Show = function(self, x, y)
	-- Initialize Gui
	local elems = self.GuiElems
	elems.SearchFrame.Visible = self.SearchEnabled
	elems.List.Position = UDim2.new(0, 2, 0, 2 + (self.SearchEnabled and 24 or 0))
	elems.List.Size = UDim2.new(1, -4, 1, -4 - (self.SearchEnabled and 24 or 0))
	if self.SearchEnabled and self.ClearSearchOnShow then
		elems.SearchBar.Text = ""
	end
	self.GuiElems.List.CanvasPosition = Vector2.new(0, 0)

	if not self.Updated then
		self:Refresh() -- Create entries
	end

	-- Vars
	local reverseY = false
	x, y = x or mouse.X, y or mouse.Y
	local maxX, maxY = mouse.ViewSizeX, mouse.ViewSizeY

	-- Position and show
	if x + self.Width > maxX then
		x = self.ReverseX and x - self.Width or maxX - self.Width
	end
	elems.Main.Position = UDim2.new(0, x, 0, y)
	elems.Main.Size = UDim2.new(0, self.Width, 0, 0)
	self.Gui.DisplayOrder = Main.DisplayOrders.Menu
	Lib.ShowGui(self.Gui)

	-- Size adjustment
	local toSize = elems.List.UIListLayout.AbsoluteContentSize.Y + 6 -- Padding
	if self.MaxHeight and toSize > self.MaxHeight then
		elems.List.CanvasSize = UDim2.new(0, 0, 0, toSize - 6)
		toSize = self.MaxHeight
	else
		elems.List.CanvasSize = UDim2.new(0, 0, 0, 0)
	end
	if y + toSize > maxY then
		reverseY = true
	end

	-- Close event
	local closable
	if self.CloseEvent then
		self.CloseEvent:Disconnect()
	end
	self.CloseEvent = UserInputService.InputBegan:Connect(function(input)
		if not closable or input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		if not Lib.CheckMouseInGui(elems.Main) then
			self.CloseEvent:Disconnect()
			self:Hide()
		end
	end)

	-- Resize
	if reverseY then
		elems.Main.Position = UDim2.new(0, x, 0, y - (self.ReverseYOffset or 0))
		local newY = y - toSize - (self.ReverseYOffset or 0)
		y = newY >= 0 and newY or 0
		elems.Main:TweenSizeAndPosition(
			UDim2.new(0, self.Width, 0, toSize),
			UDim2.new(0, x, 0, y),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quart,
			0.2,
			true
		)
	else
		elems.Main:TweenSize(
			UDim2.new(0, self.Width, 0, toSize),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quart,
			0.2,
			true
		)
	end

	-- Close debounce
	Lib.FastWait()
	if self.SearchEnabled and self.FocusSearchOnShow then
		elems.SearchBar:CaptureFocus()
	end
	closable = true
end

funcs.Hide = function(self)
	self.Gui.Parent = nil
end

funcs.ApplyTheme = function(self, data)
	local theme = self.Theme
	theme.ContentColor = data.ContentColor or Settings.Theme.Menu
	theme.OutlineColor = data.OutlineColor or Settings.Theme.Menu
	theme.DividerColor = data.DividerColor or Settings.Theme.Outline2
	theme.TextColor = data.TextColor or Settings.Theme.Text
	theme.HighlightColor = data.HighlightColor or Settings.Theme.Main1

	self.GuiElems.Main.BackgroundColor3 = theme.OutlineColor
	self.GuiElems.Main.Container.BackgroundColor3 = theme.ContentColor
end

local mt = { __index = funcs }
local function new()
	if not mouse then
		mouse = Main.Mouse or Players.LocalPlayer:GetMouse()
	end

	local obj = setmetatable({
		Width = 200,
		MaxHeight = nil,
		Iconless = false,
		SearchEnabled = false,
		ClearSearchOnShow = true,
		FocusSearchOnShow = true,
		Updated = false,
		QueuedDivider = false,
		QueuedDividerText = "",
		Items = {},
		Registered = {},
		GuiElems = {},
		Theme = {},
	}, mt)
	obj.Gui = createGui(obj)
	obj:ApplyTheme({})
	return obj
end

return { new = new }
