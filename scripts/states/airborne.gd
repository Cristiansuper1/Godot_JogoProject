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

	if player.check_attack_inputs():
		return

	player.move_and_slide()
