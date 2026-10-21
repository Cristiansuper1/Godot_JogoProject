extends State

var total_time = 0
var atk_time_stamp = 0

func enter():
	total_time = player.cur_atk.startup + player.cur_atk.active + player.cur_atk.recovery
	atk_time_stamp = Engine.get_frames_drawn()
	anim.play(player.cur_atk.name)

func exit():
	pass

func update(_delta: float):
	var now = Engine.get_frames_drawn()	
	var atk_timer = now - atk_time_stamp
	if atk_timer < player.cur_atk.startup:
		player.atk_ativo(true)
	elif atk_timer <= player.cur_atk.startup + player.cur_atk.active:
		player.atk_ativo(false)
	else:
		player.atk_ativo(true)
	
	if atk_timer > total_time:
		get_parent().send_event("ATTACK_END")
	pass
	
