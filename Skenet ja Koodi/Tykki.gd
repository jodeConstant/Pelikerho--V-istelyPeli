extends Node2D

export (PackedScene) var vihollinen

export var min_nopeus: float = 270
export var max_nopeus: float = 310

# Luodaan uusi vihollinen
func laukaus():
	var uusi_vihollinen = vihollinen.instance()
	get_tree().current_scene.add_child(uusi_vihollinen)
	uusi_vihollinen.position = position
	uusi_vihollinen.rotation = rotation
	uusi_vihollinen.nopeus = rand_range(min_nopeus, max_nopeus)

func laukaus_kohti(var kohde: Vector2):
	look_at(kohde)
	laukaus()
	

func _on_Timer_timeout():
	laukaus()
