extends State

var total_time = 0
var atk_time_stamp = 0
var timer = 0

func enter():
	total_time = player.cur_atk.startup + player.cur_atk.active + player.cur_atk.recovery
	atk_time_stamp = get_parent().get_step()
	anim.play("hurt")
	print("HELLO WORLD")

func exit():
	pass

func update(_delta: float):
	timer += 1
	print(timer)
	if timer >= player.cur_atk.knockback_strenght * 10:
		timer = 0
		get_parent().send_event("HURT_END")
	pass
	
