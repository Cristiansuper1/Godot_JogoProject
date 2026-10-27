extends State

func enter():
	anim.play("crouch")

func exit():
	pass

func update(_delta: float):
	if Input.is_action_just_released("p1_down"):
		get_parent().send_event("CROUCH_END")
	
	if Input.is_action_just_pressed("p1_up"):
		get_parent().send_event("JUMP")
