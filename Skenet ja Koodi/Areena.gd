extends Area2D

# Ainoa Area2D -tyyppinen olio tässä pelissä on pelaaja
func _on_Areena_area_exited(area):
	# Palautetaan pelaaja keskelle jos yritetään poistua
	area.position = position


# Kaikki PhysicsBody2D oliot tässä pelissä ovat vihollisia
func _on_Areena_body_exited(body):
	# Poistetaan viholliset kun ne poistuvat alueelta
	body.queue_free()
