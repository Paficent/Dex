local Signal = require(script.Parent.Parent.Parent.packages.Signal)

local funcs = {}

function funcs:Add(obj)
	if self.Map[obj] then
		return
	end

	local list = self.List
	list[#list + 1] = obj
	self.Map[obj] = true
	self.Changed:Fire()
end

function funcs:AddTable(objects)
	local hasChanged = false
	local list, map = self.List, self.Map
	for _, obj in ipairs(objects) do
		if not map[obj] then
			list[#list + 1] = obj
			map[obj] = true
			hasChanged = true
		end
	end
	if hasChanged then
		self.Changed:Fire()
	end
end

function funcs:Remove(obj)
	if not self.Map[obj] then
		return
	end

	local list = self.List
	local position = table.find(list, obj)
	if position then
		table.remove(list, position)
	end
	self.Map[obj] = nil
	self.Changed:Fire()
end

function funcs:RemoveTable(objects)
	local hasChanged = false
	local list, map = self.List, self.Map
	local removalSet = {}
	for _, obj in ipairs(objects) do
		map[obj] = nil
		removalSet[obj] = true
	end

	for i = #list, 1, -1 do
		local obj = list[i]
		if removalSet[obj] then
			table.remove(list, i)
			hasChanged = true
		end
	end
	if hasChanged then
		self.Changed:Fire()
	end
end

function funcs:Set(obj)
	if #self.List == 1 and self.List[1] == obj then
		return
	end

	self.List = { obj }
	self.Map = { [obj] = true }
	self.Changed:Fire()
end

function funcs:SetTable(objects)
	local newList, newMap = {}, {}
	self.List, self.Map = newList, newMap
	table.move(objects, 1, #objects, 1, newList)
	for _, obj in ipairs(objects) do
		newMap[obj] = true
	end
	self.Changed:Fire()
end

function funcs:Clear()
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
