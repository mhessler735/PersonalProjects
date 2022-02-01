extends RigidBody2D

var wall_explosion = preload("res://Variant/Asteroid/AsteroidExplosion2.tscn")
onready var viewport = get_viewport().get_visible_rect()
#var direction : Vector2 = Vector2.LEFT
var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var speed = 5
var velocity = Vector2()
var is_destroyed = false

func _ready():
	look_vec = global.player.position - global_position

func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move
	
func hit_wall():
	if is_destroyed:
		return
	
#func _process(delta):
#	if not viewport.has_point(position):
#		queue_free()

func _on_Area2D_area_entered(area):
	if (area.is_in_group("asteroids")):
		area.get_parent().call_deferred("explode")
		# get_parent().remove_child(self)
		area.call_deferred("queue_free")
		queue_free()
	if (area.is_in_group("shield") || area.is_in_group("station")):
		var explosion = wall_explosion.instance()
		explosion.position = self.position
		get_parent().add_child(explosion)
		explosion.play()
		queue_free()
