extends RigidBody2D

onready var viewport = get_viewport().get_visible_rect()
var direction : Vector2 = Vector2.LEFT

func _ready():
	pass 

func _process(delta):
	if not viewport.has_point(position):
		queue_free()

func _on_Area2D_area_entered(area):
	print("Entered area")
	if (area.is_in_group("asteroids")):
		area.get_parent().call_deferred("explode")
		#area.call_deferred("queue_free")
		queue_free()
	
	if (area.is_in_group("enemy")):
		area.get_parent().call_deferred("destroy")
		#get_parent().remove_child(self)
		area.call_deferred("queue_free")
		queue_free()

	if (area.is_in_group("comets")):
		global.camera.shake(500, 1.5, 500)
		area.get_parent().call_deferred("destroy")
		#get_parent().remove_child(self)
		area.call_deferred("queue_free")
		queue_free()
