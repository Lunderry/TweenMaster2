export type dataTween = {
	time: number?,
	easingStyle: Enum.EasingStyle?,
	easingDirection: Enum.EasingDirection?,
	repeatCount: number?,
	reverses: boolean?,
	delayTime: number?,
}

export type _objCreate = { [number]: Instance }
export type idInstances = { [string]: Instance | { Instance } }
export type action = { [string]: any }

export type ClientClass = typeof(setmetatable({}, {})) & {
	__index: ClientClass,

	Play: (self: ClientTweenMaster) -> (),
	Wait: (self: ClientTweenMaster) -> (),
	Pause: (self: ClientTweenMaster) -> (),
	Cancel: (self: ClientTweenMaster) -> (),
	WaitTable: (self: ClientTweenMaster) -> (),
	Destroy: (self: ClientTweenMaster) -> (),
}
export type ClientTweenMaster = ClientClass & {
	Instances: idInstances,
	ID: string,
	Info: TweenInfo,
	Action: action,
	Tween: { Tween },
}
export type ServerClass = typeof(setmetatable({}, {})) & {
	__index: ClientClass,

	Play: (self: ServerTweenMaster, Player?) -> (),
	Wait: (self: ServerTweenMaster, Player?) -> (),
	Pause: (self: ServerTweenMaster, Player?) -> (),
	Cancel: (self: ServerTweenMaster, Player?) -> (),
	WaitTable: (self: ServerTweenMaster, Player?) -> (),
	Destroy: (self: ServerTweenMaster, Player?) -> (),
}
export type ServerTweenMaster = ServerClass & {
	Instances: idInstances,
	ID: string,
	Info: TweenInfo,
	Action: action,
}

export type ManagerTweenMaster = {
	DATANEUTRAL: dataTween,
	clearActions: (inst: idInstances, action: action) -> action,
	objectsGenerateUI: (inst: _objCreate) -> idInstances,
	searchInstanceWithString: (str: string) -> _objCreate | nil,
	createTweenInfo: (specs: dataTween) -> TweenInfo,
	Model: (model: Model, info: TweenInfo, action: action) -> Tween,
	Check: (obj: Instance, info: TweenInfo, action: action) -> Tween,
}

return nil
