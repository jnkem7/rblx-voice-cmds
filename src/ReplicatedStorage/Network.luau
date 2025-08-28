--!strict

--[[
    Centralized remote event/function wrapper for server/client communication.
]]

type RemoteEventNames =
	"CreateReplicationFocus"
	| "ProfileUpdated"
	| "StartFishing"
	| "StopFishing"
	| "SendNotification"
	| "SellFish"
	| "AddPondFish"
	| "RemovePondFish"
	| "PurchaseRod"
	| "PurchaseBait"
	| "ExpandPlot"
	| "SelectBait"
	| "LoadCharacter"
type RemoteFunctionNames = "FetchAllProfiles"
type UnreliableRemoteEventNames = "UnreliableRemoteEvent"

type RemoteEvents = {
	[RemoteEventNames]: RemoteEvent,
}
type RemoteFunctions = {
	[RemoteFunctionNames]: RemoteFunction,
}
type UnreliableRemoteEvents = {
	[UnreliableRemoteEventNames]: UnreliableRemoteEvent,
}

local remoteEvents: RemoteEvents = {}
local remoteFunctions: RemoteFunctions = {}
local unreliableRemoteEvents: UnreliableRemoteEvents = {}

local REMOTE_EVENT_NAMES: { RemoteEventNames } = {
	"CreateReplicationFocus",
	"ProfileUpdated",
	"StartFishing",
	"StopFishing",
	"SendNotification",
	"SellFish",
	"AddPondFish",
	"RemovePondFish",
	"PurchaseRod",
	"PurchaseBait",
	"ExpandPlot",
	"SelectBait",
	"LoadCharacter",
}

local REMOTE_FUNCTION_NAMES: { RemoteFunctionNames } = {
	"FetchAllProfiles",
}
local UNRELIABLE_REMOTE_EVENT_NAMES: { UnreliableRemoteEventNames } = {
	"UnreliableRemoteEvent",
}

local Network = {}

-- Remote enums for autocompletion
Network.RemoteEvents = {
	CreateReplicationFocus = "CreateReplicationFocus" :: "CreateReplicationFocus",
	ProfileUpdated = "ProfileUpdated" :: "ProfileUpdated",
	StartFishing = "StartFishing" :: "StartFishing",
	StopFishing = "StopFishing" :: "StopFishing",
	SendNotification = "SendNotification" :: "SendNotification",
	SellFish = "SellFish" :: "SellFish",
	AddPondFish = "AddPondFish" :: "AddPondFish",
	RemovePondFish = "RemovePondFish" :: "RemovePondFish",
	PurchaseRod = "PurchaseRod" :: "PurchaseRod",
	ExpandPlot = "ExpandPlot" :: "ExpandPlot",
	PurchaseBait = "PurchaseBait" :: "PurchaseBait",
	SelectBait = "SelectBait" :: "SelectBait",
	LoadCharacter = "LoadCharacter" :: "LoadCharacter",
}
Network.RemoteFunctions = {
	FetchAllProfiles = "FetchAllProfiles" :: "FetchAllProfiles",
}
Network.UnreliableRemoteEvents = {
	UnreliableRemoteEvent = "UnreliableRemoteEvent" :: "UnreliableRemoteEvent",
}

-- Create and store all the required folders and remotes
function Network.startServer()
	local remoteContainer = Instance.new("Folder")
	remoteContainer.Name = "RemoteContainer"

	local function createFolder(name: string): Folder
		local newFolder = Instance.new("Folder")
		newFolder.Name = name
		newFolder.Parent = remoteContainer
		return newFolder
	end

	local remoteEventsFolder = createFolder("RemoteEvents")
	local remoteFunctionsFolder = createFolder("RemoteFunctions")
	local unreliableRemoteEventsFolder = createFolder("UnreliableRemoteEvents")

	for _, name: RemoteEventNames in REMOTE_EVENT_NAMES do
		local newRemote = Instance.new("RemoteEvent")
		newRemote.Name = name
		newRemote.Parent = remoteEventsFolder
		remoteEvents[name] = newRemote
	end

	for _, name: RemoteFunctionNames in REMOTE_FUNCTION_NAMES do
		local newRemote = Instance.new("RemoteFunction")
		newRemote.Name = name
		newRemote.Parent = remoteFunctionsFolder
		remoteFunctions[name] = newRemote
	end

	for _, name: UnreliableRemoteEventNames in UNRELIABLE_REMOTE_EVENT_NAMES do
		local newRemote = Instance.new("UnreliableRemoteEvent")
		newRemote.Name = name
		newRemote.Parent = unreliableRemoteEventsFolder
		unreliableRemoteEvents[name] = newRemote
	end

	remoteContainer.Parent = script

	script:SetAttribute("ServerReady", true)
