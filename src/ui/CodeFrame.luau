local Services = require(script.Parent.Parent.utils.Services)
local components = require(script.Parent).components

local TweenService: TweenService, UserInputService: UserInputService = Services:Get("TweenService", "UserInputService")

local Lib, Settings, create = shared.Apps.Lib, shared.Settings, shared.create

local funcs = {}

local typeMap = {
	[1] = "String",
	[2] = "String",
	[3] = "String",
	[4] = "Comment",
	[5] = "Operator",
	[6] = "Number",
	[7] = "Keyword",
	[8] = "BuiltIn",
	[9] = "LocalMethod",
	[10] = "LocalProperty",
	[11] = "Nil",
	[12] = "Bool",
	[13] = "Function",
	[14] = "Local",
	[15] = "Self",
	[16] = "FunctionName",
	[17] = "Bracket",
}

local specialKeywordsTypes = {
	["nil"] = 11,
	["true"] = 12,
	["false"] = 12,
	["function"] = 13,
	["local"] = 14,
	["self"] = 15,
}

local keywords = {
	["and"] = true,
	["break"] = true,
	["do"] = true,
	["else"] = true,
	["elseif"] = true,
	["end"] = true,
	["false"] = true,
	["for"] = true,
	["function"] = true,
	["if"] = true,
	["in"] = true,
	["local"] = true,
	["nil"] = true,
	["not"] = true,
	["or"] = true,
	["repeat"] = true,
	["return"] = true,
	["then"] = true,
	["true"] = true,
	["until"] = true,
	["while"] = true,
	["plugin"] = true,
}

local builtIns = {
	["delay"] = true,
	["elapsedTime"] = true,
	["require"] = true,
	["spawn"] = true,
	["tick"] = true,
	["time"] = true,
	["typeof"] = true,
	["UserSettings"] = true,
	["wait"] = true,
	["warn"] = true,
	["game"] = true,
	["shared"] = true,
	["script"] = true,
	["workspace"] = true,
	["assert"] = true,
	["collectgarbage"] = true,
	["error"] = true,
	["getfenv"] = true,
	["getmetatable"] = true,
	["ipairs"] = true,
	["loadstring"] = true,
	["newproxy"] = true,
	["next"] = true,
	["pairs"] = true,
	["pcall"] = true,
	["print"] = true,
	["rawequal"] = true,
	["rawget"] = true,
	["rawset"] = true,
	["select"] = true,
	["setfenv"] = true,
	["setmetatable"] = true,
	["tonumber"] = true,
	["tostring"] = true,
	["type"] = true,
	["unpack"] = true,
	["xpcall"] = true,
	["_G"] = true,
	["_VERSION"] = true,
	["coroutine"] = true,
	["debug"] = true,
	["math"] = true,
	["os"] = true,
	["string"] = true,
	["table"] = true,
	["bit32"] = true,
	["utf8"] = true,
	["Axes"] = true,
	["BrickColor"] = true,
	["CFrame"] = true,
	["Color3"] = true,
	["ColorSequence"] = true,
	["ColorSequenceKeypoint"] = true,
	["DockWidgetPluginGuiInfo"] = true,
	["Enum"] = true,
	["Faces"] = true,
	["Instance"] = true,
	["NumberRange"] = true,
	["NumberSequence"] = true,
	["NumberSequenceKeypoint"] = true,
	["PathWaypoint"] = true,
	["PhysicalProperties"] = true,
	["Random"] = true,
	["Ray"] = true,
	["Rect"] = true,
	["Region3"] = true,
	["Region3int16"] = true,
	["TweenInfo"] = true,
	["UDim"] = true,
	["UDim2"] = true,
	["Vector2"] = true,
	["Vector2int16"] = true,
	["Vector3"] = true,
	["Vector3int16"] = true,
}

local builtInInited = false

local richReplace = {
	["'"] = "&apos;",
	['"'] = "&quot;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	["&"] = "&amp;",
}

local tabSub = "\205"
local tabReplacement = (" %s%s "):format(tabSub, tabSub)

local tabJumps = {
	[("[^%s] %s"):format(tabSub, tabSub)] = 0,
	[(" %s%s"):format(tabSub, tabSub)] = -1,
	[("%s%s "):format(tabSub, tabSub)] = 2,
	[("%s [^%s]"):format(tabSub, tabSub)] = 1,
}

local lineTweens = {}

local function initBuiltIn()
	local env = getfenv()
	local type = type
	local tostring = tostring
	for name, _ in builtIns do
		local envVal = env[name]
		if type(envVal) == "table" then
			local items = {}
			for i, v in envVal do
				items[i] = true
			end
			builtIns[name] = items
		end
	end

	local enumEntries = {}
	local enums = Enum:GetEnums()
	for i = 1, #enums do
		enumEntries[tostring(enums[i])] = true
	end
	builtIns["Enum"] = enumEntries

	builtInInited = true
end

local function setupEditBox(obj)
	local editBox = obj.GuiElems.EditBox

	editBox.Focused:Connect(function()
		obj:ConnectEditBoxEvent()
		obj.Editing = true
	end)

	editBox.FocusLost:Connect(function()
		obj:DisconnectEditBoxEvent()
		obj.Editing = false
	end)

	editBox:GetPropertyChangedSignal("Text"):Connect(function()
		local text = editBox.Text
		if #text == 0 or obj.EditBoxCopying then
			return
		end
		editBox.Text = ""
		obj:AppendText(text)
	end)
