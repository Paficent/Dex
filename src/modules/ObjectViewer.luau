local components = require(script.Parent.Parent.ui).components
local Services = require(script.Parent.Parent.utils.Services)

local ObjectViewer = {}

local viewportFrame, viewportCamera
local mainWindow, activeObject, rotationConnection
local UserInputService: UserInputService, RunService: RunService = Services:Get("UserInputService", "RunService")

local function isMouseOverViewport()
	local mousePos = UserInputService:GetMouseLocation()
	local framePos = viewportFrame.AbsolutePosition
	local frameSize = viewportFrame.AbsoluteSize

	return mousePos.X >= framePos.X
		and mousePos.X <= framePos.X + frameSize.X
		and mousePos.Y >= framePos.Y
		and mousePos.Y <= framePos.Y + frameSize.Y
end

local function computeBoundingBox(object)
	local minBound, maxBound

	local function expandBounds(part)
		local cframe, size = part.CFrame, part.Size * 0.5
		local corners = {
			cframe * Vector3.new(size.X, size.Y, size.Z),
			cframe * Vector3.new(-size.X, size.Y, size.Z),
			cframe * Vector3.new(size.X, -size.Y, size.Z),
			cframe * Vector3.new(-size.X, -size.Y, size.Z),
			cframe * Vector3.new(size.X, size.Y, -size.Z),
			cframe * Vector3.new(-size.X, size.Y, -size.Z),
			cframe * Vector3.new(size.X, -size.Y, -size.Z),
			cframe * Vector3.new(-size.X, -size.Y, -size.Z),
		}

		for _, corner in corners do
			minBound = minBound
					and Vector3.new(
						math.min(minBound.X, corner.X),
						math.min(minBound.Y, corner.Y),
						math.min(minBound.Z, corner.Z)
					)
				or corner
			maxBound = maxBound
					and Vector3.new(
						math.max(maxBound.X, corner.X),
						math.max(maxBound.Y, corner.Y),
						math.max(maxBound.Z, corner.Z)
					)
				or corner
		end
	end

	if object:IsA("Model") then
		for _, descendant in object:GetDescendants() do
			if descendant:IsA("BasePart") then
				expandBounds(descendant)
			end
		end
	elseif object:IsA("BasePart") then
		expandBounds(object)
	else
		return nil
	end

	if not minBound or not maxBound then
		return nil
	end
	return CFrame.new((minBound + maxBound) / 2), maxBound - minBound
end

local function raycast()
	local mousePos = UserInputService:GetMouseLocation()
	local viewportPos =
		Vector2.new(mousePos.X - viewportFrame.AbsolutePosition.X, mousePos.Y - viewportFrame.AbsolutePosition.Y)

	if
		viewportPos.X < 0
		or viewportPos.Y < 0
		or viewportPos.X > viewportFrame.AbsoluteSize.X
		or viewportPos.Y > viewportFrame.AbsoluteSize.Y
	then
		return
	end

	local normalizedX = viewportPos.X / viewportFrame.AbsoluteSize.X * 2 - 1
	local normalizedY = viewportPos.Y / viewportFrame.AbsoluteSize.Y * 2 - 1
	local unitRay = viewportCamera:ViewportPointToRay(normalizedX, normalizedY)

	local closestObject, minDistance = nil, math.huge

	for _, child in viewportFrame:GetChildren() do
		if child:IsA("BasePart") then
			local rayOrigin, rayDirection = unitRay.Origin, unitRay.Direction
			local partCF, partSize = child.CFrame, child.Size / 2
			local localRayOrigin = partCF:PointToObjectSpace(rayOrigin)
			local localRayDir = partCF:VectorToObjectSpace(rayDirection)

			local function rayHitsAABB(origin, direction, minBound, maxBound)
				local tMin, tMax = (minBound - origin) / direction, (maxBound - origin) / direction
				if
					(direction.X == 0 and (origin.X < minBound.X or origin.X > maxBound.X))
					or (direction.Y == 0 and (origin.Y < minBound.Y or origin.Y > maxBound.Y))
					or (direction.Z == 0 and (origin.Z < minBound.Z or origin.Z > maxBound.Z))
				then
					return nil
				end

				local t1 = math.max(math.min(tMin.X, tMax.X), math.min(tMin.Y, tMax.Y), math.min(tMin.Z, tMax.Z))
				local t2 = math.min(math.max(tMin.X, tMax.X), math.max(tMin.Y, tMax.Y), math.max(tMin.Z, tMax.Z))
				return t1 <= t2 and t2 > 0 and t1 or nil
			end

			local distance = rayHitsAABB(localRayOrigin, localRayDir, -partSize, partSize)
			if distance and distance < minDistance then
				closestObject, minDistance = child, distance
			end
		elseif child:IsA("Model") then
			local modelCF, modelSize = computeBoundingBox(child)
			if not modelCF or not modelSize then
				continue
			end

			local rayOrigin, rayDirection = unitRay.Origin, unitRay.Direction
			local localRayOrigin = modelCF:PointToObjectSpace(rayOrigin)
			local localRayDir = modelCF:VectorToObjectSpace(rayDirection)

			local function rayHitsModelBounds(origin, direction, minBound, maxBound)
				local tMin, tMax = (minBound - origin) / direction, (maxBound - origin) / direction
				if
					(direction.X == 0 and (origin.X < minBound.X or origin.X > maxBound.X))
					or (direction.Y == 0 and (origin.Y < minBound.Y or origin.Y > maxBound.Y))
					or (direction.Z == 0 and (origin.Z < minBound.Z or origin.Z > maxBound.Z))
				then
					return nil
				end

				local t1 = math.max(math.min(tMin.X, tMax.X), math.min(tMin.Y, tMax.Y), math.min(tMin.Z, tMax.Z))
				local t2 = math.min(math.max(tMin.X, tMax.X), math.max(tMin.Y, tMax.Y), math.max(tMin.Z, tMax.Z))
				return t1 <= t2 and t2 > 0 and t1 or nil
			end

			local halfSize = modelSize / 2
			local distance = rayHitsModelBounds(localRayOrigin, localRayDir, -halfSize, halfSize)
			if distance and distance < minDistance then
				closestObject, minDistance = child, distance
			end
		end
	end

	return closestObject
