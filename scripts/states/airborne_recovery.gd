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
	
	player.move_and_slide()