end

local function setupMouseSelection(obj)
	local mouse = Services.Players.LocalPlayer:GetMouse()
	local codeFrame = obj.GuiElems.LinesFrame
	local lines = obj.Lines

	codeFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local fontSizeX, fontSizeY = math.ceil(obj.FontSize / 2), obj.FontSize

			local relX = mouse.X - codeFrame.AbsolutePosition.X
			local relY = mouse.Y - codeFrame.AbsolutePosition.Y
			local selX = math.round(relX / fontSizeX) + obj.ViewX
			local selY = math.floor(relY / fontSizeY) + obj.ViewY
			local releaseEvent, mouseEvent, scrollEvent
			local scrollPowerV, scrollPowerH = 0, 0
			selY = math.min(#lines - 1, selY)
			local relativeLine = lines[selY + 1] or ""
			selX = math.min(#relativeLine, selX + obj:TabAdjust(selX, selY))

			obj.SelectionRange = { { -1, -1 }, { -1, -1 } }
			obj:MoveCursor(selX, selY)
			obj.FloatCursorX = selX

			local function updateSelection()
				local relX = mouse.X - codeFrame.AbsolutePosition.X
				local relY = mouse.Y - codeFrame.AbsolutePosition.Y
				local sel2X = math.max(0, math.round(relX / fontSizeX) + obj.ViewX)
				local sel2Y = math.max(0, math.floor(relY / fontSizeY) + obj.ViewY)

				sel2Y = math.min(#lines - 1, sel2Y)
				local relativeLine = lines[sel2Y + 1] or ""
				sel2X = math.min(#relativeLine, sel2X + obj:TabAdjust(sel2X, sel2Y))

				if sel2Y < selY or (sel2Y == selY and sel2X < selX) then
					obj.SelectionRange = { { sel2X, sel2Y }, { selX, selY } }
				else
					obj.SelectionRange = { { selX, selY }, { sel2X, sel2Y } }
				end

				obj:MoveCursor(sel2X, sel2Y)
				obj.FloatCursorX = sel2X
				obj:Refresh()
			end

			releaseEvent = UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					releaseEvent:Disconnect()
					mouseEvent:Disconnect()
					scrollEvent:Disconnect()
					obj:SetCopyableSelection()
					--updateSelection()
				end
			end)

			mouseEvent = UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					local upDelta = mouse.Y - codeFrame.AbsolutePosition.Y
					local downDelta = mouse.Y - codeFrame.AbsolutePosition.Y - codeFrame.AbsoluteSize.Y
					local leftDelta = mouse.X - codeFrame.AbsolutePosition.X
					local rightDelta = mouse.X - codeFrame.AbsolutePosition.X - codeFrame.AbsoluteSize.X
					scrollPowerV = 0
					scrollPowerH = 0
					if downDelta > 0 then
						scrollPowerV = math.floor(downDelta * 0.05) + 1
					elseif upDelta < 0 then
						scrollPowerV = math.ceil(upDelta * 0.05) - 1
					end
					if rightDelta > 0 then
						scrollPowerH = math.floor(rightDelta * 0.05) + 1
					elseif leftDelta < 0 then
						scrollPowerH = math.ceil(leftDelta * 0.05) - 1
					end
					updateSelection()
				end
			end)

			scrollEvent = game:GetService("RunService").RenderStepped:Connect(function()
				if scrollPowerV ~= 0 or scrollPowerH ~= 0 then
					obj:ScrollDelta(scrollPowerH, scrollPowerV)
					updateSelection()
				end
			end)

			obj:Refresh()
		end
	end)
end

local function makeFrame(obj)
	local frame = create({
		{
			1,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.15686275064945, 0.15686275064945, 0.15686275064945),
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, -300, 0.5, -200),
				Size = UDim2.new(0, 600, 0, 400),
			},
		},
	})
	local elems = {}

	local linesFrame = Instance.new("Frame")
	linesFrame.Name = "Lines"
	linesFrame.BackgroundTransparency = 1
	linesFrame.Size = UDim2.new(1, 0, 1, 0)
	linesFrame.ClipsDescendants = true
	linesFrame.Parent = frame

	local lineNumbersLabel = Instance.new("TextLabel")
	lineNumbersLabel.Name = "LineNumbers"
	lineNumbersLabel.BackgroundTransparency = 1
	lineNumbersLabel.Font = Enum.Font.Code
	lineNumbersLabel.TextXAlignment = Enum.TextXAlignment.Right
	lineNumbersLabel.TextYAlignment = Enum.TextYAlignment.Top
	lineNumbersLabel.ClipsDescendants = true
	lineNumbersLabel.RichText = true
	lineNumbersLabel.Parent = frame

	local cursor = Instance.new("Frame")
	cursor.Name = "Cursor"
	cursor.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	cursor.BorderSizePixel = 0
	cursor.Parent = frame

	local editBox = Instance.new("TextBox")
	editBox.Name = "EditBox"
	editBox.MultiLine = true
	editBox.Visible = false
	editBox.Parent = frame

	lineTweens.Invis = TweenService:Create(
		cursor,
		TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 1 }
	)
	lineTweens.Vis = TweenService:Create(
		cursor,
		TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 0 }
	)

	elems.LinesFrame = linesFrame
	elems.LineNumbersLabel = lineNumbersLabel
	elems.Cursor = cursor
	elems.EditBox = editBox
	elems.ScrollCorner = create({
		{
			1,
			"Frame",
			{
				BackgroundColor3 = Color3.new(0.15686275064945, 0.15686275064945, 0.15686275064945),
				BorderSizePixel = 0,
				Name = "ScrollCorner",
				Position = UDim2.new(1, -16, 1, -16),
				Size = UDim2.new(0, 16, 0, 16),
				Visible = false,
			},
		},
	})

	elems.ScrollCorner.Parent = frame
	linesFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			obj:SetEditing(true, input)
		end
	end)

	obj.Frame = frame
	obj.Gui = frame
	obj.GuiElems = elems
	setupEditBox(obj)
	setupMouseSelection(obj)

	return frame
