extends Resource
@export var transitions = {
	"IDLE" : {
		"AIRBORNE": "AIRBORNE",
		"JUMP": "JUMP",
		"MOVE": "MOVE",
		"CROUCH": "CROUCH",
		"ATTACK": "ATTACK",
		"HURT": "HURT",
	},
	"JUMP" : {
		"AIRBORNE": "AIRBORNE",
		"JUMP_END": "IDLE",
	},
	"MOVE" : {
		"JUMP": "JUMP",
		"STOP": "IDLE",
		"CROUCH": "CROUCH",
		"ATTACK": "ATTACK",
		"HURT": "HURT",
	},
	"CROUCH" : {
		"JUMP": "JUMP",
		"CROUCH_END": "IDLE",
		"HURT": "HURT",
	},
	"ATTACK": {
		"ATTACK_END": "IDLE",
		"HURT": "HURT",
	},
	"AIRBORNE" : {
		"LAND": "IDLE",
		"ATTACK": "AIRBORNE_ATTACK",
	},
	"AIRBORNE_ATTACK": {
		"LAND": "IDLE",
		"ATTACK_END": "AIRBONE_RECOVERY"
	},
	"AIRBORNE_RECOVERY": {
		"LAND": "IDLE",
	},
	"HURT": {
		"HURT_END": "IDLE",
	}
}
