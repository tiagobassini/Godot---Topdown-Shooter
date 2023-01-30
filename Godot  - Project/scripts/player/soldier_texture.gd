extends Sprite
class_name SoldierTexture

var last_direction: bool = false
var on_action: bool = false
var spawn_position:float = 6


export(NodePath) onready var parent = get_node(parent) as KinematicBody2D
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var projectile_spawner = get_node(projectile_spawner) as Position2D


func animate(velocity: Vector2)->void:
	flip_h = set_orientation()
	if not on_action:
		move_behavior(velocity)
	

func set_orientation()->bool:
	var mouse_global_position: Vector2 = get_global_mouse_position()
	
	if mouse_global_position > parent.global_position:
		projectile_spawner.position.x = spawn_position
		last_direction= false
		return false
	
	if mouse_global_position < parent.global_position:
		projectile_spawner.position.x = -spawn_position
		last_direction=true
		return true
	
	return last_direction

func action_behavior(state:String)->void:
	on_action = true
	animation.play(state)

func move_behavior(velocity:Vector2)-> void:
	if velocity != Vector2.ZERO:
		animation.play(get_move_state())
		return
	
	animation.play("idle")
		

func get_move_state()->String:
	if parent.is_crawling:
		return "crawl"
	
	return "walk"


func on_animation_finished(anim_name: String) -> void:
	on_action=false
	if anim_name == "fire" or anim_name == "throw":
		parent.is_attacking=false
	
	if anim_name == "hit" :
		parent.set_physics_process(true)
	
	if anim_name == "death" :
		get_tree().call_group("interface", "reload_game")
	











