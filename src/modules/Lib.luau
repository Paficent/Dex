-- Common Locals
local Services = require(script.Parent.Parent.utils.Services)
local env = require(script.Parent.Parent.utils.env)

local Main = shared.Main

local Lib = {}
local renderStepped = Services.RunService.RenderStepped
local signalWait = renderStepped.wait

-- Functions
Lib.FormatLuaString = (function()
	local string = string
	local gsub = string.gsub
	local format = string.format
	local char = string.char
	local cleanTable = { ['"'] = '\\"', ["\\"] = "\\\\" }
	for i = 0, 31 do
		cleanTable[char(i)] = "\\" .. format("%03d", i)
	end
	for i = 127, 255 do
		cleanTable[char(i)] = "\\" .. format("%03d", i)
	end

	return function(str)
		return gsub(str, '["\\\0-\31\127-\255]', cleanTable)
	end
end)()

Lib.CheckMouseInGui = function(gui)
	if gui == nil then
		return false
	end
	local mouse = Main.Mouse
	local guiPosition = gui.AbsolutePosition
	local guiSize = gui.AbsoluteSize

	return mouse.X >= guiPosition.X
		and mouse.X < guiPosition.X + guiSize.X
		and mouse.Y >= guiPosition.Y
		and mouse.Y < guiPosition.Y + guiSize.Y
end

Lib.IsShiftDown = function()
	return Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
		or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
end

Lib.IsCtrlDown = function()
	return Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
		or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
end

Lib.CreateArrow = function(size, num, dir)
	local arrowFrame = Instance.new("Frame")
	arrowFrame.BackgroundTransparency = 1
	arrowFrame.Name = "Arrow"
	arrowFrame.Size = UDim2.new(0, size, 0, size)

	local function createFrame(i)
		local calculations = {
			up = function()
				return UDim2.new(
					0,
					math.floor(size / 2) - (i - 1),
					0,
					math.floor(size / 2) + i - math.floor(num / 2) - 1
				),
					UDim2.new(0, i + (i - 1), 0, 1)
			end,
			down = function()
				return UDim2.new(
					0,
					math.floor(size / 2) - (i - 1),
					0,
					math.floor(size / 2) - i + math.floor(num / 2) + 1
				),
					UDim2.new(0, i + (i - 1), 0, 1)
			end,
			left = function()
				return UDim2.new(
					0,
					math.floor(size / 2) + i - math.floor(num / 2) - 1,
					0,
					math.floor(size / 2) - (i - 1)
				),
					UDim2.new(0, 1, 0, i + (i - 1))
			end,
			right = function()
				return UDim2.new(
					0,
					math.floor(size / 2) - i + math.floor(num / 2) + 1,
					0,
					math.floor(size / 2) - (i - 1)
				),
					UDim2.new(0, 1, 0, i + (i - 1))
			end,
		}
		local framePosition, frameSize = calculations[dir]()

		local frame = Instance.new("Frame")
		frame.BackgroundColor3 = Color3.new(220 / 255, 220 / 255, 220 / 255)
		frame.BorderSizePixel = 0
		frame.Position = framePosition
		frame.Size = frameSize
		frame.Parent = arrowFrame
	end

	for i = 1, num do
		createFrame(i)
	end

	return arrowFrame
end

