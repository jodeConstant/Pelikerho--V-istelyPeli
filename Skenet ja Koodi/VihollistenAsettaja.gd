extends Path2D

export (PackedScene) var vihollinen
# Vaihtoehtoisesti:
#var vihollinen = preload("res://Skenet ja Koodi/Vihollinen.tscn")

export var min_tauko: float = 0.3
export var max_tauko: float = 1

export var min_nopeus: float = 150.0
export var max_nopeus: float = 250.0

export var suunta_aste_vaihtelu: float = 36

# Timer -solmu on ajastin, jolle voi antaa tarvittavan ajan:
# se ilmoittaa kun aika on kulunut loppuun
onready var _ajastin = $Timer
onready var _paikantaja = $PathFollow2D

func _luo_vihollinen():
	# Luodaan uusi 'Vihollinen' skene
	#	Tämä ei vielä lisää skeneä peliin,
	#	vaan ainoastaan luo uuden olion muistiin
	var uusi_vihollinen = vihollinen.instance()
	# Valitaan satunnainen kohta käyrällä:
	_paikantaja.unit_offset = rand_range(0,1)
	
	# _paikantaja:a (PathFollow2D) kääntyy
	# sen mukaan missä se on käyrällä
	# Vihollisen sopiva kulma saadaan kiertämällä
	# 90 astetta _paikantaja:n kulmasta.
	#	Lisätään lopuksi vielä satunnainen kierto
	#	sopivissa rajoissa
	var kierto = (_paikantaja.rotation_degrees
		+ 90
		+ rand_range(-suunta_aste_vaihtelu,
		suunta_aste_vaihtelu))
	# HUOM! 90 asteen lisäys JOS käyrän pisteet lisätään
	# myötäpäivään, eli käyrä kääntyy (pääosin) oikealle.
	# Muuten pitää vähentää 90 astetta
	
	# Asetetaan vihollisen suunta ja paikka:
	uusi_vihollinen.rotation_degrees = kierto
	uusi_vihollinen.global_position = _paikantaja.global_position
	# Asetetaan nopeus satunnaisesti valitulta väliltä:
	uusi_vihollinen.nopeus = rand_range(min_nopeus, max_nopeus)
	# Lisätään luotu ja säädetty skene peliin:
	#	get_tree().current_scene on käynnissä oleva skene;
	#	add_child() suluissa olevan skenen siihen skeneen,
	#	josta funktio on kutsuttu
	get_tree().current_scene.add_child(uusi_vihollinen)

func aloita():
	_ajastin.paused = false
	_ajastin.start(rand_range(min_tauko, max_tauko))
	
func lopeta():
	_ajastin.paused = true
	_ajastin.stop()

func _ready():
		# Valmistellaan satunnaislukujen tuottaminen
		#randomize()
	# Aloitetaan lähtölaskenta; kun aika on kulunut loppuun
	# ajastin lähettää signaalin 'timeout', joka yhdistetään
	# alla olevaan funktioon
	#	rand_range palauttaa satunnaisen luvun kahden luvun väliltä
		#_ajastin.start(rand_range(min_tauko, max_tauko))
	pass

# Tämä funktio ottaa vastaan ajastimen 'timeout' -signaalin
func _on_Timer_timeout():
	_luo_vihollinen()
	_ajastin.start(rand_range(min_tauko, max_tauko))
