local components = require(script.Parent.Parent.ui).components
local LuaUtils = require(script.Parent.Parent.utils.Lua)
local env = require(script.Parent.Parent.utils.env)

local ScriptViewer = {}

local window, currentFrame
local Tabs, Scripts = {}, {}

local function addNewTab(Script: LocalScript | ModuleScript)
	for i, tab in ipairs(Tabs) do --Modify old tabs
		if #Tabs >= 12 then
			Tabs[i].Text = ""
		end

		if (1 / (#Tabs + 2)) * (i - 1) ~= 0 then
			tab.Button.Position = UDim2.new((1 / (#Tabs + 1)) * (i - 1), 0, 0, 0)
		end

		tab.Button.Size = UDim2.new(1 / (#Tabs + 1), 0, 0, 20)
	end

	local Tab = {}
	Tab.Frame = require(script.Parent.Parent.ui.CodeFrame).new()
	Tab.Frame.Frame.Position = UDim2.new(0, 0, 0, 20)
	Tab.Frame.Frame.Size = UDim2.new(1, 0, 1, -20)
	Tab.Frame.Frame.Parent = window.GuiElems.Content
	Tab.Frame.Gui.Visible = false

	Tab.Button = Instance.new("TextButton", window.GuiElems.Content)
	Tab.Button.BackgroundTransparency = 1
	Tab.Button.Position = UDim2.new((1 / (#Tabs + 1) * #Tabs), 0, 0, 0)
	Tab.Button.Size = UDim2.new((1 / (#Tabs + 1)), 0, 0, 20)
	Tab.Button.Text = Script.Name:sub(1, math.floor(math.round((-1 * #Tabs) + 10)) + 1)
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

ScriptViewer.ViewScript = function(Script: LocalScript | ModuleScript)
	if currentFrame and currentFrame.Gui then
		currentFrame.Gui.Visible = false
	end

	local currentScript = Scripts[Script]
	if currentScript then
		currentFrame = Tabs[currentScript.Index].Frame
	else
		addNewTab(Script)

		currentScript = {
			Script = LuaUtils.new(Script),
			Index = #Tabs,
		}
		Scripts[Script] = currentScript
	end
	currentFrame:SetText(currentScript.Script:Decompile())
	currentFrame.Gui.Visible = true
	window:Show()
end

ScriptViewer.Init = function()
	window = components.Window.new()
	window:SetTitle("Script Viewer")
	window:Resize(500, 400)
	ScriptViewer.Window = window

	local copyButton = Instance.new("TextButton", window.GuiElems.Content)
	copyButton.BackgroundTransparency = 1
	copyButton.Position = UDim2.new(0.0, 0, 1, -20)
	copyButton.Size = UDim2.new(0.5, 0, 0, 20)
	copyButton.Text = "Copy To Clipboard"
	copyButton.TextColor3 = Color3.new(1, 1, 1)
	copyButton.BorderSizePixel = 0
	copyButton.BackgroundTransparency = 1
	copyButton.MouseButton1Click:Connect(function()
		pcall(setclipboard, currentFrame:GetText())
	end)

	local saveButton = Instance.new("TextButton", window.GuiElems.Content)
	saveButton.BackgroundTransparency = 1
	saveButton.Size = UDim2.new(0.5, 0, 0, 20)
	saveButton.Position = UDim2.new(0.5, 0, 1, -20)
	saveButton.Text = "Save To File"
	saveButton.TextColor3 = Color3.new(1, 1, 1)
	saveButton.MouseButton1Click:Connect(function()
		pcall(env.writefile, "Place_" .. game.PlaceId .. "_Script_" .. os.time() .. ".lua", currentFrame:GetText())
	end)
end

return ScriptViewer
