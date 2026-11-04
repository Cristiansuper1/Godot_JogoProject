extends Resource
@export var transitions = {
	"IDLE": {
		"AIRBORNE": "AIRBORNE",
		"JUMP": "JUMP",
		"MOVE": "MOVE",
		"CROUCH": "CROUCH",
		"ATTACK": "ATTACK",
		"HURT": "HURT",
		"BLOCK": "BLOCK",
	},
	"JUMP": {
		"AIRBORNE": "AIRBORNE",
		"JUMP_END": "IDLE",
	},
	"MOVE": {
		"JUMP": "JUMP",
		"STOP": "IDLE",
		"CROUCH": "CROUCH",
		"ATTACK": "ATTACK",
		"HURT": "HURT",
		"BLOCK": "BLOCK",
	},
	"CROUCH": {
		"JUMP": "JUMP",
		"CROUCH_END": "IDLE",
		"HURT": "HURT",
		"BLOCK": "BLOCK",
	},
	"ATTACK": {
		"ATTACK_END": "IDLE",
		"HURT": "HURT",
	},
	"AIRBORNE": {
		"LAND": "IDLE",
		"ATTACK": "AIRBORNE_ATTACK",
	},
	"AIRBORNE_ATTACK": {
		"LAND": "IDLE",
		"ATTACK_END": "AIRBORNE_RECOVERY",
	},
	"AIRBORNE_RECOVERY": {
		"LAND": "IDLE",
	},
	"HURT": {
		"HURT_END": "IDLE",
	},
	"BLOCK": {
		"BLOCK_END": "IDLE",
		"BLOCK_END_CROUCH": "CROUCH",
		"HURT": "HURT",
	}
}
