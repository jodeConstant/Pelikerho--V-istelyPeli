extends Area2D

# Tässä luodaan muuttujia Pelaaja -luokalle
#	Avainsanojen merkityksiä:
#	avainsana:	selitys:
#	var			Yleinen muuttujan tyyppi, johon voi tallentaa erilaista tietoa
#	export		Tekee muuttujan näkyväksi editorissa 2D ja 3D näkymissä oikealla
#				tarkastelu-osiossa ja sallii sen muuttamisen jokaisessa skriptin
#				omistavassa solmussa erikseen. Kirjoitetaan ennen muita avainsanoja.
#	onready		Näisen muuttujien arvot asetetaan vasta kun kutsutaan funktio _ready()
#	float		Desimaaliluku; voidaan tarvittaessa asettaa muuttujalle tietty tyyppi,
#				jolloin siihen voi tallentaa vain tietytyyppistä tietoa. Esimerkiksi
#				tässä muuttujassa nopeus ei pitäisi olla mitään muuta kuin luku

export var nopeus: float = 250.0

export var elossa: bool = true

# Alaviiva nimen edessä merkitsee että tämä muuttuja on sisäinen,
# eli siihen ei pidä koskea tämän luokan ulkopuolelta
onready var _animaatio = $AnimatedSprite
#onready var _animaatio = get_node("AnimatedSprite")
# $ -merkki lyhenne funtiolle get_node()
# $AnimatedSprite 	on sama kuin	get_node("AnimatedSprite")

var _suunta_vektori: Vector2

export var paikan_rajoitus: bool = true
export var raja_vasemmalla: float = 0
export var raja_oikealla: float = 1024
export var raja_ylhaalla: float = 0
export var raja_alhaalla: float = 600

signal hit


func _physics_process(delta):
	# Nollataan aluksi _suunta_vektori
	_suunta_vektori = Vector2(0,0)
	# TAI:
	#_suunta_vektori = Vector2.ZERO
	
	# get_action_strength() -funktio palauttaa arvon 0 ja 1 välillä,
	# näppäimistöllä 1 jos painetaan, 0 jos ei
	
	# Vaakasuunta:
	#	Lisätään 1 jos halutaan mennä oikealle, vähennetään 1 jos vasemmalle
	_suunta_vektori.x += Input.get_action_strength("ui_right")
	_suunta_vektori.x -= Input.get_action_strength("ui_left")
	
	# Pystysuunta:
	#	Lisätään 1 jos halutaan mennä alas, vähennetään 1 jos ylös
	_suunta_vektori.y += Input.get_action_strength("ui_down")
	_suunta_vektori.y -= Input.get_action_strength("ui_up")
	
	# Lopuksi varmistetaan että vektorin pituus on 1 myös silloin kun
	# se on viistossa, esimerkiksi alas ja oikealle.
	# normalized() -funktio palauttaa vektorin joka osoittaa samaan
	# suuntaan kuin vektori josta suoritetaan, mutta pituus on 1
	_suunta_vektori = _suunta_vektori.normalized()
	
	# Kun pelaajan ohjaus/syöte on käsitelty, siirretään pelaajaa muuttamalla
	# sijaintia. Muuttuja 'delta' on edellisestä päivityksestä kulunut aika.
	# 	Kun kerrotaan nopeus kuluneella ajalla saadaan kuljettu matka.
	# 	Kun kerrotaan suuntavektorin molemmat luvut (komponentit) saadaan
	# 	matkat vaaka- ja pystysuunnassa.
	# Liikutetaan vain jos elossa
	if elossa:
		position += nopeus * delta * _suunta_vektori
	
	# Käännetään pelaaja oikeaan suuntaan:
	look_at(position + _suunta_vektori)
	
	# Jos paikkaa rajoitetaan tarkistetaan se tässä:
	if paikan_rajoitus:
		# clamp(arvo, alaraja, yläraja) rajoittaa arvon
		# alarajan ja ylärajan välille: jos se on liian pieni,
		# palautetaan alaraja, jos liian suuri, yläraja
		position.x = clamp(position.x, raja_vasemmalla, raja_oikealla)
		position.y = clamp(position.y, raja_ylhaalla, raja_alhaalla)
	
	
	# Asetetaan animaatio tässä
	#	Voidaan vaihtaa animaatioita pelaajan suunnasta
	#	riippuen, tai kääntää hahmoa haluttuun suuntaan
	
	# Jos liikutaan:
	if _suunta_vektori != Vector2.ZERO:
		# Asetetaan oikea animaatio nimellä
		_animaatio.animation = "liikkuu"
	# Muuten:
	else:
		_animaatio.animation = "paikalla"

# Kutsutaan kun pelaaja saa osuman tai poistuu alueelta
func piilota():
	# Piilotetaan pelaaja
	hide()
	# Lähetetään signaali nimeltä 'hit', joka luotiin tässä skriptissä
	emit_signal("hit")
	# Asetetaan muuttujan nimeltä 'disabled' arvoksi true, mutta
	# vasta kun tärkeät laskelmat tämän päivityksen aikana on tehty:
	$CollisionShape2D.set_deferred("disabled", true)
	elossa = false

func palauta():
	show()
	$CollisionShape2D.disabled = false
	elossa = true

func _on_Pelaaja_body_entered(body):
	piilota()

func _on_Pelaaja_area_exited(area):
	piilota()
