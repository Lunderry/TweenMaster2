--!nonstrict
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
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
	local specs: { [any]: any } = { _time, _easingStyle, _easingDirection, _repeatCount, _reverses, _delayTime }
	for i, v in ManagerTweenMaster.DATANEUTRAL do
		if specs[i] == nil then
			specs[i] = v
		end
	end

	return specs :: Types.dataTween
end

---Only use in client.
---@param instance string | Instance | {[number]: Instance}
---@param info Types.dataTween
---@param action Types.action
---@param id string?
---@return any
function module.newClient(
	instance: string | Instance | { [number]: Instance },
	info: Types.dataTween,
	action: Types.action,
	id: string?
): Types.ClientTweenMaster
	if SaveTweenClient[id] then
		return SaveTweenClient[id]
	end
	local self = {}
	self.Tween = {}
	self.Instances = nil
	self.Info = if type(info) == "table" then ManagerTweenMaster.createTweenInfo(info) else info
	self.Action = action
	self.ID = id

	--if obj is string search the object
	if type(instance) == "string" then
		instance = ManagerTweenMaster.searchInstanceWithString(instance :: string) :: Types._objCreate
	end

	--put table
	if type(instance) ~= "table" then
		instance = { instance :: Instance }
	end

	local objCreate = instance :: Types._objCreate
	if objCreate[1] ~= nil then
		self.Instances = ManagerTweenMaster.objectsGenerateUI(objCreate)
	else
		self.Instances = objCreate
	end

	self.Action = ManagerTweenMaster.clearActions(self.Instances, action)

	for insId, inst in pairs(self.Instances) do
		local act = {}

		for property, value in pairs(action) do
			if type(value) == "table" then
				act[property] = value[insId]
			else
				act[property] = value
			end
		end
		table.insert(self.Tween, ManagerTweenMaster.Check(inst :: Instance, self.Info, act))
	end

	if id then
		SaveTweenClient[id] = self
	end

	return setmetatable(self, CreateTweenClient) :: Types.ClientTweenMaster
end

---All tween execute in client
---@param instance string | Instance | {[number]: Instance}
---@param info Types.dataTween
---@param action Types.action
---@return Types.ServerTweenMaster
function module.newServer(
	instance: string | Instance | { [number]: Instance },
	info: Types.dataTween,
	action: Types.action
): Types.ServerTweenMaster
	local self = {}
	self.ID = HttpService:GenerateGUID(false)
	self.Instances = instance
	self.Info = info

	--if obj is string search the object
	if type(instance) == "string" then
		instance = ManagerTweenMaster.searchInstanceWithString(instance :: string) :: Types._objCreate
	end

	--put table
	if type(instance) ~= "table" then
		instance = { instance }
	end

	local objCreate = instance :: Types._objCreate
	if objCreate[1] ~= nil then
		self.Instances = ManagerTweenMaster.objectsGenerateUI(objCreate)
	else
		self.Instances = objCreate
	end

	--execute the function to pass to client
	self.Action = ManagerTweenMaster.clearActions(self.Instances, action)

	return setmetatable(self, CreateTweenServer) :: Types.ServerTweenMaster
end

function module.Fast(obj: Types._objCreate, info: Types.dataTween, action: Types.action): ()
	local new = if RunService:IsClient()
		then module.newClient(obj, info, action)
		else module.newServer(obj, info, action)

	task.defer(function()
		new:Wait()
		new:Destroy()
	end)
end

function module.Wait(obj: Types._objCreate, info: Types.dataTween, action: Types.action): ()
	local new = if RunService:IsClient()
		then module.newClient(obj, info, action)
		else module.newServer(obj, info, action)

	new:Wait()
	new:Destroy()
end
return module
