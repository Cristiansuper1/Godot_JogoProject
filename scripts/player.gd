extends CharacterBody2D
class_name Player

signal take_damage(event: String)

@export var speed: float = 200.0
@export var jump_force: float = -600.0
@export var gravity: float = 1400

@onready var anim = $AnimatedSprite2D

@onready var state_machine = $StateMachine
@onready var cur_atk

@onready var char_name = "ryu"

@export var enemy : Player

@onready var char_move_list = {}

func _ready() -> void:
	$StateMachine/MOVEDATAMANAGER.carregar_dados_arquivo(self)
	take_damage.connect(state_machine.send_event)
	print(enemy.get_child(3).name)


func atk_ativo(active: bool):
	$LightPunch/CollisionShape2D.disabled = active

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.owner != self.owner:
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAI!")
		take_damage.emit("HURT")
