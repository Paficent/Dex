-- Common Locals
local service = shared.service
local components = require(script.Parent.Parent.ui).components

local Console = {}
local Messages = {
	current = "All",
	All = {},
	Error = {},
	Warning = {},
	Information = {},
	Output = {},
}

Console.Init = function()
	local consoleToggled, autoScroll = true, true
	local window = components.Window.new()
	window:SetTitle("Console")
	window:Resize(500, 350)
	window.PosX = 400 - window.SizeX / 2
	window.PosY = 300 - window.SizeY / 2
	Console.Window = window

	local consoleFrame = require(script.Parent.Parent.ui.ConsoleFrame).new()
	consoleFrame.Frame.Position = UDim2.new(0, 0, 0, 20)
	consoleFrame.Frame.Size = UDim2.new(1, 0, 1, -40)
	consoleFrame.Frame.Parent = window.GuiElems.Content

	local messageSelector = components.DropDown.new()
	messageSelector.CanBeEmpty = false
	messageSelector.Position = UDim2.new(0, 0, 0, 0)
	messageSelector.Size = UDim2.new(0.15, 120, 0, 20)
	messageSelector:SetOptions({ "All", "Error", "Warning", "Information", "Output" })
	messageSelector.OnSelect:Connect(function(option)
		local current = Messages.current
		Messages.current = option

		if Messages.current == current then
			return
		end

		consoleFrame:SetText(table.concat(Messages[Messages.current], "\n"))
	end)
	window:Add(messageSelector, "messageSelector")

	local toggleButton = Instance.new("TextButton", window.GuiElems.Content)
	toggleButton.BackgroundTransparency = 1
	toggleButton.Position = UDim2.new(0.0, 0, 1, -20)
	toggleButton.Size = UDim2.new(0.5, 0, 0, 20)
	toggleButton.Text = "Disable"
	toggleButton.TextColor3 = Color3.new(1, 1, 1)
	toggleButton.BorderSizePixel = 0
	toggleButton.BackgroundTransparency = 1
	toggleButton.MouseButton1Click:Connect(function()
		consoleToggled = not consoleToggled
		toggleButton.Text = consoleToggled and "Disable Console" or "Enable Console"

		toggleButton.BackgroundColor3 = Color3.new(50, 50, 50)
	end)

	local scrollButton = Instance.new("TextButton", window.GuiElems.Content)
	scrollButton.BackgroundTransparency = 1
	scrollButton.Size = UDim2.new(0.5, 0, 0, 20)
	scrollButton.Position = UDim2.new(0.5, 0, 1, -20)
	scrollButton.Text = "Clear"
	scrollButton.TextColor3 = Color3.new(1, 1, 1)
	scrollButton.MouseButton1Click:Connect(function()
		consoleFrame:SetText("")
	end)

	local function formatMessage(message, messageType)
		local types = {
			[Enum.MessageType.MessageError] = "Error",
			[Enum.MessageType.MessageWarning] = "Warning",
			[Enum.MessageType.MessageInfo] = "Information",
			[Enum.MessageType.MessageOutput] = "Output",
		}

		table.insert(Messages.All, message)
		table.insert(Messages[types[messageType]], message)
	end

	service.LogService.MessageOut:Connect(function(message, messageType)
		pcall(function(...)
			if not consoleToggled then
				return
			end

			formatMessage(tostring(message), messageType)
			consoleFrame:SetText(table.concat(Messages[Messages.current], "\n"))
			if autoScroll then
				consoleFrame.ScrollV:ScrollTo(consoleFrame.ScrollV.Index + 1, false)
			end
		end)
	end)
end

return Console
