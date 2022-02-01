extends Area2D

onready var ui = get_tree().current_scene.get_node("UI")
var wall_explosion = preload("res://Variant/ShieldWallExplosion.tscn")

func explode(wall):
	queue_free()

func take_damage(wall):
	global.shield_3_Health -= global.asteroid_collision_damage
	ui.healthBar3()
	pass

func _on_Area2D_area_entered(area):
	if (area.is_in_group("asteroids") || area.is_in_group("enemy") || area.is_in_group("enemylaser")):
		area.get_parent().call_deferred("hit_wall")
		var wall = self.name
		global.camera.shake(100)
		if(global.shield_3_Health > 1):
			take_damage(wall)
			#area.get_parent().call_deferred("take_damage")
		else:
			take_damage(wall)
			var explosion = wall_explosion.instance()
			explosion.position = self.position
			get_parent().add_child(explosion)
			explosion.play()
			explode(wall)

		#ui.take_damage(global.asteroid_collision_damage)
