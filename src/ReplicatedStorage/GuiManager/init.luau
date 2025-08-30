--!strict

local GuiManager = {}
GuiManager.gui = {}

function GuiManager.startClient()
	-- require modules
	GuiManager.gui.OTC = require(script.OTC)

	-- start modules
	for _, guiModule in pairs(GuiManager.gui) do
		guiModule.startClient()
	end
end

return GuiManager
