extends State
var total_time = 0
var atk_time_stamp = 0

func enter():
	
	total_time = player.cur_atk.startup + player.cur_atk.active + player.cur_atk.recovery
	atk_time_stamp = Engine.get_frames_drawn()
	anim.play(player.cur_atk.name)

func exit():
	pass

func update(delta: float):
	if player.is_on_floor():
		get_parent().send_event("LAND")
	else:
		player.velocity.y += player.gravity * delta
		
		var now = Engine.get_frames_drawn()
	
		if now - atk_time_stamp > total_time:
			get_parent().send_event("ATTACK_END")
	pass
	
	player.move_and_slide()