end

local function rotateAroundModel(model)
	local angle = 0
	local modelCF, modelSize = computeBoundingBox(model)
	local inverseRot = (modelCF - modelCF.p):inverse()
	modelCF *= inverseRot
	modelSize = inverseRot * modelSize
	modelSize = Vector3.new(math.abs(modelSize.x), math.abs(modelSize.y), math.abs(modelSize.z))

	local maxSize = math.max(modelSize.x, modelSize.y, modelSize.z)
	local halfDiagonal = 0
	local tanFov = math.tan(math.rad(viewportCamera.FieldOfView / 2))

	if maxSize == modelSize.x then
		halfDiagonal = math.sqrt(modelSize.y ^ 2 + modelSize.z ^ 2) / 2
	elseif maxSize == modelSize.y then
		halfDiagonal = math.sqrt(modelSize.x ^ 2 + modelSize.z ^ 2) / 2
	else
		halfDiagonal = math.sqrt(modelSize.x ^ 2 + modelSize.y ^ 2) / 2
	end

	local minDist = (maxSize / 2) / tanFov + halfDiagonal

	if rotationConnection then
		rotationConnection:Disconnect()
	end

	rotationConnection = RunService.RenderStepped:Connect(function(deltaTime)
		angle += 1 * deltaTime * 7
		viewportCamera.CFrame = modelCF
			* CFrame.fromEulerAnglesYXZ(0, math.rad(angle), 0)
			* CFrame.new(0, 0, minDist - 2)
	end)
end

function ObjectViewer.ViewObject(target: BasePart | Model) -- TODO handle objects that aren't archiveable
	for _, v in viewportFrame:GetChildren() do
		if not v:IsA("Camera") then
			v:Destroy()
		end
	end

	activeObject = target:Clone()
	activeObject.Parent = viewportFrame

	rotateAroundModel(activeObject)
	mainWindow:ShowAndFocus()
end

function ObjectViewer.Init()
	mainWindow = components.Window.new()
	mainWindow:SetTitle("Object Viewer")
	mainWindow:Resize(500, 400)
	ObjectViewer.Window = mainWindow

	viewportFrame = Instance.new("ViewportFrame", mainWindow.GuiElems.Content)

	viewportCamera = viewportFrame:FindFirstChild("Camera") or Instance.new("Camera", viewportFrame)

	viewportFrame.CurrentCamera = viewportCamera
	viewportFrame.BackgroundTransparency = 1

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 and isMouseOverViewport() then
			raycast() -- TODO: Implement selection and selection highlighting explorer
		end
	end)

	RunService.RenderStepped:Connect(function()
		viewportFrame.Size = UDim2.new(0, mainWindow.SizeX, 0, mainWindow.SizeY)
	end)
end

return ObjectViewer