end

funcs.GetSelectionText = function(self)
	if not self:IsValidRange() then
		return ""
	end

	local selectionRange = self.SelectionRange
	local selX, selY = selectionRange[1][1], selectionRange[1][2]
	local sel2X, sel2Y = selectionRange[2][1], selectionRange[2][2]
	local deltaLines = sel2Y - selY
	local lines = self.Lines

	if not lines[selY + 1] or not lines[sel2Y + 1] then
		return ""
	end

	if deltaLines == 0 then
		return self:ConvertText(lines[selY + 1]:sub(selX + 1, sel2X), false)
	end

	local leftSub = lines[selY + 1]:sub(selX + 1)
	local rightSub = lines[sel2Y + 1]:sub(1, sel2X)

	local result = leftSub .. "\n"
	for i = selY + 1, sel2Y - 1 do
		result = result .. lines[i + 1] .. "\n"
	end
	result = result .. rightSub

	return self:ConvertText(result, false)
end

funcs.SetCopyableSelection = function(self)
	local text = self:GetSelectionText()
	local editBox = self.GuiElems.EditBox

	self.EditBoxCopying = true
	editBox.Text = text
	editBox.SelectionStart = 1
	editBox.CursorPosition = #editBox.Text + 1
	self.EditBoxCopying = false
end

