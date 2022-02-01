extends "res://Asteroid/Asteroid.gd"

var asteroid_medium = load("res://Asteroid/AsteroidMedium.tscn")

func _ready():
	score_value = 20
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
	_spawn_asteroid_medium(2)
	
	get_parent().remove_child(self)
	queue_free()

func _spawn_asteroid_medium(num: int):
	for i in range(num):
		var asteroid_m = asteroid_medium.instance()
		asteroid_m.position = self.position
		_randomize_vector(asteroid_m)
		get_parent().add_child(asteroid_m)

#func _randomize_vector(asteroid):
#	asteroid.angular_velocity = rand_range(-4, 4)
#	asteroid.angular_damp = 0
#
#	random.randomize()
#	asteroid.linear_velocity = Vector2(random.randi_range(-1, 1) * 50, random.randi_range(-1, 1) * 100)
#	asteroid.linear_damp = 0

