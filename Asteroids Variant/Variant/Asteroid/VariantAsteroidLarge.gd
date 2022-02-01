extends RigidBody2D

onready var viewport = get_viewport().get_visible_rect().size

var asteroidMedium = load("res://Variant/Asteroid/AsteroidMedium.tscn")
var asteroid_explosion = load("res://Variant/Asteroid/AsteroidExplosion2.tscn")

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var speed = 1
var velocity = Vector2()
var is_destroyed = false
var vector_dir = [-1, 1]

signal score_update
var score_value = 50

func _ready():
	look_vec = Vector2(viewport.x/2, viewport.y/2) - position
	var label = get_tree().get_root().get_node("Variant_Stage/UI/VariantScore")
	self.connect("score_update", label, "set_score")
	pass

func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move

	if position.distance_to(viewport/2) < 10:
		queue_free()
		
func explode():
	if is_destroyed:
		return
	
	is_destroyed = true
	
	var explosion = asteroid_explosion.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.play()
	
	emit_signal("score_update", score_value)
	var offset1 = Vector2(0, 25)
	var offset2 = Vector2(0, -25)
	_spawn_asteroid_medium(offset1)
	_spawn_asteroid_medium(offset2)
	
	get_parent().remove_child(self)
	queue_free()
	
func _spawn_asteroid_medium(offset):
	var asteroid = asteroidMedium.instance()
	asteroid.position = self.position + offset
	get_parent().add_child(asteroid)
	
func hit_wall():
	if is_destroyed:
		return
	
	is_destroyed = true
	
	var explosion = asteroid_explosion.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.play()
	
	get_parent().remove_child(self)
	queue_free()
