--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--
local Types = require(script.Parent.Types)
--

--
local remoteFunction = Instance.new("RemoteFunction", ReplicatedStorage)
remoteFunction.Name = "_SendTweenEvent"
--
local class = {} :: Types.TweenMaster
class.__index = class

local function _notwait(self, plr: Player?, str: string): ()
	if plr then
		task.defer(function()
			remoteFunction:InvokeClient(plr, self, str)
		end)
	else
		for _, v in Players:GetPlayers() do
			task.defer(function()
				remoteFunction:InvokeClient(v, self, str)
			end)
		end
	end
end
local function _wait(self, plr: Player?, str: string): ()
	if plr then
		remoteFunction:InvokeClient(plr, self, str)
	else
		local t = {}
		for i, v in Players:GetPlayers() do
			local c = i
			t[c] = false
			task.defer(function()
				remoteFunction:InvokeClient(v, self, str)
				t[c] = true
			end)
		end
		repeat
			task.wait()
		until not table.find(t, false)
	end
end

function class:Play(plr: Player?): ()
	_notwait(self, plr, "Play")
end

function class:Wait(plr: Player?): ()
	_wait(self, plr, "Wait")
end

function class:Pause(plr: Player?): ()
	_notwait(self, plr, "Pause")
end

function class:Cancel(plr: Player?): ()
	_notwait(self, plr, "Cancel")
end

function class:WaitTable(plr: Player?): ()
	_wait(self, plr, "WaitTable")
end

function class:Destroy(): ()
	_notwait(self, nil, "Destroy")
	table.clear(self)
end

return class
