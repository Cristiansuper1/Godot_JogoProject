extends State

func enter():
	anim.play("move-front")

func exit():
	pass

func update(_delta: float):
	player.check_auto_turn()
	
	var prefix = player.input_prefix
	var dir = Input.get_axis(prefix + "left", prefix + "right")
	
	player.velocity.x = player.speed * dir
	if dir == 0:
		get_parent().send_event("STOP")
		return
	
	var moving_forward = (dir > 0 and player.is_facing_right) or (dir < 0 and not player.is_facing_right)
	if moving_forward:
		if anim.animation != "move-front":
			anim.play("move-front")
	else:
		if anim.animation != "move-back":
			anim.play("move-back")
	
	if Input.is_action_just_pressed(prefix + "up"):
		player.velocity.x = player.speed * dir
		get_parent().send_event("JUMP")
	elif Input.is_action_just_pressed(prefix + "down"):
		get_parent().send_event("CROUCH")
	
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
