--!strict
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network)
local ReplicationFocus = require(ReplicatedStorage.ReplicationFocus)
local CharacterLoader = require(ServerScriptService.CharacterLoader)

-- Start dependencies
Network.startServer()
ReplicationFocus.startServer()
CharacterLoader.startServer()

Workspace:SetAttribute("ServerLoaded", true)
