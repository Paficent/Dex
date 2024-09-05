local Services = require(script.Parent.Parent.Parent.utils.Services)
local Settings = shared.Settings

local textService = Services.TextService

local function initObj(props, mt)
	local function copy(t)
		local res = {}
		for i, v in pairs(t) do
			if type(v) == "table" then
				res[i] = copy(v)
			else
				res[i] = v
			end
		end
		return res
	end

	local newObj = copy(props)
	return setmetatable(newObj, mt)
end
local function getGuiMT(props, funcs)
	return {
		__index = function(self, ind)
			if not props[ind] then
				return funcs[ind] or self.Gui[ind]
			end
		end,
		__newindex = function(self, ind, val)
			if not props[ind] then
				self.Gui[ind] = val
			else
				rawset(self, ind, val)
			end
		end,
	}
end

local props = {
	OffsetX = 0,
	TextBox = newproxy(),
	CursorPos = -1,
	Gui = newproxy(),
	View = newproxy(),
}
local funcs = {}
funcs.Update = function(self)
	local cursorPos = self.CursorPos or -1
	local text = self.TextBox.Text
	if text == "" then
		self.TextBox.Position = UDim2.new(0, 0, 0, 0)
		return
	end
	if cursorPos == -1 then
		return
	end

	local cursorText = text:sub(1, cursorPos - 1)
	local pos = nil
	local leftEnd = -self.TextBox.Position.X.Offset
	local rightEnd = leftEnd + self.View.AbsoluteSize.X

	local totalTextSize =
		textService:GetTextSize(text, self.TextBox.TextSize, self.TextBox.Font, Vector2.new(999999999, 100)).X
	local cursorTextSize =
		textService:GetTextSize(cursorText, self.TextBox.TextSize, self.TextBox.Font, Vector2.new(999999999, 100)).X

	if cursorTextSize > rightEnd then
		pos = math.max(-1, cursorTextSize - self.View.AbsoluteSize.X + 2)
	elseif cursorTextSize < leftEnd then
		pos = math.max(-1, cursorTextSize - 2)
	elseif totalTextSize < rightEnd then
		pos = math.max(-1, totalTextSize - self.View.AbsoluteSize.X + 2)
	end

	if pos then
		self.TextBox.Position = UDim2.new(0, -pos, 0, 0)
		self.TextBox.Size = UDim2.new(1, pos, 1, 0)
	end
end

funcs.GetText = function(self)
	return self.TextBox.Text
end

funcs.SetText = function(self, text)
	self.TextBox.Text = text
end

local mt = getGuiMT(props, funcs)

local function convert(textbox)
	local obj = initObj(props, mt)

	local view = Instance.new("Frame")
	view.BackgroundTransparency = textbox.BackgroundTransparency
	view.BackgroundColor3 = textbox.BackgroundColor3
	view.BorderSizePixel = textbox.BorderSizePixel
	view.BorderColor3 = textbox.BorderColor3
	view.Position = textbox.Position
	view.Size = textbox.Size
	view.ClipsDescendants = true
	view.Name = textbox.Name
	textbox.BackgroundTransparency = 1
	textbox.Position = UDim2.new(0, 0, 0, 0)
	textbox.Size = UDim2.new(1, 0, 1, 0)
	textbox.TextXAlignment = Enum.TextXAlignment.Left
	textbox.Name = "Input"

	obj.TextBox = textbox
	obj.View = view
	obj.Gui = view

	textbox.Changed:Connect(function(prop)
		if prop == "Text" or prop == "CursorPosition" or prop == "AbsoluteSize" then
			local cursorPos = obj.TextBox.CursorPosition
			if cursorPos ~= -1 then
				obj.CursorPos = cursorPos
			end
			obj:Update()
		end
	end)

	obj:Update()

	view.Parent = textbox.Parent
	textbox.Parent = view

	return obj
end

local function new()
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0, 100, 0, 20)
	textBox.BackgroundColor3 = Settings.Theme.TextBox
	textBox.BorderColor3 = Settings.Theme.Outline3
	textBox.ClearTextOnFocus = false
	textBox.TextColor3 = Settings.Theme.Text
	textBox.Font = Enum.Font.SourceSans
	textBox.TextSize = 14
	textBox.Text = ""
	return convert(textBox)
end

return { new = new, convert = convert }
