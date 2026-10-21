extends CharacterBody2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner != self.owner:
		print("Dummy atingido!")
