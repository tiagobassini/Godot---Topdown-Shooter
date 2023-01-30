extends Area2D
class_name BaseProjectile

signal camera_shake

var already_destroyed: bool = false

var direction:Vector2 = Vector2.ZERO

export(int) var damage
export(int) var move_speed

export(float) var shake_life_time
export(float) var shake_strength

export(PackedScene) var explosion_effect


func _physics_process(delta: float) -> void:
	translate(direction*move_speed*delta)
	


func on_screen_exited() -> void:
	if not already_destroyed:
		kill()


func on_body_entered(body: Node) -> void:
	if body is TileMap:
		kill()


func kill()->void:
	emit_signal("camera_shake", shake_life_time, shake_strength)
	already_destroyed = true
	spawn_explosion()
	queue_free()

func spawn_explosion()->void:
	var explosion = explosion_effect.instance()
	get_tree().root.call_deferred("add_child", explosion)
	explosion.global_position = global_position

