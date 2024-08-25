local funcs = {}

funcs.GetLabel = function(self)
	local label = Instance.new("ImageLabel")
	self:SetupLabel(label)
	return label
end

funcs.SetupLabel = function(self, obj)
	obj.BackgroundTransparency = 1
	obj.ImageRectOffset = Vector2.new(0, 0)
	obj.ImageRectSize = Vector2.new(self.IconSizeX, self.IconSizeY)
	obj.ScaleType = Enum.ScaleType.Crop
	obj.Size = UDim2.new(0, self.IconSizeX, 0, self.IconSizeY)
end

funcs.Display = function(self, obj, index)
	obj.Image = self.MapId
	if not self.NumX then
		obj.ImageRectOffset = Vector2.new(self.IconSizeX * index, 0)
	else
		obj.ImageRectOffset =
			Vector2.new(self.IconSizeX * (index % self.NumX), self.IconSizeY * math.floor(index / self.NumX))
	end
end

funcs.DisplayByKey = function(self, obj, key)
	if self.IndexDict[key] then
		self:Display(obj, self.IndexDict[key])
	end
end

funcs.SetDict = function(self, dict)
	self.IndexDict = dict
end

local mt = {}
mt.__index = funcs

local function new(mapId, mapSizeX, mapSizeY, iconSizeX, iconSizeY)
	local obj = setmetatable({
		MapId = mapId,
		MapSizeX = mapSizeX,
		MapSizeY = mapSizeY,
		IconSizeX = iconSizeX,
		IconSizeY = iconSizeY,
		NumX = mapSizeX / iconSizeX,
		IndexDict = {},
	}, mt)
	return obj
end

local function newLinear(mapId, iconSizeX, iconSizeY)
	local obj = setmetatable({
		MapId = mapId,
		IconSizeX = iconSizeX,
		IconSizeY = iconSizeY,
		IndexDict = {},
	}, mt)
	return obj
end

return { new = new, newLinear = newLinear }
