-- Common Locals
local LuaUtils = require(script.Parent.Parent.utils.Lua)
local components = require(script.Parent.Parent.ui).components

local Executor = {}
local Tabs = {}

Executor.Init = function()
	local window = components.Window.new()
	window:SetTitle("Executor")
	window:Resize(500, 350)
	window.PosX = 400 - window.SizeX / 2
	window.PosY = 300 - window.SizeY / 2
	Executor.Window = window

	local currentFrame, addNewButton

	local function addNewTab()
		if #Tabs == 9 then
			return
		end

		for i, tab in ipairs(Tabs) do --Modify old tabs
			if (1 / (#Tabs + 2)) * (i - 1) ~= 0 then
				tab.Button.Position = UDim2.new((1 / (#Tabs + 2)) * (i - 1), 0, 0, 0)
			end
			tab.Button.Size = UDim2.new(1 / (#Tabs + 2), 0, 0, 20)
		end

		if addNewButton then
			addNewButton.Position = UDim2.new((1 / (#Tabs + 2)) * (#Tabs + 1), 0, 0, 0)
			addNewButton.Size = UDim2.new((1 / (#Tabs + 2)), 0, 0, 20)
		end

		local Tab = {}
		Tab.Frame = require(script.Parent.Parent.ui.CodeFrame).new()
		Tab.Frame.Frame.Position = UDim2.new(0, 0, 0, 20)
		Tab.Frame.Frame.Size = UDim2.new(1, 0, 1, -40)
		Tab.Frame.Frame.Parent = window.GuiElems.Content
		Tab.Frame.Gui.Visible = false

		Tab.Button = Instance.new("TextButton", window.GuiElems.Content)
		Tab.Button.BackgroundTransparency = 1
		Tab.Button.Position = UDim2.new((1 / (#Tabs + 2) * #Tabs), 0, 0, 0)
		Tab.Button.Size = UDim2.new((1 / (#Tabs + 2)), 0, 0, 20)
		Tab.Button.Text = "Tab " .. #Tabs + 1
		Tab.Button.TextColor3 = Color3.new(1, 1, 1)
		Tab.Button.MouseButton1Click:Connect(function()
			if currentFrame == Tab.Frame then
				return
			end

			currentFrame.Gui.Visible = false
			currentFrame = Tab.Frame
			currentFrame.Gui.Visible = true
		end)

		currentFrame = Tab.Frame
		currentFrame.Gui.Visible = true
		table.insert(Tabs, Tab)
	end

	addNewTab()

	addNewButton = Instance.new("TextButton", window.GuiElems.Content)
	addNewButton.BackgroundTransparency = 1
	addNewButton.Position = UDim2.new(0.5, 0, 0, 0)
	addNewButton.Size = UDim2.new(0.5, 0, 0, 20)
	addNewButton.Text = "New Tab"
	addNewButton.TextColor3 = Color3.new(1, 1, 1)
	addNewButton.MouseButton1Click:Connect(function()
		currentFrame.Gui.Visible = false
		addNewTab()
	end)

	local runButton = Instance.new("TextButton", window.GuiElems.Content)
	runButton.BackgroundTransparency = 1
	runButton.Position = UDim2.new(0.0, 0, 1, -20)
	runButton.Size = UDim2.new(0.5, 0, 0, 20)
	runButton.Text = "Run"
	runButton.TextColor3 = Color3.new(1, 1, 1)
	runButton.BorderSizePixel = 0
	runButton.BackgroundTransparency = 1
	runButton.MouseButton1Click:Connect(function()
		local elevated = pcall(loadstring, "return 0")
		if elevated then
			loadstring(currentFrame:GetText())()
		else
			local Script = LuaUtils.new(currentFrame:GetText())
			Script:GetBytecode()
			Script:Run()
		end
		runButton.BackgroundColor3 = Color3.new(50, 50, 50)
	end)

	local clearButton = Instance.new("TextButton", window.GuiElems.Content)
	clearButton.BackgroundTransparency = 1
	clearButton.Size = UDim2.new(0.5, 0, 0, 20)
	clearButton.Position = UDim2.new(0.5, 0, 1, -20)
	clearButton.Text = "Clear"
	clearButton.TextColor3 = Color3.new(1, 1, 1)
	clearButton.MouseButton1Click:Connect(function()
		currentFrame:SetText("")
	end)
end

return Executor
