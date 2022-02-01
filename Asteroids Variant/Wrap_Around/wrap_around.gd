extends RigidBody2D

#onready var sprite = get_node("Sprite")
onready var viewport = get_viewport().get_visible_rect().size

func _integrate_forces(state):
	#var size = sprite.texture.get_size() * sprite.scale
	var trans = state.get_transform()
#	if trans.origin.x < -size.x / 2:
#		trans.origin.x += viewport.x + size.x
#	elif trans.origin.x > viewport.x + size.x / 2:
#		trans.origin.x -= viewport.x + size.x
#	elif trans.origin.y < -size.y / 2:
#		trans.origin.y += viewport.y + size.y
#	elif trans.origin.y > viewport.y + size.y / 2:
#		trans.origin.y -= viewport.y + size.y
	if trans.origin.x < 0:
		trans.origin.x = viewport.x
	elif trans.origin.x > viewport.x:
		trans.origin.x = 0
	elif trans.origin.y < 0:
		trans.origin.y = viewport.y
	elif trans.origin.y > viewport.y:
		trans.origin.y = 0
		
	state.set_transform(trans)
