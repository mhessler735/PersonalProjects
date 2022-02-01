extends RigidBody2D

onready var viewport = get_viewport().get_visible_rect()
#var direction : Vector2 = Vector2.LEFT
var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var speed = 5
var velocity = Vector2()

func _ready():
	look_vec = global.player.position - global_position

func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move
	
	
#func _process(delta):
#	if not viewport.has_point(position):
#		queue_free()

func _on_Area2D_area_entered(area):
	if (area.is_in_group("asteroids")):
		area.get_parent().call_deferred("explode")
		# get_parent().remove_child(self)
		area.call_deferred("queue_free")
		queue_free()
	

