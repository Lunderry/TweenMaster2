--!strict
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
--
local Types = require(script.Parent.Types)

local module = {} :: Types.ManagerTweenMaster

module.DATANEUTRAL = {
	["1"] = 0,
	["2"] = Enum.EasingStyle.Linear,
	["3"] = Enum.EasingDirection.In,
	["4"] = 0,
	["5"] = false,
	["6"] = 0,
} :: Types.dataTween
--
---@param inst Types.idInstances
---@param action Types.action
---@return any
function module.clearActions(inst: Types.idInstances, action: Types.action): Types.action
	for property, act in action do
		if type(act) ~= "function" then
			continue
		end
		action[property] = {}
		for id, instance in pairs(inst) do
			action[property][id] = act(instance)
		end
	end
	return action
end
---@param inst Types._objCreate
---@return Types.idInstances
function module.objectsGenerateUI(inst: Types._objCreate): Types.idInstances
	local newTable = {} :: Types.idInstances
	for _, v in inst do
		newTable[HttpService:GenerateGUID(false)] = v
	end
	return newTable :: Types.idInstances
end
--

---@param specs Types.dataTween
---@return TweenInfo
function module.createTweenInfo(specs: Types.dataTween): TweenInfo
	for i, v in module.DATANEUTRAL do
		if specs[i] == nil then
			specs[i] = v
		end
	end

	return TweenInfo.new(table.unpack(specs) :: number) :: TweenInfo
end
--

---@param str string
---@return nil
function module.searchInstanceWithString(str: string): Types._objCreate | nil
	local result: { string } = {}
	for match in (str .. "."):gmatch("(.-)" .. "%.") do
		table.insert(result, match)
	end
	local rp = game
	for _, v in result do
		if rp:FindFirstChild(v) then
			rp = rp[v]
			continue
		end
		warn(rp:GetFullName() .. " to " .. v .. " No exist.")
		return nil
	end
	return { rp }
end
---@param model Model
---@param info TweenInfo
---@param action Types.action
---@return any
function module.Model(model: Model, info: TweenInfo, action: Types.action): Tween
	local cf: CFrame
	for i, v in action do
		if i == "CFrame" then
			cf = v :: CFrame
		end
	end

	local cframeValue: CFrameValue

	local findFirstChildModel = model:FindFirstChild("_TweenModel") :: CFrameValue
	if findFirstChildModel then
		findFirstChildModel.Value = model:GetPivot()
		return TweenService:Create(findFirstChildModel, info, { Value = cf })
	else
		cframeValue = Instance.new("CFrameValue", model)
		cframeValue.Name = "_TweenModel"
	end
	cframeValue.Value = model:GetPivot()

	local getPropertyChangedSignal

	getPropertyChangedSignal = cframeValue:GetPropertyChangedSignal("Value"):Connect(function()
		model:PivotTo(cframeValue.Value)
	end)

	cframeValue.Destroying:Once(function()
		getPropertyChangedSignal:Disconnect()
	end)

	return TweenService:Create(cframeValue, info, { Value = cf })
end
--

local function verifyAction(inst: Instance, action: Types.action): Types.action
	local n = {}

	for i, v in action do
		local success = pcall(function()
			return (inst :: any)[i]
		end)
		if success then
			n[i] = v
		end
	end
	return n
end
--
---@param inst Instance
---@param info TweenInfo
---@param action Types.action
---@return any
function module.Check(inst: Instance, info: TweenInfo, action: Types.action): Tween
	if inst:IsA("Model") then
		return module.Model(inst, info, action)
	else
		return TweenService:Create(inst, info, verifyAction(inst, action))
	end
end
--

return module
