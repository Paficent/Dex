local components = require(script.Parent.Parent.ui).components

local RemoteSpy = {}

local window

RemoteSpy.Init = function()
	window = components.Window.new()
	window:SetTitle("Remote Spy")
	window:Resize(500, 400)
	RemoteSpy.Window = window
end

return RemoteSpy
