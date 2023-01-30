extends KinematicBody2D
class_name Enemy

onready var texture = $Texture
onready var collision = $Collision
onready var monitoring_timer = $MonitoringTimer

onready var animation: AnimationPlayer = $Animation

var is_near: bool = false

var distance: float
var path: Array = []
var velocity:Vector2 = Vector2.ZERO

var items_dict: Dictionary = {
	"MW Ammo": [[1,40], preload("res://scenes/player/ammo/main_weapon_ammo.tscn")],
	"Grenade Ammo": [[41,60], preload("res://scenes/player/ammo/main_weapon_ammo.tscn")],
	"Health": [[61,80], preload("res://scenes/combat/health.tscn")]
}

export(float) var attack_cooldown
export(int) var damage
export(int) var move_speed
export(int) var distance_threshold

func get_player(player_reference, navegation: Navigation2D)->void:
	path = navegation.get_simple_path(global_position, player_reference.global_position, false)
	
	if path.empty() :
		return
	
	distance = global_position.distance_to(player_reference.global_position)
	
	velocity = global_position.direction_to(path[1])*move_speed
	if global_position == path[0]:
		path.pop_front()
	
func _physics_process(_delta):
	animate()
	if distance< distance_threshold:
		is_near = true
		return
	
	is_near = false
	var _retorno = move_and_slide(velocity)
	verify_direction()
	

func verify_direction()->void:
	if velocity.x>0:
		texture.flip_h = false
	elif velocity.x <0:
		texture.flip_h = true

func animate()->void:
	if velocity !=Vector2.ZERO:
		animation.play("walk")
	else:
		animation.stop()
		

func set_collision()->void:
	change_monitoring_state(true)
	monitoring_timer.start(attack_cooldown)

func change_monitoring_state(state:bool)->void:
	collision.set_deferred("disabled", state)

func on_monitoring_timeout():
	change_monitoring_state(false)


func on_screen_entered():
	visible =true


func on_screen_exited():
	visible=false


func kill() -> void:
	roll_dice()
	queue_free()


func roll_dice()->void:
	for item in items_dict.keys() :
		get_item(item)

func get_item(item_key:String)->void:
	var random_number:int = randi()%100+1
	var drop_probability_list: Array = items_dict[item_key][0]
	
	var min_number: int  = drop_probability_list[0]
	var max_number: int  = drop_probability_list[1]
	
	if random_number >= min_number and random_number <= max_number :
		spawn_item(items_dict[item_key][1])
		
func spawn_item(item_to_spawn)-> void:
	var item = item_to_spawn.instance()
	get_tree().root.call_deferred("add_child", item)
	item.global_position = global_position
