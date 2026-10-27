extends State

func enter():
	anim.play("crouch")

func exit():
	pass

func update(_delta: float):
	player.check_auto_turn()
	var prefix = player.input_prefix
	
	if Input.is_action_just_released(prefix + "down"):
		get_parent().send_event("CROUCH_END")
	elif Input.is_action_just_pressed(prefix + "up"):
		get_parent().send_event("JUMP")
