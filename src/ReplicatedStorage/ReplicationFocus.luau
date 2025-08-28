--!strict

--[[
    Requests for the server to create a new BasePart to be used as ReplicationFocus.
    With StreamingEnabled the Workspace will not render until the player has a character.
    This fixes that problem when you have CharacterAutoLoads disabled.
]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local Network = require(ReplicatedStorage.Network)

local ReplicationFocus = {}

function ReplicationFocus.startClient()
	local player: Player = Players.LocalPlayer
	local camera: Camera = Workspace.CurrentCamera
	local signal: RBXScriptConnection

	signal = CollectionService:GetInstanceAddedSignal(`ReplicationFocus{player.UserId}`):Connect(function(part: Part)
		signal:Disconnect()
		RunService.RenderStepped:Connect(function()
			if camera then
				part.CFrame = camera.CFrame
			end
		end)
	end)

	Network.fireServer(Network.RemoteEvents.CreateReplicationFocus, camera.CFrame)
end

function ReplicationFocus.startServer()
	local hasReplicationFocus: { [Player]: boolean } = {}

	local container = Instance.new("Model")
	container.Name = "ReplicationFocusContainer"
	container.Parent = Workspace
	container.ModelStreamingMode = Enum.ModelStreamingMode.Persistent

	Network.onServerEvent(Network.RemoteEvents.CreateReplicationFocus, function(player: Player, cameraCFrame: CFrame)
		if hasReplicationFocus[player] then
			warn(`{player} requested duplicate ReplicationFocus`)
			return
		end
		local part = Instance.new("Part")
		part.Size = Vector3.new(1, 1, 1)
		part.CanCollide = false
		part.Transparency = 1
		part.Name = `{player.UserId}`
		part.Parent = container
		part.CFrame = cameraCFrame

		part:SetNetworkOwner(player)
		player.ReplicationFocus = part
		part:AddTag(`ReplicationFocus{player.UserId}`)
		hasReplicationFocus[player] = true
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		if hasReplicationFocus[player] then
			local replicationFocus = container:FindFirstChild(`{player.UserId}`)
			if replicationFocus ~= nil then
				replicationFocus:Destroy()
			end
			hasReplicationFocus[player] = nil
		end
	end)
end

return ReplicationFocus
