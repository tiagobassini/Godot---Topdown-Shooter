extends CanvasLayer
class_name Interface


onready var current_weapon: Label = $CurrentWeapon
onready var ammo: Label = $Ammo

func set_weapon_text(text:String)->void:
	current_weapon.text = "Current Weapon: "+text

func set_weapon_ammo(current_ammo:int, max_ammo:int )->void:
	ammo.text = "Ammo: "+str(current_ammo)+"/"+str(max_ammo)


func reload_game()->void:
	var _reload = get_tree().change_scene("res://scenes/management/game_level.tscn")

