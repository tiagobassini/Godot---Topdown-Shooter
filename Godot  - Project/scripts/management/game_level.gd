extends Node2D
class_name GameLevel


onready var base_terreain: TileMap = $Navigation2D/BaseTerreain
onready var assault: KinematicBody2D = $LayeredObjects/Assault
onready var navigation = $Navigation2D
onready var layered_objects:YSort = $LayeredObjects


const CELL_SIZE:int = 16

var avaliable_spawn_tiles_list: Array = []

func _ready() -> void:
	define_camera_limit()
	set_spawn_tiles()

func set_spawn_tiles()->void:
	for tile in base_terreain.get_used_cells() :
		find_edges(tile)
	
	layered_objects.avaliable_cells = avaliable_spawn_tiles_list

func find_edges(current_cell: Vector2) ->void:
	var used_rect: Rect2 = base_terreain.get_used_rect()
	var x_size: float = used_rect.size.x
	var y_size: float = used_rect.size.y
	
	var x_pos: float = used_rect.position.x
	var y_pos: float = used_rect.position.y
	
	if current_cell.x == x_size -1 or current_cell.x == x_pos:
		avaliable_spawn_tiles_list.append(current_cell)
		
		
	if current_cell.y == y_size -1 or current_cell.y == y_pos:
		avaliable_spawn_tiles_list.append(current_cell)
	

func define_camera_limit():
	var soldier_camera:Camera2D = assault.get_node("Camera")
	
	var userd_rect_tile: Rect2 = base_terreain.get_used_rect()
	
	soldier_camera.limit_left = int(userd_rect_tile.position.x)
	soldier_camera.limit_top = int(userd_rect_tile.position.y)
	soldier_camera.limit_right = int(userd_rect_tile.size.x * CELL_SIZE)
	soldier_camera.limit_bottom = int(userd_rect_tile.size.y * CELL_SIZE)
	


func _process(_delta:float)->void:
	if assault == null :
		return
	
	send_player()


func send_player()->void:
	get_tree().call_group("enemy","get_player", assault, navigation)
	
