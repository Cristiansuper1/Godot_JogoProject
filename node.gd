extends Node

@onready var TRANSITIONS = {
	"IDLE": {
		"JUMP": "JUMP"
	},
	"JUMP": {
		"JUMP_END": "IDLE"
	}
}
