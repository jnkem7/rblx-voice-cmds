--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Network)

local CharacterLoader = {}

local function newCharacter(player: Player, character: any)
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	humanoid.Died:Connect(function()
		task.wait(Players.RespawnTime)
		player:LoadCharacter()
	end)
end

local function newPlayer(player: Player)
	player.CharacterAdded:Connect(function(character: any)
		newCharacter(player, character)
	end)
end

function CharacterLoader.startServer()
	Network.onServerEvent(Network.RemoteEvents.LoadCharacter, function(player: Player)
		player:LoadCharacter()
	end)
	Players.PlayerAdded:Connect(newPlayer)
end

return CharacterLoader
