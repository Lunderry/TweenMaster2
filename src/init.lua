--!strict
export type dataTween = {
	time: number?,
	easingStyle: Enum.EasingStyle?,
	easingDirection: Enum.EasingDirection?,
	repeatCount: number?,
	reverses: boolean?,
	delayTime: number?,
}
--
local ManagerTweenMaster = require(script.ManagerTweenMaster)
local CreateTween = require(script.CreateTween)
--
local module = {}
--

local id = 0

function module.Info(
	_time: number?,
	_easingStyle: Enum.EasingStyle?,
	_easingDirection: Enum.EasingDirection?,
	_repeatCount: number?,
	_reverses: boolean?,
	_delayTime: number?
): TweenInfo
	return ManagerTweenMaster.createTweenInfo({
		_time,
		_easingStyle,
		_easingDirection,
		_repeatCount,
		_reverses,
		_delayTime,
	})
end
function module.new(
	obj: string | Instance | {} | Model,
	info: TweenInfo,
	action: {},
	repeatID: number?
): (CreateTween.TweenMaster, number)
	local TweenCreate: { Tween } = {}

	local newID
	if repeatID then
		newID = repeatID
	else
		id += 1
		newID = id
	end

	--if obj is string search the object
	if type(obj) == "string" then
		local result: { string } = {}
		for match in (obj .. "."):gmatch("(.-)" .. "%.") do
			table.insert(result, match)
		end
		local rp = game
		for _, v in result do
			if rp:FindFirstChild(v) then
				rp = rp[v]
				continue
			end
			warn(rp:GetFullName() .. " to " .. v .. " No exist.")
			break
		end
		obj = rp
	end

	if type(obj) == "table" then
		for _, v in obj do
			TweenCreate[#TweenCreate + 1] = ManagerTweenMaster.check(v :: Instance, info, action, newID)
		end
	else
		TweenCreate[#TweenCreate + 1] = ManagerTweenMaster.check(obj, info, action, newID)
	end

	return CreateTween(TweenCreate, id), newID
end

function module.Fast(obj: Instance | {} | Model, info: TweenInfo, action: {}): ()
	local new = module.new(obj, info, action)
	task.defer(function()
		new:Wait()
		new:Destroy()
	end)
end

function module.Wait(obj: Instance | {} | Model, info: TweenInfo, action: {}): ()
	local new = module.new(obj, info, action)
	new:Wait()
	new:Destroy()
end
return module
