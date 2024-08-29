--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--
local TweenMaster2 = require(game.ReplicatedStorage.TweenMaster2)
--
local remoteFunction: RemoteFunction = ReplicatedStorage:WaitForChild("_SendTweenEvent")

export type _tween = { ID: string, Object: Instance, Info: TweenInfo, Action: { [string]: any } }

remoteFunction.OnClientInvoke = function(tween: _tween, state: string)
	local t = TweenMaster2.newClient(tween.Object, tween.Info, tween.Action, tween.ID)

	t[state](t)
	return true
end
