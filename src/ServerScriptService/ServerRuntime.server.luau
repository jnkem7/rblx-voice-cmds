--!strict
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network)
local ReplicationFocus = require(ReplicatedStorage.ReplicationFocus)
local CharacterLoader = require(ServerScriptService.CharacterLoader)
local OneTimeCodeGen = require(ServerScriptService.OneTimeCodeGen)

-- Start dependencies
Network.startServer()
ReplicationFocus.startServer()
CharacterLoader.startServer()
OneTimeCodeGen.startServer()

Workspace:SetAttribute("ServerLoaded", true)
print("loaded server")
