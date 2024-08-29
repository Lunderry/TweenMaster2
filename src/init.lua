--!strict
local HttpService = game:GetService("HttpService")
--
local ManagerTweenMaster = require(script.ManagerTweenMaster)
local CreateTweenServer = require(script.CreateTweenServer)
local CreateTweenClient = require(script.CreateTweenClient)
local SaveTweenClient = require(script.SaveTweenClient)

local Types = require(script.Types)
--
local module = {}
--
function module.Info(
	_time: number?,
	_easingStyle: Enum.EasingStyle?,
	_easingDirection: Enum.EasingDirection?,
	_repeatCount: number?,
	_reverses: boolean?,
	_delayTime: number?
): Types.dataTween
	local specs = { _time, _easingStyle, _easingDirection, _repeatCount, _reverses, _delayTime }
	for i, v in ManagerTweenMaster.DATANEUTRAL do
		if specs[i] == nil then
			specs[i] = v
		end
	end

	return specs
end

function module.newClient(obj: Types.obj, info: Types.dataTween, action: Types.action, id: string?): Types.TweenMaster
	if SaveTweenClient[id] then
		return SaveTweenClient[id]
	end
	local self = {}
	self.Tween = {}
	self.Object = obj
	self.Info = if type(info) == "table" then ManagerTweenMaster.createTweenInfo(info) else info
	self.Action = action
	self.ID = id

	--if obj is string search the object
	if type(obj) == "string" then
		self.Object = ManagerTweenMaster.searchInstanceWithString(obj)
	end

	if type(self.Object) ~= "table" then
		self.Object = { self.Object }
	end

	for _, v in self.Object do
		table.insert(self.Tween, ManagerTweenMaster.Check(v :: Instance, self.Info, self.Action))
	end

	if id then
		SaveTweenClient[id] = self
	end

	return setmetatable(self, CreateTweenClient)
end

function module.newServer(obj: Types.obj, info: Types.dataTween, action: Types.action): Types.TweenMaster
	local self = {}
	self.ID = HttpService:GenerateGUID(false)
	self.Object = obj
	self.Info = info
	self.Action = action

	--if obj is string search the object
	if type(obj) == "string" then
		self.Object = ManagerTweenMaster.searchInstanceWithString(obj)
	end

	return setmetatable(self, CreateTweenServer)
end

function module.Fast(obj: Types.obj, info: TweenInfo, action: Types.action): ()
	local new = module.new(obj, info, action)
	task.defer(function()
		new:Wait()
		new:Destroy()
	end)
end

function module.Wait(obj: Types.obj, info: TweenInfo, action: Types.action): ()
	local new = module.new(obj, info, action)
	new:Wait()
	new:Destroy()
end
return module
