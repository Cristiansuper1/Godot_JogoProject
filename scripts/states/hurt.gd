extends State

var current_frame: int = 0

var total_time = 0
var atk_time_stamp = 0
var timer = 0

func enter():
	current_frame = 0
	anim.play("hurt")

	player.set_hitbox_active(false)

func exit():
	current_frame = 0

func update(delta: float):
	current_frame += 1
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
	
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.speed * 2.0 * delta)
	player.move_and_slide()
	
	if current_frame >= player.received_hitstun:
		get_parent().send_event("HURT_END")
	
