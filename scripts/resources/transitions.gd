extends Resource
@export var transitions = {
	"IDLE" : {
		"AIRBORNE": "AIRBORNE",
		"JUMP": "JUMP",
		"MOVE": "MOVE",
		"CROUCH": "CROUCH",
		"ATTACK": "ATTACK",
	},
	"JUMP" : {
		"JUMP_END": "IDLE"
	},
	"MOVE" : {
		"JUMP": "JUMP",
		"STOP": "IDLE",
		"CROUCH": "CROUCH",
		"ATTACK": "ATTACK",
	},
	"CROUCH" : {
		"JUMP": "JUMP",
		"CROUCH_END": "IDLE",
	},
	"AIRBORNE" : {
		"LAND": "IDLE",
		"ATTACK": "ATTACK",
	},
	"ATTACK": {}
}
