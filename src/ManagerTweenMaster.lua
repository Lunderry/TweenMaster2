--!strict
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

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
function module.createTweenInfo(specs: { any }): TweenInfo
	for i, v in module.DATANEUTRAL do
		if specs[i] == nil then
			specs[i] = v
		end
	end

	return TweenInfo.new(table.unpack(specs) :: number) :: TweenInfo
end
--
function module.create(obj: Instance | {} | Model, info: TweenInfo, action: {}): Tween
	return TweenService:Create(obj, info, action)
end
--
local saveModel = {}
function module.model(model: Model, info: TweenInfo, action: {}, id: number): Tween
	local folder: any
	if not script.Parent:FindFirstChild(id) then
		folder = Instance.new("Folder", script.Parent)
		folder.Name = id
	else
		folder = script.Parent[id]
	end

	local cframeValue: CFrameValue

	if saveModel[model] then
		cframeValue = folder:FindFirstChild(saveModel[model])
	else
		local newID = HttpService:GenerateGUID()
		cframeValue = Instance.new("CFrameValue", folder)
		cframeValue.Name = newID
		saveModel[model] = newID
	end

	local getPropertyChangedSignal

	cframeValue.Value = model:GetPivot()
	getPropertyChangedSignal = cframeValue:GetPropertyChangedSignal("Value"):Connect(function()
		model:PivotTo(cframeValue.Value)
	end)

	cframeValue.Destroying:Once(function()
		getPropertyChangedSignal:Disconnect()
		saveModel[model] = nil
	end)

	local cf: CFrame
	for i, v in action do
		if i == "CFrame" then
			cf = v :: CFrame
		end
	end

	return module.create(cframeValue, info, { Value = cf })
end
--
function module.check(obj: Instance, info: TweenInfo, action: {}, id: number): Tween
	if obj:IsA("Model") then
		return module.model(obj, info, action, id)
	else
		return module.create(obj, info, action)
	end
end
--
return module
