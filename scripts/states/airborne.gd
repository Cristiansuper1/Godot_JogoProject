extends State

func enter():
	anim.play("jump")

func exit():
	pass

func update(delta: float):
	if player.is_on_floor():
		get_parent().send_event("LAND")
		return

	player.velocity.y += player.gravity * delta
	var prefix = player.input_prefix

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
