extends State

func enter():
	anim.play("idle")
	player.set_crouch_boxes(false)

func exit():
	pass

func update(_delta: float):
	player.check_auto_turn()
	
	if not player.is_on_floor():
		get_parent().send_event("AIRBORNE")
		return
	
	if player.check_attack_inputs():
		return
	
	if player.check_dash_inputs():
		return
	
	var prefix = player.input_prefix
	
	if Input.is_action_pressed(prefix + "up"):
		get_parent().send_event("JUMP")
	elif Input.is_action_pressed(prefix + "down"):
		get_parent().send_event("CROUCH")
	elif Input.is_action_pressed(prefix + "left") or Input.is_action_pressed(prefix + "right"):
		get_parent().send_event("MOVE")
		
	player.move_and_slide()
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.speed)
