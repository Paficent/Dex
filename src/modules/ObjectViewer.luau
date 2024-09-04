local components = require(script.Parent.Parent.ui).components

local ObjectViewer = {}

local window, _object

ObjectViewer.ViewObject = function(Object: Part | BasePart | Model)
	_object = Object
	window:Show()
end

ObjectViewer.Init = function()
	window = components.Window.new()
	window:SetTitle("Object Viewer")
	window:Resize(500, 400)
	ObjectViewer.Window = window

	-- local consoleFrame = require(script.Parent.Parent.ui.CodeFrame).new()
	-- consoleFrame.Frame.Position = UDim2.new(0, 0, 0, 20)
	-- consoleFrame.Frame.Size = UDim2.new(1, 0, 1, -40)
	-- consoleFrame.Frame.Parent = window.GuiElems.Content

	-- local saveButton = Instance.new("TextButton", window.GuiElems.Content)
	-- saveButton.BackgroundTransparency = 1
	-- saveButton.Size = UDim2.new(0.5, 0, 0, 20)
	-- saveButton.Position = UDim2.new(0.5, 0, 1, -20)
	-- saveButton.Text = "Save To File"
	-- saveButton.TextColor3 = Color3.new(1, 1, 1)
	-- saveButton.MouseButton1Click:Connect(function()
	-- 	pcall(writefile, "Place_" .. game.PlaceId .. "_Script_" .. os.time() .. ".lua", consoleFrame:GetText())
	-- end)
end

return ObjectViewer
