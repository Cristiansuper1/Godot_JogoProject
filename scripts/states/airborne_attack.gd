extends State

var current_frame: int = 0
var total_frames: int = 0

func enter():
	current_frame = 0
	total_frames = player.cur_atk.startup_frames + player.cur_atk.active_frames + player.cur_atk.recovery_frames
	
	player.setup_hitbox()
	player.set_hitbox_active(false)
	
	anim.play(player.cur_atk.anim_name)

func exit():
	player.set_hitbox_active(false)
	current_frame = 0

func update(delta: float):
	if player.is_on_floor():
		get_parent().send_event("LAND")
		return
	
	player.velocity.y += player.gravity * delta
	current_frame += 1
	
	if current_frame <= player.cur_atk.startup_frames:
		player.set_hitbox_active(false)
	elif current_frame <= player.cur_atk.startup_frames + player.cur_atk.active_frames:
		player.set_hitbox_active(true)
	else:
		player.set_hitbox_active(false)
	
	if current_frame >= total_frames:
		get_parent().send_event("ATTACK_END")
	
	player.move_and_slide()
