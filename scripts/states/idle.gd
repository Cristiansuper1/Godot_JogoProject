extends State

func enter():
	anim.play("idle")

func exit():
	print("Prestes a agir")

func update(_delta: float):
	if not player.is_on_floor():
		get_parent().send_event("AIRBORNE")
	else:
		if Input.is_action_pressed("p1_up"):
			get_parent().send_event("JUMP")
		
		if Input.is_action_pressed("p1_left") or Input.is_action_pressed("p1_right"):
			get_parent().send_event("MOVE")
		
		if Input.is_action_pressed("p1_down"):
			get_parent().send_event("CROUCH")
		
		if Input.is_action_just_pressed("p1_lp"):
			player.cur_atk = player.char_move_list[player.char_name]["light_punch"]
			get_parent().send_event("ATTACK")
		elif Input.is_action_just_pressed("p1_mp"):
			player.cur_atk = player.char_move_list[player.char_name]["medium_punch"]
			get_parent().send_event("ATTACK")
		elif Input.is_action_just_pressed("p1_lk"):
			player.cur_atk = player.char_move_list[player.char_name]["light_kick"]
			get_parent().send_event("ATTACK")
		
	player.move_and_slide()
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.speed)
