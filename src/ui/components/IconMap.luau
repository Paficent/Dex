local funcs = {}

function funcs:GetLabel()
	local label = Instance.new("ImageLabel")
	self:SetupLabel(label)
	return label
end

function funcs:SetupLabel(label)
	label.BackgroundTransparency = 1
	label.ImageRectOffset = Vector2.new(0, 0)
	label.ImageRectSize = Vector2.new(self.IconSizeX, self.IconSizeY)
	label.ScaleType = Enum.ScaleType.Crop
	label.Size = UDim2.new(0, self.IconSizeX, 0, self.IconSizeY)
end

function funcs:Display(label, index)
	label.Image = self.MapId
	if self.NumX then
		label.ImageRectOffset =
			Vector2.new(self.IconSizeX * (index % self.NumX), self.IconSizeY * math.floor(index / self.NumX))
	else
		label.ImageRectOffset = Vector2.new(self.IconSizeX * index, 0)
	end
end

function funcs:DisplayByKey(label, key)
	local index = self.IndexDict[key]
	if index then
		self:Display(label, index)
	end
end

function funcs:SetDict(dict)
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