end

function Network.startClient()
	if not script:GetAttribute("ServerReady") then
		script:GetAttributeChangedSignal("ServerReady"):Wait()
	end

	local remoteContainer = script.RemoteContainer
	local remoteEventsFolder = remoteContainer.RemoteEvents
	local remoteFunctionsFolder = remoteContainer.RemoteFunctions
	local unreliableRemoteEventsFolder = remoteContainer.UnreliableRemoteEvents

	for _, name: RemoteEventNames in REMOTE_EVENT_NAMES do
		remoteEvents[name] = remoteEventsFolder[name]
	end

	for _, name: RemoteFunctionNames in REMOTE_FUNCTION_NAMES do
		remoteFunctions[name] = remoteFunctionsFolder[name]
	end

	for _, name: UnreliableRemoteEventNames in UNRELIABLE_REMOTE_EVENT_NAMES do
		unreliableRemoteEvents[name] = unreliableRemoteEventsFolder[name]
	end
end

-- For RemoteEvents
function Network.fireServer(name: RemoteEventNames, ...: any)
	local remote = remoteEvents[name]
	if remote then
		remote:FireServer(...)
	end
end

function Network.fireClient(name: RemoteEventNames, player: Player, ...: any)
	local remote = remoteEvents[name]
	if remote then
		remote:FireClient(player, ...)
	end
end

function Network.fireAllClients(name: RemoteEventNames, ...: any)
	local remote = remoteEvents[name]
	if remote then
		remote:FireAllClients(...)
	end
end

function Network.onServerEvent(name: RemoteEventNames, callback: (player: Player, ...any) -> ()): RBXScriptConnection?
	local remote = remoteEvents[name]
	if remote then
		return remote.OnServerEvent:Connect(callback)
	end
	return
end

function Network.onClientEvent(name: RemoteEventNames, callback: (...any) -> ()): RBXScriptConnection?
	local remote = remoteEvents[name]
	if remote then
		return remote.OnClientEvent:Connect(callback)
	end
	return
end

-- For RemoteFunctions
function Network.invokeServer(name: RemoteFunctionNames, ...: any): ...any
	local remote = remoteFunctions[name]
	if remote then
		return remote:InvokeServer(...)
	end
end

function Network.invokeClient(name: RemoteFunctionNames, player: Player, ...: any): ...any
	local remote = remoteFunctions[name]
	if remote then
		return remote:InvokeClient(player, ...)
	end
end

function Network.onServerInvoke(name: RemoteFunctionNames, callback: (player: Player, ...any) -> any)
	local remote = remoteFunctions[name]
	if remote then
		remote.OnServerInvoke = callback
	end
end

function Network.onClientInvoke(name: RemoteFunctionNames, callback: (...any) -> ...any)
	local remote = remoteFunctions[name]
	if remote then
		remote.OnClientInvoke = callback
	end
end

-- For UnreliableRemoteEvents
function Network.fireServerUnreliable(name: UnreliableRemoteEventNames, ...: any)
	local remote = unreliableRemoteEvents[name]
	if remote then
		remote:FireServer(...)
	end
end

function Network.fireClientUnreliable(name: UnreliableRemoteEventNames, player: Player, ...: any)
	local remote = unreliableRemoteEvents[name]
	if remote then
		remote:FireClient(player, ...)
	end
end

function Network.fireAllClientsUnreliable(name: UnreliableRemoteEventNames, ...: any)
	local remote = unreliableRemoteEvents[name]
	if remote then
		remote:FireAllClients(...)
	end
end

function Network.onServerEventUnreliable(
	name: UnreliableRemoteEventNames,
	callback: (player: Player, ...any) -> ()
): RBXScriptConnection?
	local remote = unreliableRemoteEvents[name]
	if remote then
		return remote.OnServerEvent:Connect(callback)
	end
	return
end

function Network.onClientEventUnreliable(
	name: UnreliableRemoteEventNames,
	callback: (...any) -> ()
): RBXScriptConnection?
	local remote = unreliableRemoteEvents[name]
	if remote then
		return remote.OnClientEvent:Connect(callback)
	end
	return
end

return Network
