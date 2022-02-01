extends "res://Wrap_Around/wrap_around.gd"

var asteroid_small = load("res://Asteroid/AsteroidSmall.tscn")
var asteroid_explosion = load("res://Asteroid/AsteroidExplosion.tscn")

#var random = RandomNumberGenerator.new()

signal score_update
var score_value = 50

var is_destroyed = false
var vector_dir = [-1, 1]

func _ready():
	var label = get_tree().get_root().get_node("Asteroids_Stage/UI/Score")
	self.connect("score_update", label, "set_score")
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
	_spawn_asteroid_small(2)
	
	get_parent().remove_child(self)
	queue_free()

func _spawn_asteroid_small(num: int):
	for i in range(num):
		var asteroid_s = asteroid_small.instance()
		asteroid_s.position = self.position
		_randomize_vector(asteroid_s)
		get_parent().add_child(asteroid_s)

func _randomize_vector(asteroid):
	asteroid.angular_velocity = rand_range(-4, 4)
	asteroid.angular_damp = 0
	
	#random.randomize()
	#asteroid.linear_velocity = Vector2(random.randi_range(-1, 1) * 50, random.randi_range(-1, 1) * 100)
	asteroid.linear_velocity = Vector2(vector_dir[randi() % vector_dir.size()] * rand_range(50, 100), vector_dir[randi() % vector_dir.size()] * rand_range(50, 100))
	asteroid.linear_damp = 0
