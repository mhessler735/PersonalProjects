extends RigidBody2D

signal score_update

var is_destroyed = false
var score_value = 100
var Laser = preload("res://Laser/EnemyLaser.tscn")
var enemy_explosion = preload("res://Enemy/EnemyShipExplosion.tscn")
var speed = 200
var follow
onready var enemy_shooting_sound = $"Enemy Shooting Sound"

func _ready():
	
	$ShootTimer.set_wait_time(0.8)
	var label = get_tree().get_root().get_node("Asteroids_Stage/UI/Score")
	self.connect("score_update", label, "set_score")
	randomize()
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.set_loop(false)
	$ShootTimer.start()
	
func destroy():
	if is_destroyed:
		return
	is_destroyed = true
	var explosion = enemy_explosion.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.play()
	emit_signal("score_update", score_value)
	get_parent().remove_child(self)
	queue_free()
	
	
func _process(delta):

	follow.set_offset(follow.get_offset() + speed * delta)
	position = follow.global_position
	if follow.get_unit_offset() >= 1:
		queue_free()

	if global.player == null:
		queue_free()
	
func _on_ShootTimer_timeout():
	if global.player != null:
		shoot1()
	#	pass	
func shoot1():
	var laser = Laser.instance() 
	laser.position = position
	laser.player = global.player
	enemy_shooting_sound.play()
	get_parent().add_child(laser)
	

