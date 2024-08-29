--!strict
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
--
local Types = require(script.Parent.Types)

local module = {}

module.DATANEUTRAL = {
	0,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.In,
	0,
	false,
	0,
} :: { any }
--
function module.clearActions(obj: { [string]: Instance }, action: Types.action): Types.action
	for property, act in action do
		if type(act) ~= "function" then
			continue
		end
		action[property] = {}
		for id, instance in pairs(obj) do
			action[property][id] = act(instance)
		end
	end
	return action
end
--
function module.objectsGenerateUI(obj: { Instance }): { ["1"]: Instance, ["2"]: string }
	local newTable = {}
	for _, v in obj do
		newTable[HttpService:GenerateGUID(false)] = v
	end
	return newTable
end
--
function module.createTweenInfo(specs: { any }): TweenInfo
	for i, v in module.DATANEUTRAL do
		if specs[i] == nil then
			specs[i] = v
		end
	end

	return TweenInfo.new(table.unpack(specs) :: number) :: TweenInfo
end
--
function module.searchInstanceWithString(str: string): Instance | nil
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
	return rp
end
---@param model Model
---@param info TweenInfo
---@param action any
---@return any
function module.Model(model: Model, info: TweenInfo, action: Types.action): Tween
	local cf: CFrame
	for i, v in action do
		if i == "CFrame" then
			cf = v :: CFrame
		end
	end

	local cframeValue: CFrameValue = model:FindFirstChild("_TweenModel")

	if cframeValue then
		cframeValue.Value = model:GetPivot()
		return TweenService:Create(cframeValue, info, { Value = cf })
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

local function verifyAction(inst: any, action: { [string]: any }): {}
	local n = {}

	for i, v in action do
		local success = pcall(function()
			return inst[i]
		end)
		if success then
			n[i] = v
		end
	end
	return n
end
--
function module.Check(obj: Instance, info: TweenInfo, action: Types.action): Tween
	if obj:IsA("Model") then
		return module.Model(obj, info, action)
	else
		return TweenService:Create(obj, info, verifyAction(obj, action))
	end
end
--

return module
