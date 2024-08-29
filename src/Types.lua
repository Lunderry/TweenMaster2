export type dataTween = {
	time: number?,
	easingStyle: Enum.EasingStyle?,
	easingDirection: Enum.EasingDirection?,
	repeatCount: number?,
	reverses: boolean?,
	delayTime: number?,
}

export type obj = string | Instance | { Instance }
export type action = { [string]: any }

export type TweenMaster = {
	Object: Instance | { Instance },
	ID: string,
	Send: boolean,
	Info: TweenInfo,
	Action: action,

	Tween: { Tween },
	Play: (self: TweenMaster) -> (),
	Wait: (self: TweenMaster) -> (),
	Pause: (self: TweenMaster) -> (),
	Cancel: (self: TweenMaster) -> (),
	WaitTable: (self: TweenMaster) -> (),
	Destroy: (self: TweenMaster) -> (),
}

return nil
