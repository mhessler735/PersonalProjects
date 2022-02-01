extends RigidBody2D

signal score_update
var is_destroyed = false
var score_value = 50
var enemy_explosion = load("res://Variant/Asteroid/AsteroidExplosion2.tscn")
var speed = null
var follow


func _ready():
	
	var label = get_tree().get_root().get_node("Asteroids_Stage/UI/Score")
	self.connect("score_update", label, "set_score")
	randomize()
	var path = $CometPaths.get_children()[randi() % $CometPaths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.set_loop(false)

func _increase_Speed():
	global.comet_speed += 50
	print("speed: ", global.comet_speed)
	
func destroy():
	if is_destroyed:
		return
	is_destroyed = true
	
	var asteroid = get_tree().get_nodes_in_group("asteroids")
	for i in asteroid:
		i.get_parent().call_deferred("hit_wall")
	
	var enemy = get_tree().get_nodes_in_group("enemy")
	for i in enemy:
		i.get_parent().call_deferred("destroy")
		
	var explosion = enemy_explosion.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.play()
	emit_signal("score_update", score_value)
	get_parent().remove_child(self)
	queue_free()
	
	
func _process(delta):

	follow.set_offset(follow.get_offset() + global.comet_speed * delta)
	position = follow.global_position
	if follow.get_unit_offset() >= 1:
		queue_free()

	if global.player == null:
		queue_free()
	


	