funcs.ConnectEditBoxEvent = function(self)
	if self.EditBoxEvent then
		self.EditBoxEvent:Disconnect()
	end

	self.EditBoxEvent = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local keycodes = Enum.KeyCode
		local keycode = input.KeyCode

		local function setupMove(key, func)
			local endCon, finished
			endCon = UserInputService.InputEnded:Connect(function(input)
				if input.KeyCode ~= key then
					return
				end
				endCon:Disconnect()
				finished = true
			end)
			func()
			Lib.FastWait(0.5)
			while not finished do
				func()
				Lib.FastWait(0.03)
			end
		end

		if keycode == keycodes.Down then
			setupMove(keycodes.Down, function()
				self.CursorX = self.FloatCursorX
				self.CursorY = self.CursorY + 1
				self:UpdateCursor()
				self:JumpToCursor()
			end)
		elseif keycode == keycodes.Up then
			setupMove(keycodes.Up, function()
				self.CursorX = self.FloatCursorX
				self.CursorY = self.CursorY - 1
				self:UpdateCursor()
				self:JumpToCursor()
			end)
		elseif keycode == keycodes.Left then
			setupMove(keycodes.Left, function()
				local line = self.Lines[self.CursorY + 1] or ""
				self.CursorX = self.CursorX
					- 1
					- (line:sub(self.CursorX - 3, self.CursorX) == tabReplacement and 3 or 0)
				if self.CursorX < 0 then
					self.CursorY = self.CursorY - 1
					local line2 = self.Lines[self.CursorY + 1] or ""
					self.CursorX = #line2
				end
				self.FloatCursorX = self.CursorX
				self:UpdateCursor()
				self:JumpToCursor()
			end)
		elseif keycode == keycodes.Right then
			setupMove(keycodes.Right, function()
				local line = self.Lines[self.CursorY + 1] or ""
				self.CursorX = self.CursorX
					+ 1
					+ (line:sub(self.CursorX + 1, self.CursorX + 4) == tabReplacement and 3 or 0)
				if self.CursorX > #line then
					self.CursorY = self.CursorY + 1
					self.CursorX = 0
				end
				self.FloatCursorX = self.CursorX
				self:UpdateCursor()
				self:JumpToCursor()
			end)
		elseif keycode == keycodes.Backspace then
			setupMove(keycodes.Backspace, function()
				local startRange, endRange
				if self:IsValidRange() then
					startRange = self.SelectionRange[1]
					endRange = self.SelectionRange[2]
				else
					endRange = { self.CursorX, self.CursorY }
				end

				if not startRange then
					local line = self.Lines[self.CursorY + 1] or ""
					self.CursorX = self.CursorX
						- 1
						- (line:sub(self.CursorX - 3, self.CursorX) == tabReplacement and 3 or 0)
					if self.CursorX < 0 then
						self.CursorY = self.CursorY - 1
						local line2 = self.Lines[self.CursorY + 1] or ""
						self.CursorX = #line2
					end
					self.FloatCursorX = self.CursorX
					self:UpdateCursor()

					startRange = startRange or { self.CursorX, self.CursorY }
				end

				self:DeleteRange({ startRange, endRange }, false, true)
				self:ResetSelection(true)
				self:JumpToCursor()
			end)
		elseif keycode == keycodes.Delete then
			setupMove(keycodes.Delete, function()
				local startRange, endRange
				if self:IsValidRange() then
					startRange = self.SelectionRange[1]
					endRange = self.SelectionRange[2]
				else
					startRange = { self.CursorX, self.CursorY }
				end

				if not endRange then
					local line = self.Lines[self.CursorY + 1] or ""
					local endCursorX = self.CursorX
						+ 1
						+ (line:sub(self.CursorX + 1, self.CursorX + 4) == tabReplacement and 3 or 0)
					local endCursorY = self.CursorY
					if endCursorX > #line then
						endCursorY = endCursorY + 1
						endCursorX = 0
					end
					self:UpdateCursor()

					endRange = endRange or { endCursorX, endCursorY }
				end

				self:DeleteRange({ startRange, endRange }, false, true)
				self:ResetSelection(true)
				self:JumpToCursor()
			end)
		elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			if keycode == keycodes.A then
				self.SelectionRange = { { 0, 0 }, { #self.Lines[#self.Lines], #self.Lines - 1 } }
				self:SetCopyableSelection()
				self:Refresh()
			end
		end
	end)
end

funcs.DisconnectEditBoxEvent = function(self)
	if self.EditBoxEvent then
		self.EditBoxEvent:Disconnect()
	end
end

funcs.ResetSelection = function(self, norefresh)
	self.SelectionRange = { { -1, -1 }, { -1, -1 } }
	if not norefresh then
		self:Refresh()
	end
end

funcs.IsValidRange = function(self, range)
	local selectionRange = range or self.SelectionRange
	local selX, selY = selectionRange[1][1], selectionRange[1][2]
	local sel2X, sel2Y = selectionRange[2][1], selectionRange[2][2]

	if selX == -1 or (selX == sel2X and selY == sel2Y) then
		return false
	end

	return true
end

funcs.DeleteRange = function(self, range, noprocess, updatemouse)
	range = range or self.SelectionRange
	if not self:IsValidRange(range) then
		return
	end

	local lines = self.Lines
	local selX, selY = range[1][1], range[1][2]
	local sel2X, sel2Y = range[2][1], range[2][2]
	local deltaLines = sel2Y - selY

	if not lines[selY + 1] or not lines[sel2Y + 1] then
		return
	end

	local leftSub = lines[selY + 1]:sub(1, selX)
	local rightSub = lines[sel2Y + 1]:sub(sel2X + 1)
	lines[selY + 1] = leftSub .. rightSub

	local remove = table.remove
	for i = 1, deltaLines do
		remove(lines, selY + 2)
	end

	if range == self.SelectionRange then
		self.SelectionRange = { { -1, -1 }, { -1, -1 } }
	end
	if updatemouse then
		self.CursorX = selX
		self.CursorY = selY
		self:UpdateCursor()
	end

	if not noprocess then
		self:ProcessTextChange()
	end
end

funcs.AppendText = function(self, text)
	self:DeleteRange(nil, true, true)
	local lines, cursorX, cursorY = self.Lines, self.CursorX, self.CursorY
	local line = lines[cursorY + 1]
	local before = line:sub(1, cursorX)
	local after = line:sub(cursorX + 1)

	text = text:gsub("\r\n", "\n")
	text = text:gsub("\t", "    ")
	text = self:ConvertText(text, true) -- Tab Convert

	local textLines = text:split("\n")
	local insert = table.insert

	for i = 1, #textLines do
		local linePos = cursorY + i
		if i > 1 then
			insert(lines, linePos, "")
		end

		local textLine = textLines[i]
		local newBefore = (i == 1 and before or "")
		local newAfter = (i == #textLines and after or "")

		lines[linePos] = newBefore .. textLine .. newAfter
	end

	if #textLines > 1 then
		cursorX = 0
	end

	self:ProcessTextChange()
	self.CursorX = cursorX + #textLines[#textLines]
	self.CursorY = cursorY + #textLines - 1
	self:UpdateCursor()
end

funcs.ScrollDelta = function(self, x, y)
	self.ScrollV:ScrollTo(self.ScrollV.Index + y)
	self.ScrollH:ScrollTo(self.ScrollH.Index + x)
end

-- x and y starts at 0
funcs.TabAdjust = function(self, x, y)
	local lines = self.Lines
	local line = lines[y + 1]
	x = x + 1

	if line then
		local left = line:sub(x - 1, x - 1)
		local middle = line:sub(x, x)
		local right = line:sub(x + 1, x + 1)
		local selRange = (#left > 0 and left or " ") .. (#middle > 0 and middle or " ") .. (#right > 0 and right or " ")

		for i, v in pairs(tabJumps) do
			if selRange:find(i) then
				return v
			end
		end
	end
	return 0
end

funcs.SetEditing = function(self, on, input)
	self:UpdateCursor(input)

	if on then
		if self.Editable then
			self.GuiElems.EditBox.Text = ""
			self.GuiElems.EditBox:CaptureFocus()
		end
	else
		self.GuiElems.EditBox:ReleaseFocus()
	end
end

funcs.CursorAnim = function(self, on)
	local cursor = self.GuiElems.Cursor
	local animTime = tick()
	self.LastAnimTime = animTime

	if not on then
		return
	end

	lineTweens.Invis:Cancel()
	lineTweens.Vis:Cancel()
	cursor.BackgroundTransparency = 0

	coroutine.wrap(function()
		while self.Editable do
			Lib.FastWait(0.5)
			if self.LastAnimTime ~= animTime then
				return
			end
			lineTweens.Invis:Play()
			Lib.FastWait(0.4)
			if self.LastAnimTime ~= animTime then
				return
			end
			lineTweens.Vis:Play()
			Lib.FastWait(0.2)
		end
	end)()
end

funcs.MoveCursor = function(self, x, y)
	self.CursorX = x
	self.CursorY = y
	self:UpdateCursor()
	self:JumpToCursor()
end

funcs.JumpToCursor = function(self)
	self:Refresh()
end

funcs.UpdateCursor = function(self, input)
	local linesFrame = self.GuiElems.LinesFrame
	local cursor = self.GuiElems.Cursor
	local hSize = math.max(0, linesFrame.AbsoluteSize.X)
	local vSize = math.max(0, linesFrame.AbsoluteSize.Y)
	local maxLines = math.ceil(vSize / self.FontSize)
	local maxCols = math.ceil(hSize / math.ceil(self.FontSize / 2))
	local viewX, viewY = self.ViewX, self.ViewY
	local totalLinesStr = tostring(#self.Lines)
	local fontWidth = math.ceil(self.FontSize / 2)
	local linesOffset = #totalLinesStr * fontWidth + 4 * fontWidth

	if input then
		linesFrame = self.GuiElems.LinesFrame
		local frameX, frameY = linesFrame.AbsolutePosition.X, linesFrame.AbsolutePosition.Y
		local mouseX, mouseY = input.Position.X, input.Position.Y
		local fontSizeX, fontSizeY = math.ceil(self.FontSize / 2), self.FontSize

		self.CursorX = self.ViewX + math.round((mouseX - frameX) / fontSizeX)
		self.CursorY = self.ViewY + math.floor((mouseY - frameY) / fontSizeY)
	end

	local cursorX, cursorY = self.CursorX, self.CursorY

	local line = self.Lines[cursorY + 1] or ""
	if cursorX > #line then
		cursorX = #line
	elseif cursorX < 0 then
		cursorX = 0
	end

	if cursorY >= #self.Lines then
		cursorY = math.max(0, #self.Lines - 1)
	elseif cursorY < 0 then
		cursorY = 0
	end

	cursorX = cursorX + self:TabAdjust(cursorX, cursorY)

	-- Update modified
	self.CursorX = cursorX
	self.CursorY = cursorY

	local cursorVisible = (cursorX >= viewX)
		and (cursorY >= viewY)
		and (cursorX <= viewX + maxCols)
		and (cursorY <= viewY + maxLines)
	if cursorVisible then
		local offX = (cursorX - viewX)
		local offY = (cursorY - viewY)
		cursor.Position = UDim2.new(0, linesOffset + offX * math.ceil(self.FontSize / 2) - 1, 0, offY * self.FontSize)
		cursor.Size = UDim2.new(0, 1, 0, self.FontSize + 2)
		cursor.Visible = true
		self:CursorAnim(true)
	else
		cursor.Visible = false
	end
end

funcs.MapNewLines = function(self)
	local newLines = {}
	local count = 1
	local text = self.Text
	local find = string.find
	local init = 1

	local pos = find(text, "\n", init, true)
	while pos do
		newLines[count] = pos
		count = count + 1
		init = pos + 1
		pos = find(text, "\n", init, true)
	end

	self.NewLines = newLines
end

funcs.PreHighlight = function(self)
	local text = self.Text:gsub("\\\\", "  ")
	local textLen = #text
	local found = {}
	local foundMap = {}
	local extras = {}
	local find = string.find
	local sub = string.sub
	self.ColoredLines = {}

	local function findAll(str, pattern, typ, raw)
		local count = #found + 1
		local init = 1
		local x, y, extra = find(str, pattern, init, raw)
		while x do
			found[count] = x
			foundMap[x] = typ
			if extra then
				extras[x] = extra
			end

			count = count + 1
			init = y + 1
			x, y, extra = find(str, pattern, init, raw)
		end
	end
	findAll(text, '"', 1, true)
	findAll(text, "'", 2, true)
	findAll(text, "%[(=*)%[", 3)
	findAll(text, "--", 4, true)
	table.sort(found)

	local newLines = self.NewLines
	local curLine = 0
	local lineEnd = 0
	local lastEnding = 0
	local foundHighlights = {}

	for i = 1, #found do
		local pos = found[i]
		if pos <= lastEnding then
			continue
		end

		local ending = pos
		local typ = foundMap[pos]
		if typ == 1 then
			ending = find(text, '"', pos + 1, true)
			while ending and sub(text, ending - 1, ending - 1) == "\\" do
				ending = find(text, '"', ending + 1, true)
			end
			if not ending then
				ending = textLen
			end
		elseif typ == 2 then
			ending = find(text, "'", pos + 1, true)
			while ending and sub(text, ending - 1, ending - 1) == "\\" do
				ending = find(text, "'", ending + 1, true)
			end
			if not ending then
				ending = textLen
			end
		elseif typ == 3 then
			_, ending = find(text, "]" .. extras[pos] .. "]", pos + 1, true)
			if not ending then
				ending = textLen
			end
		elseif typ == 4 then
			local ahead = foundMap[pos + 2]

			if ahead == 3 then
				_, ending = find(text, "]" .. extras[pos + 2] .. "]", pos + 1, true)
				if not ending then
					ending = textLen
				end
			else
				ending = find(text, "\n", pos + 1, true) or textLen
			end
		end

		while pos > lineEnd do
			curLine = curLine + 1
			lineEnd = newLines[curLine] or textLen + 1
		end
		while true do
			local lineTable = foundHighlights[curLine]
			if not lineTable then
				lineTable = {}
				foundHighlights[curLine] = lineTable
			end
			lineTable[pos] = { typ, ending }

			if ending > lineEnd then
				curLine = curLine + 1
				lineEnd = newLines[curLine] or textLen + 1
			else
				break
			end
		end

		lastEnding = ending
	end
	self.PreHighlights = foundHighlights
end

funcs.HighlightLine = function(self, line)
	local cached = self.ColoredLines[line]
	if cached then
		return cached
	end

	local sub = string.sub
	local find = string.find
	local match = string.match
	local highlights = {}
	local preHighlights = self.PreHighlights[line] or {}
	local lineText = self.Lines[line] or ""
	local lastEnding = 0
	local currentType = 0
	local lastWord = nil
	local wordBeginsDotted = false
	local funcStatus = 0
	local lineStart = self.NewLines[line - 1] or 0

	local preHighlightMap = {}
	for pos, data in preHighlights do
		local relativePos = pos - lineStart
		if relativePos < 1 then
			currentType = data[1]
			lastEnding = data[2] - lineStart
			--warn(pos,data[2])
		else
			preHighlightMap[relativePos] = { data[1], data[2] - lineStart }
		end
	end

	for col = 1, #lineText do
		if col <= lastEnding then
			highlights[col] = currentType
			continue
		end

		local pre = preHighlightMap[col]
		if pre then
			currentType = pre[1]
			lastEnding = pre[2]
			highlights[col] = currentType
			wordBeginsDotted = false
			lastWord = nil
			funcStatus = 0
		else
			local char = sub(lineText, col, col)
			if find(char, "[%a_]") then
				local word = match(lineText, "[%a%d_]+", col)
				local wordType = (keywords[word] and 7) or (builtIns[word] and 8)

				lastEnding = col + #word - 1

				if wordType ~= 7 then
					if wordBeginsDotted then
						local prevBuiltIn = lastWord and builtIns[lastWord]
						wordType = (prevBuiltIn and type(prevBuiltIn) == "table" and prevBuiltIn[word] and 8) or 10
					end

					if wordType ~= 8 then
						local x, _y, br = find(lineText, "^%s*([%({\"'])", lastEnding + 1)
						if x then
							wordType = (funcStatus > 0 and br == "(" and 16) or 9
							funcStatus = 0
						end
					end
				else
					wordType = specialKeywordsTypes[word] or wordType
					funcStatus = (word == "function" and 1 or 0)
				end

				lastWord = word
				wordBeginsDotted = false
				if funcStatus > 0 then
					funcStatus = 1
				end

				if wordType then
					currentType = wordType
					highlights[col] = currentType
				else
					currentType = nil
				end
			elseif find(char, "%p") then
				local isDot = (char == ".")
				local isNum = isDot and find(sub(lineText, col + 1, col + 1), "%d")
				highlights[col] = (isNum and 6 or 5)

				if not isNum then
					local dotStr = isDot and match(lineText, "%.%.?%.?", col)
					if dotStr and #dotStr > 1 then
						currentType = 5
						lastEnding = col + #dotStr - 1
						wordBeginsDotted = false
						lastWord = nil
						funcStatus = 0
					else
						if isDot then
							if wordBeginsDotted then
								lastWord = nil
							else
								wordBeginsDotted = true
							end
						else
							wordBeginsDotted = false
							lastWord = nil
						end

						funcStatus = ((isDot or char == ":") and funcStatus == 1 and 2) or 0
					end
				end
			elseif find(char, "%d") then
				local _, endPos = find(lineText, "%x+", col)
				local endPart = sub(lineText, endPos, endPos + 1)
				if (endPart == "e+" or endPart == "e-") and find(sub(lineText, endPos + 2, endPos + 2), "%d") then
					endPos = endPos + 1
				end
				currentType = 6
				lastEnding = endPos
				highlights[col] = 6
				wordBeginsDotted = false
				lastWord = nil
				funcStatus = 0
			else
				highlights[col] = currentType
				local _, endPos = find(lineText, "%s+", col)
				if endPos then
					lastEnding = endPos
				end
			end
		end
	end

	self.ColoredLines[line] = highlights
	return highlights
end

funcs.Refresh = function(self)
	local linesFrame = self.Frame.Lines
	local hSize = math.max(0, linesFrame.AbsoluteSize.X)
	local vSize = math.max(0, linesFrame.AbsoluteSize.Y)
	local maxLines = math.ceil(vSize / self.FontSize)
	local maxCols = math.ceil(hSize / math.ceil(self.FontSize / 2))
	local gsub = string.gsub
	local sub = string.sub

	local viewX, viewY = self.ViewX, self.ViewY

	local lineNumberStr = ""

	for row = 1, maxLines do
		local lineFrame = self.LineFrames[row]
		if not lineFrame then
			lineFrame = Instance.new("Frame")
			lineFrame.Name = "Line"
			lineFrame.Position = UDim2.new(0, 0, 0, (row - 1) * self.FontSize)
			lineFrame.Size = UDim2.new(1, 0, 0, self.FontSize)
			lineFrame.BorderSizePixel = 0
			lineFrame.BackgroundTransparency = 1

			local selectionHighlight = Instance.new("Frame")
			selectionHighlight.Name = "SelectionHighlight"
			selectionHighlight.BorderSizePixel = 0
			selectionHighlight.BackgroundColor3 = Settings.Theme.Syntax.SelectionBack
			selectionHighlight.Parent = lineFrame

			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Code
			label.TextSize = self.FontSize
			label.Size = UDim2.new(1, 0, 0, self.FontSize)
			label.RichText = true
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextColor3 = self.Colors.Text
			label.ZIndex = 2
			label.Parent = lineFrame

			lineFrame.Parent = linesFrame
			self.LineFrames[row] = lineFrame
		end

		local relaY = viewY + row
		local lineText = self.Lines[relaY] or ""
		local resText = ""
		local highlights = self:HighlightLine(relaY)
		local colStart = viewX + 1

		local richTemplates = self.RichTemplates
		local textTemplate = richTemplates.Text
		local selectionTemplate = richTemplates.Selection
		local curType = highlights[colStart]
		local curTemplate = richTemplates[typeMap[curType]] or textTemplate

		-- Selection Highlight
		local selectionRange = self.SelectionRange
		local selPos1 = selectionRange[1]
		local selPos2 = selectionRange[2]
		local selRow, selColumn = selPos1[2], selPos1[1]
		local sel2Row, sel2Column = selPos2[2], selPos2[1]
		local selRelaY = relaY - 1

		if selRelaY >= selPos1[2] and selRelaY <= selPos2[2] then
			local fontSizeX = math.ceil(self.FontSize / 2)
			local posX = (selRelaY == selPos1[2] and selPos1[1] or 0) - viewX
			local sizeX = (selRelaY == selPos2[2] and selPos2[1] - posX - viewX or maxCols + viewX)

			lineFrame.SelectionHighlight.Position = UDim2.new(0, posX * fontSizeX, 0, 0)
			lineFrame.SelectionHighlight.Size = UDim2.new(0, sizeX * fontSizeX, 1, 0)
			lineFrame.SelectionHighlight.Visible = true
		else
			lineFrame.SelectionHighlight.Visible = false
		end

		-- Selection Text Color for first char
		local inSelection = selRelaY >= selRow
			and selRelaY <= sel2Row
			and (selRelaY == selRow and viewX >= selColumn or selRelaY ~= selRow)
			and (selRelaY == sel2Row and viewX < sel2Column or selRelaY ~= sel2Row)
		if inSelection then
			curType = -999
			curTemplate = selectionTemplate
		end

		for col = 2, maxCols do
			local relaX = viewX + col
			local selRelaX = relaX - 1
			local posType = highlights[relaX]

			-- Selection Text Color
			inSelection = selRelaY >= selRow
				and selRelaY <= sel2Row
				and (selRelaY == selRow and selRelaX >= selColumn or selRelaY ~= selRow)
				and (selRelaY == sel2Row and selRelaX < sel2Column or selRelaY ~= sel2Row)
			if inSelection then
				posType = -999
			end

			if posType ~= curType then
				local template = (inSelection and selectionTemplate) or richTemplates[typeMap[posType]] or textTemplate

				if template ~= curTemplate then
					local nextText = gsub(sub(lineText, colStart, relaX - 1), "['\"<>&]", richReplace)
					resText = resText
						.. (curTemplate ~= textTemplate and (curTemplate .. nextText .. "</font>") or nextText)
					colStart = relaX
					curTemplate = template
				end
				curType = posType
			end
		end

		local lastText = gsub(sub(lineText, colStart, viewX + maxCols), "['\"<>&]", richReplace)
		--warn("SUB",colStart,viewX+maxCols-1)
		if #lastText > 0 then
			resText = resText .. (curTemplate ~= textTemplate and (curTemplate .. lastText .. "</font>") or lastText)
		end

		if self.Lines[relaY] then
			lineNumberStr = lineNumberStr .. (relaY == self.CursorY and ("<b>" .. relaY .. "</b>\n") or relaY .. "\n")
		end

		lineFrame.Label.Text = resText
	end

	for i = maxLines + 1, #self.LineFrames do
		self.LineFrames[i]:Destroy()
		self.LineFrames[i] = nil
	end

	self.Frame.LineNumbers.Text = lineNumberStr
	self:UpdateCursor()

	--print("REFRESH TIME",tick()-start)
end

funcs.UpdateView = function(self)
	local totalLinesStr = tostring(#self.Lines)
	local fontWidth = math.ceil(self.FontSize / 2)
	local linesOffset = #totalLinesStr * fontWidth + 4 * fontWidth

	local linesFrame = self.Frame.Lines
	local hSize = linesFrame.AbsoluteSize.X
	local vSize = linesFrame.AbsoluteSize.Y
	local maxLines = math.ceil(vSize / self.FontSize)
	local totalWidth = self.MaxTextCols * fontWidth
	local scrollV = self.ScrollV
	local scrollH = self.ScrollH

	scrollV.VisibleSpace = maxLines
	scrollV.TotalSpace = #self.Lines + 1
	scrollH.VisibleSpace = math.ceil(hSize / fontWidth)
	scrollH.TotalSpace = self.MaxTextCols + 1

	scrollV.Gui.Visible = #self.Lines + 1 > maxLines
	scrollH.Gui.Visible = totalWidth > hSize

	local oldOffsets = self.FrameOffsets
	self.FrameOffsets = Vector2.new(scrollV.Gui.Visible and -16 or 0, scrollH.Gui.Visible and -16 or 0)
	if oldOffsets ~= self.FrameOffsets then
		self:UpdateView()
	else
		scrollV:ScrollTo(self.ViewY, true)
		scrollH:ScrollTo(self.ViewX, true)

		if scrollV.Gui.Visible and scrollH.Gui.Visible then
			scrollV.Gui.Size = UDim2.new(0, 16, 1, -16)
			scrollH.Gui.Size = UDim2.new(1, -16, 0, 16)
			self.GuiElems.ScrollCorner.Visible = true
		else
			scrollV.Gui.Size = UDim2.new(0, 16, 1, 0)
			scrollH.Gui.Size = UDim2.new(1, 0, 0, 16)
			self.GuiElems.ScrollCorner.Visible = false
		end

		self.ViewY = scrollV.Index
		self.ViewX = scrollH.Index
		self.Frame.Lines.Position = UDim2.new(0, linesOffset, 0, 0)
		self.Frame.Lines.Size = UDim2.new(1, -linesOffset + oldOffsets.X, 1, oldOffsets.Y)
		self.Frame.LineNumbers.Position = UDim2.new(0, fontWidth, 0, 0)
		self.Frame.LineNumbers.Size = UDim2.new(0, #totalLinesStr * fontWidth, 1, oldOffsets.Y)
		self.Frame.LineNumbers.TextSize = self.FontSize
	end
end

funcs.ProcessTextChange = function(self)
	local maxCols = 0
	local lines = self.Lines

	for i = 1, #lines do
		local lineLen = #lines[i]
		if lineLen > maxCols then
			maxCols = lineLen
		end
	end

	self.MaxTextCols = maxCols
	self:UpdateView()
	self.Text = table.concat(self.Lines, "\n")
	self:MapNewLines()
	self:PreHighlight()
	self:Refresh()
	--self.TextChanged:Fire()
end

funcs.ConvertText = function(self, text, toEditor)
	if toEditor then
		return text:gsub("\t", (" %s%s "):format(tabSub, tabSub))
	else
		return text:gsub((" %s%s "):format(tabSub, tabSub), "\t")
	end
end

funcs.GetText = function(self) -- TODO: better (use new tab format)
	local source = table.concat(self.Lines, "\n")
	return self:ConvertText(source, false) -- Tab Convert
end

funcs.SetText = function(self, txt)
	txt:gsub("\t", "    ")
	txt = self:ConvertText(txt, true) -- Tab Convert
	local lines = self.Lines
	table.clear(lines)
	local count = 1

	for line in txt:gmatch("([^\n\r]*)[\n\r]?") do
		lines[count] = line
		count = count + 1
	end

	self:ProcessTextChange()
end

funcs.MakeRichTemplates = function(self)
	local floor = math.floor
	local templates = {}

	for name, color in self.Colors do
		templates[name] = ('<font color="rgb(%s,%s,%s)">'):format(
			floor(color.r * 255),
			floor(color.g * 255),
			floor(color.b * 255)
		)
	end

	self.RichTemplates = templates
end

funcs.ApplyTheme = function(self)
	local colors = Settings.Theme.Syntax
	self.Colors = colors
	self.Frame.LineNumbers.TextColor3 = colors.Text
	self.Frame.BackgroundColor3 = colors.Background
end

local mt = { __index = funcs }

local function new()
	if not builtInInited then
		initBuiltIn()
	end

	local scrollV = components.ScrollBar.new()
	local scrollH = components.ScrollBar.new(true)
	scrollH.Gui.Position = UDim2.new(0, 0, 1, -16)
	local obj = setmetatable({
		FontSize = 15,
		ViewX = 0,
		ViewY = 0,
		Colors = Settings.Theme.Syntax,
		ColoredLines = {},
		Lines = { "" },
		LineFrames = {},
		Editable = true,
		Editing = false,
		CursorX = 0,
		CursorY = 0,
		FloatCursorX = 0,
		Text = "",
		PreHighlights = {},
		SelectionRange = { { -1, -1 }, { -1, -1 } },
		NewLines = {},
		FrameOffsets = Vector2.new(0, 0),
		MaxTextCols = 0,
		ScrollV = scrollV,
		ScrollH = scrollH,
	}, mt)

	scrollV.WheelIncrement = 3
	scrollH.Increment = 2
	scrollH.WheelIncrement = 7

	scrollV.Scrolled:Connect(function()
		obj.ViewY = scrollV.Index
		obj:Refresh()
	end)

	scrollH.Scrolled:Connect(function()
		obj.ViewX = scrollH.Index
		obj:Refresh()
	end)

	makeFrame(obj)
	obj:MakeRichTemplates()
	obj:ApplyTheme()
	scrollV:SetScrollFrame(obj.Frame.Lines)
	scrollV.Gui.Parent = obj.Frame
	scrollH.Gui.Parent = obj.Frame

	obj:UpdateView()
	obj.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		obj:UpdateView()
		obj:Refresh()
	end)

	return obj
end

return { new = new }
