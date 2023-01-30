extends HitboxArea
class_name EnemyHitBox


const DEATH_EFFECT:PackedScene = preload("res://scenes/effects/death_effect.tscn")

func on_hitbox_body_entered(_body):
	pass

func on_hitbox_area_entered(area)->void:
	
	if area.name == "HitboxArea":
		return
	
	area.kill()
	update_health(area.damage, "decrease")

func update_health(damage:int, _type:String)->void:
	health -= damage
	health_bar.update_value(health)
	
	if health <=0:
		spawn_effect()
		get_parent().kill()
		
	
	
func spawn_effect()->void:
	var effect = DEATH_EFFECT.instance()
	effect.global_position = global_position
	get_tree().root.call_deferred("add_child",effect)
