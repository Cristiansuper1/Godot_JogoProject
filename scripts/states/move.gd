extends State

func enter():
	anim.play("move-front")
	player.set_crouch_boxes(false)

func exit():
	pass

func update(_delta: float):
	player.check_auto_turn()
	
	if not player.is_on_floor():
		get_parent().send_event("AIRBORNE")
		return
	
	var prefix = player.input_prefix
	
	if player.check_attack_inputs():
		return
	
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
		get_parent().send_event("JUMP")
	elif Input.is_action_just_pressed(prefix + "down"):
		get_parent().send_event("CROUCH")
	
	player.move_and_slide()
