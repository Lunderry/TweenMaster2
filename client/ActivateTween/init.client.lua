--!nonstrict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--
local TweenMaster2 = require(game.ReplicatedStorage.TweenMaster2)
local Types = require(game.ReplicatedStorage.TweenMaster2.Types)
--
local remoteFunction: RemoteFunction = ReplicatedStorage:WaitForChild("_SendTweenEvent")

export type _tween = { ID: string, Instances: { Instance }, Info: Types.dataTween, Action: { [string]: any } }

remoteFunction.OnClientInvoke = function(tween: _tween, state: string): boolean
	local t = TweenMaster2.newClient(tween.Instances, tween.Info, tween.Action, tween.ID)

	t[state](t)
	return true
end
