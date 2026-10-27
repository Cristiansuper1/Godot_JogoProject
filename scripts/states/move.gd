extends State

func enter():
	anim.play("move-front")

func exit():
	print("Parando")

func update(_delta: float):
	var dir = Input.get_axis("p1_left", "p1_right")
	
	player.velocity.x = player.speed * dir
	if dir == 0:
		get_parent().send_event("STOP")
	
	if Input.is_action_just_pressed("p1_up"):
		player.velocity.x = player.speed * dir
		get_parent().send_event("JUMP")
	
	if Input.is_action_just_pressed("p1_down"):
		get_parent().send_event("CROUCH")
	
	if Input.is_action_just_pressed("p1_lp"):
		player.cur_atk = player.char_move_list[player.char_name]["light_punch"]
		get_parent().send_event("ATTACK")
	elif Input.is_action_just_pressed("p1_mp"):
			player.cur_atk = player.char_move_list[player.char_name]["medium_punch"]
			get_parent().send_event("ATTACK")
	
	player.move_and_slide()
	