Lib.ParseXML = (function() -- from https://github.com/jonathanpoelen/xmlparser
	local func = function()
		-- http://lua-users.org/wiki/StringTrim

		local slashchar = string.byte("/", 1)
		local E = string.byte("E", 1)

		local function defaultEntityTable()
			return { quot = '"', apos = "'", lt = "<", gt = ">", amp = "&", tab = "\t", nbsp = " " }
		end

		local function replaceEntities(s, entities)
			return s:gsub("&([^;]+);", entities)
		end

		local function createEntityTable(docEntities, resultEntities)
			local entities = resultEntities or defaultEntityTable()
			for _, e in docEntities do
				e.value = replaceEntities(e.value, entities)
				entities[e.name] = e.value
			end
			return entities
		end

		local function parse(s, evalEntities)
			s = s:gsub("<!%-%-(.-)%-%->", "")

			local entities, tentities = {}, nil

			if evalEntities then
				local pos = s:find("<[_%w]")
				if pos then
					s:sub(1, pos):gsub("<!ENTITY%s+([_%w]+)%s+(.)(.-)%2", function(name, q, entity)
						entities[#entities + 1] = { name = name, value = entity }
					end)
					tentities = createEntityTable(entities)
					s = replaceEntities(s:sub(pos), tentities)
				end
			end

			local t, l = {}, {}

			local addtext = function(txt)
				txt = txt:match("^%s*(.*%S)") or ""
				if #txt ~= 0 then
					t[#t + 1] = { text = txt }
				end
			end

			s:gsub("<([?!/]?)([-:_%w]+)%s*(/?>?)([^<]*)", function(type, name, closed, txt)
				if #type == 0 then
					local a = {}
					if #closed == 0 then
						local len = 0
						for all, aname, _, value, starttxt in
							string.gmatch(txt, "(.-([-_%w]+)%s*=%s*(.)(.-)%3%s*(/?>?))")
						do
							len = len + #all
							a[aname] = value
							if #starttxt ~= 0 then
								txt = txt:sub(len + 1)
								closed = starttxt
								break
							end
						end
					end
					t[#t + 1] = { tag = name, attrs = a, children = {} }

					if closed:byte(1) ~= slashchar then
						l[#l + 1] = t
						t = t[#t].children
					end

					addtext(txt)
				elseif "/" == type then
					t = l[#l]
					l[#l] = nil

					addtext(txt)
				elseif "!" == type then
					if E == name:byte(1) then
						txt:gsub("([_%w]+)%s+(.)(.-)%2", function(name, q, entity)
							entities[#entities + 1] = { name = name, value = entity }
						end, 1)
					end
				end
			end)

			return { children = t, entities = entities, tentities = tentities }
		end

		return function(text)
			return parse(text)
		end
	end
	local newEnv = setmetatable({}, { __index = getfenv() })
	setfenv(func, newEnv)
	return func()
end)()

Lib.FastWait = function(s) -- This isn't faster??
	if not s then
		return signalWait(renderStepped)
	end
	return task.wait(s)
end

Lib.ButtonAnim = function(button, data)
	local holding = false
	local disabled = false
	local mode = data and data.Mode or 1
	local control = {}

	if mode == 2 then
		local lerpTo = data.LerpTo or Color3.new(0, 0, 0)
		local delta = data.LerpDelta or 0.2
		control.StartColor = data.StartColor or button.BackgroundColor3
		control.PressColor = data.PressColor or control.StartColor:lerp(lerpTo, delta)
		control.HoverColor = data.HoverColor or control.StartColor:lerp(control.PressColor, 0.6)
		control.OutlineColor = data.OutlineColor
	end

	button.InputBegan:Connect(function(input)
		if disabled then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement and not holding then
			if mode == 1 then
				button.BackgroundTransparency = 0.4
			elseif mode == 2 then
				button.BackgroundColor3 = control.HoverColor
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			holding = true
			if mode == 1 then
				button.BackgroundTransparency = 0
			elseif mode == 2 then
				button.BackgroundColor3 = control.PressColor
				if control.OutlineColor then
					button.BorderColor3 = control.PressColor
				end
			end
		end
	end)

	button.InputEnded:Connect(function(input)
		if disabled then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement and not holding then
			if mode == 1 then
				button.BackgroundTransparency = 1
			elseif mode == 2 then
				button.BackgroundColor3 = control.StartColor
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			holding = false
			if mode == 1 then
				button.BackgroundTransparency = Lib.CheckMouseInGui(button) and 0.4 or 1
			elseif mode == 2 then
				button.BackgroundColor3 = Lib.CheckMouseInGui(button) and control.HoverColor or control.StartColor
				if control.OutlineColor then
					button.BorderColor3 = control.OutlineColor
				end
			end
		end
	end)

	control.Disable = function()
		disabled = true
		holding = false

		if mode == 1 then
			button.BackgroundTransparency = 1
		elseif mode == 2 then
			button.BackgroundColor3 = control.StartColor
		end
	end

	control.Enable = function()
		disabled = false
	end

	return control
end

Lib.FindAndRemove = function(t, item)
	local pos = table.find(t, item)
	if pos then
		table.remove(t, pos)
	end
end

Lib.AttachTo = function(obj, data)
	local target, posOffX, posOffY, sizeOffX, sizeOffY, resize, con
	local disabled = false

	local function update()
		if not obj or not target then
			return
		end

		local targetPos = target.AbsolutePosition
		local targetSize = target.AbsoluteSize
		obj.Position = UDim2.new(0, targetPos.X + posOffX, 0, targetPos.Y + posOffY)
		if resize then
			obj.Size = UDim2.new(0, targetSize.X + sizeOffX, 0, targetSize.Y + sizeOffY)
		end
	end

	local function setup(o, data)
		obj = o
		data = data or {}
		target = data.Target
		posOffX = data.PosOffX or 0
		posOffY = data.PosOffY or 0
		sizeOffX = data.SizeOffX or 0
		sizeOffY = data.SizeOffY or 0
		resize = data.Resize or false

		if con then
			con:Disconnect()
			con = nil
		end
		if target then
			con = target.Changed:Connect(function(prop)
				if not disabled and prop == "AbsolutePosition" or prop == "AbsoluteSize" then
					update()
				end
			end)
		end

		update()
	end
	setup(obj, data)

	return {
		SetData = function(obj, data)
			setup(obj, data)
		end,
		Enable = function()
			disabled = false
			update()
		end,
		Disable = function()
			disabled = true
		end,
		Destroy = function()
			con:Disconnect()
			con = nil
		end,
	}
end

Lib.ProtectedGuis = {}

Lib.ShowGui = function(gui)
	if env.protectgui then
		env.protectgui(gui)
	end
	gui.Parent = Main.GuiHolder
end

Lib.ColorToBytes = function(col)
	local round = math.round
	return string.format("%d, %d, %d", round(col.r * 255), round(col.g * 255), round(col.b * 255))
end

Lib.ReadFile = function(filename)
	local ran, contents = pcall(env.readfile, filename)
	if (env.readfile and ran and contents) == false then
		return
	end

	return contents
end

Lib.DeferFunc = function(f, ...)
	signalWait(renderStepped)
	return f(...)
end

Lib.LoadCustomAsset = function(filepath)
	if not env.getcustomasset or not env.isfile or not env.isfile(filepath) then
		return
	end

	return env.getcustomasset(filepath, false)
end

Lib.FetchCustomAsset = function(url, filepath)
	if not env.writefile then
		return
	end

	local s, data = pcall(game.HttpGet, game, url)
	if not s then
		return
	end

	env.writefile(filepath, data)
	return Lib.LoadCustomAsset(filepath)
end

return Lib
