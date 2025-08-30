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
	local Players = game:GetService("Players")
	local Workspace = game:GetService("Workspace")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local StarterGui = game:GetService("StarterGui")

	if not Workspace:GetAttribute("ServerLoaded") then
		Workspace:GetAttributeChangedSignal("ServerLoaded"):Wait()
	end

	local GuiManager = require(ReplicatedStorage.GuiManager)
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

	-- Insert guis
	for _, gui in ipairs(ReplicatedStorage.StarterGui:GetChildren()) do
		gui.Parent = Players.LocalPlayer.PlayerGui
	end

	for _, gui in ipairs(StarterGui:GetChildren()) do
		gui.Parent = Players.LocalPlayer.PlayerGui
	end

	task.wait(1)

	GuiManager.startClient()

	GuiManager.gui.OTC.setVisible(true)
end

preGameLoadTasks()

while true do
	task.wait()
	if LoadingScreenManager.finishedLoading then
		break
	end
end

postGameLoadTasks()
