extends KinematicBody2D

export var nopeus: float = 250.0

export var poistetaan_kun_poistuu_ruudulta: bool = true
onready var _nakyvyyden_tarkastus = $VisibilityNotifier2D

func _process(delta):
	# Siirretään vihollisen omaa x-akselia pitkin
	#	Tämä suunta riippuu siitä miten vihollista
	#	on käännetty
	move_local_x(nopeus * delta)
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
