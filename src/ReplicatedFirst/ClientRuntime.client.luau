--!strict

--[[
    Client module loader. All client-side code is ran from here.
]]
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local LoadingScreenManager = require(ReplicatedFirst.LoadingScreenManager)
local setCoreGuiEnabled = require(ReplicatedFirst.Utils.setCoreGuiEnabled)

local function preGameLoadTasks()
	setCoreGuiEnabled(Enum.CoreGuiType.All, false)
	LoadingScreenManager.startClient()
end

local function postGameLoadTasks()
	local Workspace = game:GetService("Workspace")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	if not Workspace:GetAttribute("ServerLoaded") then
		Workspace:GetAttributeChangedSignal("ServerLoaded"):Wait()
	end

	local Network = require(ReplicatedStorage.Network)
	local ReplicationFocus = require(ReplicatedStorage.ReplicationFocus)

	setCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

	-- Start core dependencies
	Network.startClient()

	-- Start rest of scripts
	ReplicationFocus.startClient()

	-- Load character
	Network.fireServer(Network.RemoteEvents.LoadCharacter)

	-- Close the loading screen
	LoadingScreenManager.cleanup()
end

preGameLoadTasks()

while true do
	task.wait()
	if LoadingScreenManager.finishedLoading then
		break
	end
end

postGameLoadTasks()
