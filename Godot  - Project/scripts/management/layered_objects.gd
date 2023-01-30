extends YSort
class_name LayeredObjects

const CELL_SIZE: int = 16
var avaliable_cells: Array = []
var spawn_cooldown:float = 3

onready var parent: Node2D = get_parent()
onready var timer: Timer = $Timer

export(Array, PackedScene) var enemies_list

func _ready() -> void:
	randomize()
	


func on_timeout() -> void:
	spawn()
	timer.start(spawn_cooldown)
	

func spawn()->void:
	var random_spawn_index: int = randi() % avaliable_cells.size()
	
	var spawn_position: Vector2 = avaliable_cells[random_spawn_index] * CELL_SIZE
	
	var random_enemy_index: int = randi() % enemies_list.size()
	var enemy = enemies_list[random_enemy_index].instance()
	enemy.global_position =  spawn_position
	add_child(enemy)
	
	
