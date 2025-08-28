--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Network)

Network.onServerInvoke(Network.RemoteFunctions.GenerateOTC, function(player: Player)
	return player.UserId
end)
