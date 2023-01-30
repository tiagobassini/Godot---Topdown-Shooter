extends BaseProjectile

onready var timer: Timer = $Timer
onready var animation: AnimationPlayer = $Animation
onready var collision: CollisionShape2D = $Collision


func on_body_entered(_body)->void:
	pass
	


func on_animation_finished(_anim_name: String) -> void:
	collision.disabled = false
	timer.start(0.1)


func on_timeout() -> void:
	kill()
