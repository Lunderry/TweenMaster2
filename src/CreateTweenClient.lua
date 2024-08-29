--!strict
local SaveTweenClient = require(script.Parent.SaveTweenClient)

local Types = require(script.Parent.Types)

local class = {} :: Types.TweenMaster
class.__index = class

function class:Play(): ()
	for _, v in pairs(self.Tween) do
		task.defer(function()
			v:Play()
		end)
	end
end

function class:Wait(): ()
	local count = 0
	for _, tween: TweenBase in pairs(self.Tween) do
		task.defer(function()
			tween:Play()
			repeat
				local playbackState = tween.Completed:Wait()
			until playbackState == Enum.PlaybackState.Completed
			count += 1
		end)
	end
	repeat
		task.wait()
	until count >= #self.Tween
end

function class:Pause(): ()
	for _, v in pairs(self.Tween) do
		task.defer(function()
			v:Pause()
		end)
	end
end

function class:Cancel(): ()
	for _, v in pairs(self.Tween) do
		task.defer(function()
			v:Cancel()
		end)
	end
end

function class:WaitTable(): ()
	for _, tween in self.Tween do
		tween:Play()

		repeat
			local playbackState = tween.Completed:Wait()
		until playbackState == Enum.PlaybackState.Completed
	end
end

function class:Destroy(): ()
	if self.ID then
		SaveTweenClient[self.ID] = nil
	end
	for _, v in self.Object do
		if v:IsA("Model") then
			v["_TweenModel"]:Destroy()
		end
	end
	table.clear(self)
end

return class
