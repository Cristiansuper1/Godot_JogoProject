extends State

func enter():
	anim.play("jump")

func update(_delta: float):
	if player.is_on_floor():
		if Input.is_action_pressed("p1_left") or Input.is_action_pressed("p1_right"):
			var dir = Input.get_axis("p1_left", "p1_right")
			player.velocity.x = player.speed * dir
		player.velocity.y += player.jump_force
	else:
		get_parent().send_event("AIRBORNE")
	
	player.move_and_slide()
	
	if player.is_on_floor():
		get_parent().send_event("JUMP_END")
		

func exit():
	print("Pousando!")
