extends KinematicBody2D

class_name Soldier


onready var move_state: Node = $States/Move
onready var attack_state: Node = $States/Attack

onready var texture: Sprite = $Texture

var is_crawling:bool = false
var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
	move_state.move()
	texture.animate(move_state.velocity)
	attack_state.attack()


func on_hitbox_area_entered(_area):
	pass # Replace with function body.




