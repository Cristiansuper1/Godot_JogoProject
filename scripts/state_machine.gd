extends Node

@export var player: CharacterBody2D
@export var anim : AnimatedSprite2D

var transitions = {
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
		"JUMP_END": "IDLE"
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
		"HURT": "HURT"
	},
	"ATTACK": {
		"ATTACK_END": "IDLE",
		"HURT": "HURT"
	},
	"AIRBORNE" : {
		"LAND": "IDLE",
		"ATTACK": "AIRBORNE_ATTACK",
	},
	"AIRBORNE_ATTACK" : {
		"LAND": "IDLE",
		"ATTACK_END": "AIRBORNE"
	},
	"AIRBORNE_RECOVERY" : {
		"LAND": "IDLE",
	},
	"HURT" : {
		"HURT_END": "IDLE",
	}
}

@onready var cur_step = 0

@export var rurtibocs : CharacterBody2D

var cur_state = State

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.setup(player, anim)
	
	if get_child_count() > 0:
		cur_state = get_child(0)
		cur_state.enter()

func send_event(event_name : String):
	var name_ev = cur_state.name.to_upper()
	
	if transitions.has(name_ev):
		var allowed_events = transitions[name_ev]
		
		if  allowed_events.has(event_name):
			var next_state_name = allowed_events[event_name]
			
			cur_state.exit()
			cur_state = get_node(next_state_name)
			cur_state.enter()

func get_step():
	return cur_step
	
func _physics_process(delta: float):
	cur_step += 1
	if cur_state:
		cur_state.update(delta)
