extends Node2D

# Ajastin, laskee vaikka 1:stä
# nollaan ja lisää pisteen
onready var _piste_laskuri = $PisteLaskuri
onready var _vihollisten_asettaja = $VihollistenAsettaja

onready var pisteet: int = 0

signal pisteiden_paivitys(pisteet)

func uusi_peli():
	pisteet = 0
	emit_signal("pisteiden_paivitys", pisteet)
	_piste_laskuri.start(1)
	
func lopeta_peli():
	_piste_laskuri.stop()
	# Poistetaan kaikki ryhmässä "viholliset"
	get_tree().call_group("viholliset", "queue_free")

func _ready():
	randomize()

# Lisätään piste tietyin aikavälein
func _on_PisteLaskuri_timeout():
	pisteet += 1
	emit_signal("pisteiden_paivitys", pisteet)
