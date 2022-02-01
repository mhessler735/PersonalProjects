extends "res://Asteroid/Asteroid.gd"

func _ready():
	score_value = 100
	pass

func explode():
	if is_destroyed:
		return
	
	is_destroyed = true
	
	var explosion = asteroid_explosion.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.play()
	
	emit_signal("score_update", score_value)
	
	get_parent().remove_child(self)
	queue_free()
