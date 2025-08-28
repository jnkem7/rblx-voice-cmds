--!strict
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local gui = ReplicatedFirst.Assets.LoadingScreen:Clone()

local LoadingScreenManager = {}
LoadingScreenManager.finishedLoading = false

function LoadingScreenManager.startClient()
	if LoadingScreenManager.finishedLoading then
		return
	end
	gui.Parent = Players.LocalPlayer.PlayerGui
	task.wait(3)
	LoadingScreenManager.finishedLoading = true
end

function LoadingScreenManager.cleanup()
	gui:Destroy()
end

return LoadingScreenManager
