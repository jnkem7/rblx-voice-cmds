--!strict

local GuiManager = {}

GuiManager.gui = {}
GuiManager.gui.OTC = require(script.OTC)

function GuiManager.startClient()
	for _, guiModule in pairs(GuiManager.gui) do
		guiModule.startClient()
	end
end

return GuiManager
