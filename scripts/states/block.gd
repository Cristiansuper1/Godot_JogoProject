extends State

var current_frame: int = 0
var blockstun_duration: int = 0

func enter():
	current_frame = 0
	blockstun_duration = player.received_blockstun
	
	var prefix = player.input_prefix
	if Input.is_action_pressed(prefix + "down"):
		anim.play("parry-crouch")
		player.set_crouch_boxes(true)
	else:
		anim.play("parry")
		player.set_crouch_boxes(false)
	
	player.set_hitbox_active(false)

func exit():
	current_frame = 0

func update(delta: float):
	current_frame += 1
	
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
	
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.speed * 3.0 * delta)
	player.move_and_slide()
	
	if current_frame >= blockstun_duration:
		var prefix = player.input_prefix
		if Input.is_action_pressed(prefix + "down"):
			get_parent().send_event("BLOCK_END_CROUCH")
		else:
			get_parent().send_event("BLOCK_END")
