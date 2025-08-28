--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Network)

local localPlayer = Players.LocalPlayer
local gui = localPlayer.PlayerGui:WaitForChild(script.Name)

local module = {}

function module.startClient()
	print("loading")
	gui.Frame.Code.Text = Network.invokeServer(Network.RemoteFunctions.GenerateOTC)
end

function module.setVisible(visible: boolean)
	gui.Visible = visible
end

return module
