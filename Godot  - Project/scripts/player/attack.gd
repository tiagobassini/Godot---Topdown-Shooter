extends Node
class_name AttackState

const GRENADE: PackedScene = preload("res://scenes/player/projectile/grenade.tscn")


onready var weapons_dict: Dictionary = {
	"throw": "Grenade",
	"fire": class_weapon
}

var weapon_list: Array = [
	"fire",
	"throw"
]

var weapon_index: int = 0

export var grenade_amount:int
export var max_grenade_amount:int = 5

export var projectile_amount: int
export var max_projectile_amount: int


export(String) var class_weapon 
export(PackedScene) var fire_projectile


export(NodePath) onready var texture = get_node(texture) as Sprite
export(NodePath) onready var camera = get_node(camera) as Camera2D
export(NodePath) onready var soldier = get_node(soldier) as KinematicBody2D
export(NodePath) onready var projectile_spawner = get_node(projectile_spawner) as Position2D


func _ready() -> void:
	projectile_amount = max_projectile_amount
	grenade_amount = max_grenade_amount
	set_text(weapon_list[weapon_index])
	

func attack()->void:
	
	if not can_shoot(weapon_list[weapon_index]):
		return 
	
	if Input.is_action_just_pressed("attack") and not soldier.is_attacking:
		camera.shake(0.25, 0.13)
		soldier.is_attacking = true
		update_ammo(weapon_list[weapon_index], "decrease", 1)

		texture.action_behavior(weapon_list[weapon_index])


func can_shoot(type: String)->bool:
	match type:
		"fire":
			return projectile_amount>0
		"throw":
			return grenade_amount >0
		_:
			return false


func update_ammo(weapon_type:String , type:String, value:int)->void:
	var pattern:Array= [weapon_type, type]

	match pattern:
		["fire", "increase"]:
			projectile_amount +=value 
			if projectile_amount>max_projectile_amount :
				 projectile_amount = max_projectile_amount
		["fire", "decrease"]:
			projectile_amount -=value
		["throw", "increase"]:
			grenade_amount +=value 
			if grenade_amount>max_grenade_amount:
				 grenade_amount = max_grenade_amount
		["throw", "decrease"]:
			grenade_amount -=value
		[_,_]:
			print("padrao nao encontrado")
		
	if weapon_type == weapon_list[weapon_index] :
		set_text(weapon_type)
	
func spawn_projectile(type:String)->void:
	var projectile_direction:Vector2 = (soldier.get_global_mouse_position() - soldier.global_position).normalized()
	var projectile = null
	
	match type:
		"fire":
			projectile = fire_projectile.instance()
			
		"throw":
			projectile = GRENADE.instance()
	
	get_tree().root.call_deferred("add_child",projectile)
	projectile.global_position = projectile_spawner.global_position
	projectile.connect("camera_shake", camera, "shake")
	projectile.direction = projectile_direction
	


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	var event_as_number: int = event.button_index
	
	if event_as_number ==4 and can_change_weapon_index(4) :
		weapon_index += 1
	
	if event_as_number ==5 and can_change_weapon_index(5) :
		weapon_index -=1
	
	set_text(weapon_list[weapon_index])

func can_change_weapon_index(index:int)->bool:
	
	if index == 4 and weapon_index == weapon_list.size()-1 :
		return false
	if index == 5 and weapon_index == 0 :
		return false
	
	return true

func set_text(current_weapon:String)->void:
	get_tree().call_group("interface","set_weapon_text", weapons_dict[current_weapon])
	if current_weapon == "throw":
			get_tree().call_group("interface","set_weapon_ammo", grenade_amount, max_grenade_amount)
	
	if current_weapon == "fire":
			get_tree().call_group("interface","set_weapon_ammo", projectile_amount, max_projectile_amount)
	
	
