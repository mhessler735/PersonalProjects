extends "res://Variant/Asteroid/VariantAsteroidLarge.gd"

func _ready():
	score_value = 25

func explode():
	if is_destroyed:
		return
	
	var explosion = asteroid_explosion.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.play()
	
	is_destroyed = true
	emit_signal("score_update", score_value)
	
	get_parent().remove_child(self)
	queue_free()
