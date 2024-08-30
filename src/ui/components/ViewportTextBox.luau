local Services = require(script.Parent.Parent.Parent.utils.Services)
local utils = require(script.Parent.Parent.Parent.utils)

local TextService: TextService = Services:Get("TextService")

local Settings = shared.Settings

local defaultProps = {
	offsetX = 0,
	textBox = newproxy(),
	cursorPosition = -1,
	gui = newproxy(),
	view = newproxy(),
}

local MAX_TEXT_WIDTH = 999999999
local DEFAULT_TEXT_SIZE = Vector2.new(MAX_TEXT_WIDTH, 100)

local methods = {}

function methods:update()
	local cursorPosition = self.cursorPosition or -1
	local text = self.textBox.Text

	if text == "" then
		self.textBox.Position = UDim2.new(0, 0, 0, 0)
		return
	end

	if cursorPosition == -1 then
		return
	end

	local cursorText = text:sub(1, cursorPosition - 1)
	local leftEnd = -self.textBox.Position.X.Offset
	local rightEnd = leftEnd + self.view.AbsoluteSize.X

	local totalTextSize = TextService:GetTextSize(text, self.textBox.TextSize, self.textBox.Font, DEFAULT_TEXT_SIZE).X
	local cursorTextSize =
		TextService:GetTextSize(cursorText, self.textBox.TextSize, self.textBox.Font, DEFAULT_TEXT_SIZE).X

	local positionOffset
	if cursorTextSize > rightEnd then
		positionOffset = math.max(-1, cursorTextSize - self.view.AbsoluteSize.X + 2)
	elseif cursorTextSize < leftEnd then
		positionOffset = math.max(-1, cursorTextSize - 2)
	elseif totalTextSize < rightEnd then
		positionOffset = math.max(-1, totalTextSize - self.view.AbsoluteSize.X + 2)
	end

	if positionOffset then
		self.textBox.Position = UDim2.new(0, -positionOffset, 0, 0)
		self.textBox.Size = UDim2.new(1, positionOffset, 1, 0)
	end
end

function methods:getText()
	return self.textBox.Text
end

function methods:setText(text)
	self.textBox.Text = text
end

local metatable = utils.getGuiMT(defaultProps, methods)

local function convertTextBox(textBox)
	local instance = utils.initObj(defaultProps, metatable)

	local viewFrame = Instance.new("Frame")
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

	instance.textBox = textBox
	instance.view = viewFrame
	instance.gui = viewFrame

	textBox.Changed:Connect(function(property)
		if property == "Text" or property == "CursorPosition" or property == "AbsoluteSize" then
			local cursorPosition = instance.textBox.CursorPosition
			if cursorPosition ~= -1 then
				instance.cursorPosition = cursorPosition
			end
			instance:update()
		end
	end)

	instance:update()

	viewFrame.Parent = textBox.Parent
	textBox.Parent = viewFrame

	return instance
end

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
	return convertTextBox(textBox)
end

return {
	new = createTextBox,
	convert = convertTextBox,
}
