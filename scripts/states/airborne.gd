extends State

func enter():
	anim.play("jump")

func exit():
	pass

func update(delta: float):
	if player.is_on_floor():
		get_parent().send_event("LAND")
	else:
		player.velocity.y += player.gravity * delta
		
		if Input.is_action_just_pressed("p1_lp"):
			player.cur_atk = player.char_move_list[player.char_name]['light_punch']
			get_parent().send_event("ATTACK")
		if Input.is_action_just_pressed("p1_mp"):
			player.cur_atk = player.char_move_list[player.char_name]['medium_punch']
			get_parent().send_event("ATTACK")
	
	player.move_and_slide()
