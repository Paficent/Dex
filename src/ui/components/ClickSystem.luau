local Signal = require(script.Parent.Parent.Parent.Packages.Signal)
local Services = require(script.Parent.Parent.Parent.utils.Services)

local UserInputService: UserInputService = Services.UserInputService :: UserInputService
local Lib = shared.Apps.Lib

local funcs = {
	LastItem = newproxy(),
	OnDown = Signal.new(),
	OnRelease = Signal.new(),
	AllowedButtons = { 1 },
	Combo = 0,
	MaxCombo = 2,
	ComboTime = 0.5,
	Items = {},
	ItemCons = {},
	ClickId = -1,
	LastButton = "",
}

funcs.Trigger = function(self, item, button)
	if table.find(self.AllowedButtons, button) then
		if
			self.LastButton ~= button
			or self.LastItem ~= item
			or self.Combo == self.MaxCombo
			or tick() - self.ClickId > self.ComboTime
		then
			self.Combo = 0
			self.LastButton = button
			self.LastItem = item
		end
		self.Combo = self.Combo + 1
		self.ClickId = tick()

		local release
		release = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType["MouseButton" .. button] then
				release:Disconnect()
				if Lib.CheckMouseInGui(item) and self.LastButton == button and self.LastItem == item then
					self["OnRelease"]:Fire(item, self.Combo, button)
				end
			end
		end)

		self["OnDown"]:Fire(item, self.Combo, button)
	end
end

funcs.Add = function(self, item)
	if table.find(self.Items, item) then
		return
	end

	local cons = {}
	cons[1] = item.MouseButton1Down:Connect(function()
		self:Trigger(item, 1)
	end)
	cons[2] = item.MouseButton2Down:Connect(function()
		self:Trigger(item, 2)
	end)

	self.ItemCons[item] = cons
	self.Items[#self.Items + 1] = item
end

funcs.Remove = function(self, item)
	local ind = table.find(self.Items, item)
	if not ind then
		return
	end

	for i, v in self.ItemCons[item] do
		v:Disconnect()
	end
	self.ItemCons[item] = nil
	table.remove(self.Items, ind)
end

local function new()
	return setmetatable(funcs, {})
end

return { new = new }
