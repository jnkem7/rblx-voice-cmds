--!strict

--[[
	Disables/enables the player's CoreGuis.
]]

local function setCoreGuiEnabled(coreGuiType: Enum.CoreGuiType, enabled: boolean)
	local StarterGui = game:GetService("StarterGui")
	StarterGui:SetCoreGuiEnabled(coreGuiType, enabled)
end

return setCoreGuiEnabled
