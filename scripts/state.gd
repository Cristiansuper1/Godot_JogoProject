extends Node

class_name State

var player : CharacterBody2D
var anim: AnimatedSprite2D

func setup(player_ref : CharacterBody2D, anim_ref : AnimatedSprite2D):
	player = player_ref
	anim = anim_ref

func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass
