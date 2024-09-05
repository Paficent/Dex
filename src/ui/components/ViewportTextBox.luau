local Services = require(script.Parent.Parent.Parent.utils.Services)
local Settings = shared.Settings

local TextService = Services:Get("TextService")

local MAX_TEXT_WIDTH = 999999999
local DEFAULT_TEXT_SIZE = Vector2.new(MAX_TEXT_WIDTH, 100)

-- Helper function to update the TextBox position and size
local function update(instance)
	local cursorPosition = instance.cursorPosition or -1
	local text = instance.textBox.Text

	if text == "" then
		instance.textBox.Position = UDim2.new(0, 0, 0, 0)
		return
	end

	if cursorPosition == -1 then
		return
	end

	local cursorText = text:sub(1, cursorPosition - 1)
	local leftEnd = -instance.textBox.Position.X.Offset
	local rightEnd = leftEnd + instance.view.AbsoluteSize.X

	local totalTextSize =
		TextService:GetTextSize(text, instance.textBox.TextSize, instance.textBox.Font, DEFAULT_TEXT_SIZE).X
	local cursorTextSize =
		TextService:GetTextSize(cursorText, instance.textBox.TextSize, instance.textBox.Font, DEFAULT_TEXT_SIZE).X

	local positionOffset
	if cursorTextSize > rightEnd then
		positionOffset = math.max(-1, cursorTextSize - instance.view.AbsoluteSize.X + 2)
	elseif cursorTextSize < leftEnd then
		positionOffset = math.max(-1, cursorTextSize - 2)
	elseif totalTextSize < rightEnd then
		positionOffset = math.max(-1, totalTextSize - instance.view.AbsoluteSize.X + 2)
	end

	if positionOffset then
		instance.textBox.Position = UDim2.new(0, -positionOffset, 0, 0)
		instance.textBox.Size = UDim2.new(1, positionOffset, 1, 0)
	end
end

-- Method to get the current text of the TextBox
local function getText(self)
	return self.textBox.Text
end

-- Method to set the text of the TextBox
local function setText(self, text)
	self.textBox.Text = text
end

-- Function to convert an existing TextBox into a viewport TextBox
local function convertTextBox(textBox)
	local instance = {
		cursorPosition = -1,
		textBox = textBox,
		view = Instance.new("Frame"),
		gui = nil,
	}

	local viewFrame = instance.view
	viewFrame.BackgroundTransparency = textBox.BackgroundTransparency
	viewFrame.BackgroundColor3 = textBox.BackgroundColor3
	viewFrame.BorderSizePixel = textBox.BorderSizePixel
	viewFrame.BorderColor3 = textBox.BorderColor3
	viewFrame.Position = textBox.Position
	viewFrame.Size = textBox.Size
	viewFrame.ClipsDescendants = true
	viewFrame.Name = textBox.Name

	textBox.BackgroundTransparency = 1
	textBox.Position = UDim2.new(0, 0, 0, 0)
	textBox.Size = UDim2.new(1, 0, 1, 0)
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.Name = "Input"

	instance.gui = viewFrame

	textBox.Changed:Connect(function(property)
		if property == "Text" or property == "CursorPosition" or property == "AbsoluteSize" then
			local cursorPosition = instance.textBox.CursorPosition
			if cursorPosition ~= -1 then
				instance.cursorPosition = cursorPosition
			end
			update(instance)
		end
	end)

	update(instance)

	viewFrame.Parent = textBox.Parent
	textBox.Parent = viewFrame

	-- Adding methods to the instance
	instance.GetText = getText
	instance.SetText = setText

	return instance
end

-- Function to create a new TextBox with default settings
local function createTextBox()
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0, 100, 0, 20)
	textBox.BackgroundColor3 = Settings.Theme.TextBox
	textBox.BorderColor3 = Settings.Theme.Outline3
	textBox.ClearTextOnFocus = false
	textBox.TextColor3 = Settings.Theme.Text
	textBox.Font = Enum.Font.SourceSans
	textBox.TextSize = 14
	textBox.Text = ""
	local instance = convertTextBox(textBox)
	instance.GetText = getText
	instance.SetText = setText
	return instance
end

return {
	new = createTextBox,
	convert = convertTextBox,
}
