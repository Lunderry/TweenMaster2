--!strict
export type TweenMaster = {
	Tween: { Tween },
	Play: (self: TweenMaster) -> (),
	Wait: (self: TweenMaster) -> (),
	Pause: (self: TweenMaster) -> (),
	Cancel: (self: TweenMaster) -> (),
	WaitTable: (self: TweenMaster) -> (),
	Destroy: (self: TweenMaster) -> (),
}

return function(tween: { Tween }, id: number): TweenMaster
	local tweenMaster = { Tween = tween } :: TweenMaster

	function tweenMaster:Play(): ()
		for _, v in pairs(self.Tween) do
			task.delay(0, function()
				v:Play()
			end)
		end
	end

	function tweenMaster:Wait(): ()
		local count = 0
		for _, v: TweenBase in pairs(self.Tween) do
			task.delay(0, function()
				v.Completed:Once(function()
					count += 1
				end)
				v:Play()
			end)
		end
		repeat
			task.wait()
		until count >= #self.Tween
	end

	function tweenMaster:Pause(): ()
		for _, v in pairs(self.Tween) do
			task.delay(0, function()
				v:Pause()
			end)
		end
	end

	function tweenMaster:Cancel(): ()
		for _, v in pairs(self.Tween) do
			task.delay(0, function()
				v:Cancel()
			end)
		end
	end

	function tweenMaster:WaitTable(): ()
		for _, v: TweenBase in pairs(self.Tween) do
			v:Play()
			v.Completed:Wait()
		end
	end

	function tweenMaster:Destroy(): ()
		if script.Parent:FindFirstChild(id) then
			for _, v in script.Parent[id]:GetChildren() do
				v:Destroy()
			end
		end
		table.clear(self.Tween)
	end

	return tweenMaster
end
