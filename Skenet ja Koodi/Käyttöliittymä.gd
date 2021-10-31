extends CanvasLayer

onready var _otsikko = $Otsikko
onready var _pisteet = $Pisteet
onready var _pelin_aloitus = $PelinAloitus

signal aloita_peli

func nayta_valikko():
	# Asetetaan otsikko ja nappi näkyviksi
	_otsikko.show()
	_pelin_aloitus.show()

func paivita_pisteet(pisteet: int):
	_pisteet.text = str(pisteet)

func _on_PelinAloitus_pressed():
	# Piilotetaan otsikko ja nappi,
	# ja lähetetään signaali
	_otsikko.hide()
	_pelin_aloitus.hide()
	emit_signal("aloita_peli")
