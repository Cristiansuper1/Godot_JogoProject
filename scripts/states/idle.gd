extends State

func enter():
	anim.play("idle")

func exit():
	pass

func update(_delta: float):
	player.check_auto_turn()
	if not player.is_on_floor():
		get_parent().send_event("AIRBORNE")
	else:
		var prefix = player.input_prefix
		
		if Input.is_action_pressed(prefix + "up"):
			get_parent().send_event("JUMP")
		elif Input.is_action_pressed(prefix + "down"):
			get_parent().send_event("CROUCH")
		elif Input.is_action_pressed(prefix + "left") or Input.is_action_pressed(prefix + "right"):
			get_parent().send_event("MOVE")
		
		if Input.is_action_just_pressed(prefix + "lp"):
			player.cur_atk = player.light_punch_atk
			get_parent().send_event("ATTACK")
		elif Input.is_action_just_pressed(prefix + "mp"):
			player.cur_atk = player.medium_punch_atk
			get_parent().send_event("ATTACK")
		elif Input.is_action_just_pressed(prefix + "lk"):
			player.cur_atk = player.light_kick_atk
			get_parent().send_event("ATTACK")
		
	player.move_and_slide()
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.speed)
