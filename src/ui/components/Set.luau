local Signal = require(script.Parent.Parent.Parent.packages.Signal)

local funcs = {}

funcs.Add = function(self, obj)
	if self.Map[obj] then
		return
	end

	local list = self.List
	list[#list + 1] = obj
	self.Map[obj] = true
	self.Changed:Fire()
end

funcs.AddTable = function(self, t)
	local changed
	local list, map = self.List, self.Map
	for i = 1, #t do
		local elem = t[i]
		if not map[elem] then
			list[#list + 1] = elem
			map[elem] = true
			changed = true
		end
	end
	if changed then
		self.Changed:Fire()
	end
end

funcs.Remove = function(self, obj)
	if not self.Map[obj] then
		return
	end

	local list = self.List
	local pos = table.find(list, obj)
	if pos then
		table.remove(list, pos)
	end
	self.Map[obj] = nil
	self.Changed:Fire()
end

funcs.RemoveTable = function(self, t)
	local changed
	local list, map = self.List, self.Map
	local removeSet = {}
	for i = 1, #t do
		local elem = t[i]
		map[elem] = nil
		removeSet[elem] = true
	end

	for i = #list, 1, -1 do
		local elem = list[i]
		if removeSet[elem] then
			table.remove(list, i)
			changed = true
		end
	end
	if changed then
		self.Changed:Fire()
	end
end

funcs.Set = function(self, obj)
	if #self.List == 1 and self.List[1] == obj then
		return
	end

	self.List = { obj }
	self.Map = { [obj] = true }
	self.Changed:Fire()
end

funcs.SetTable = function(self, t)
	local newList, newMap = {}, {}
	self.List, self.Map = newList, newMap
	table.move(t, 1, #t, 1, newList)
	for i = 1, #t do
		newMap[t[i]] = true
	end
	self.Changed:Fire()
end

funcs.Clear = function(self)
	if #self.List == 0 then
		return
	end
	self.List = {}
	self.Map = {}
	self.Changed:Fire()
end

local mt = { __index = funcs }

local function new()
	local obj = setmetatable({
		List = {},
		Map = {},
		Changed = Signal.new(),
	}, mt)

	return obj
end

return { new = new }
