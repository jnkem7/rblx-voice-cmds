--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Network)

local OneTimeCodeGen = {}

function OneTimeCodeGen.startServer()
	Network.onServerInvoke(Network.RemoteFunctions.GenerateOTC, function(player: Player)
		return player.UserId
	end)
end

return OneTimeCodeGen
