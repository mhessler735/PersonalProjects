extends Node2D

var AsteroidSmall  = preload("res://Asteroid/AsteroidSmall.tscn")
var AsteroidMedium = preload("res://Asteroid/AsteroidMedium.tscn")
var AsteroidLarge  = preload("res://Asteroid/AsteroidLarge.tscn")
var Player = preload("res://Player/Player.tscn")
var Enemy = preload("res://Enemy/Enemy.tscn")

onready var ship = get_tree().current_scene.find_node("Player")

export var level = 0
export var safeRadius = 200
export var asteroidsPerLevel = 2
export var maxSpeed = 100
export var minSpeed = 50

func _ready():
	start_next_level()

func _spawn_enemy():
	$EnemyTimer.stop()
	$EnemyTimer.wait_time = rand_range(15, 20)
	$EnemyTimer.start()
	print("Enemy Spawn Time: ", $EnemyTimer.wait_time)
	var e = Enemy.instance()
	add_child(e)
	
func start_next_level():
	global.level += 1

	for i in range(global.level * asteroidsPerLevel + 2):
		spawn_asteroid()

func _process(delta):
	#if $Asteroids.get_child_count() == 0:
	if get_tree().get_nodes_in_group("asteroids").size() == 0:
		start_next_level()
		
func spawn_asteroid():
	randomize()
	#var avoid = ship.position
	#var player = get_tree().current_scene.get_node("Player")
	var pos = global.player.position
	var viewport = get_viewport().get_visible_rect().size
	#for i in range(level * asteroidsPerLevel + 2):
	var child
	match randi() % 3:
		0: child = AsteroidSmall.instance()
		1: child = AsteroidMedium.instance()
		2: child = AsteroidLarge.instance()
	#var spawn = avoid
	var spawn = pos
	while (spawn - pos).length() <= safeRadius:
		spawn.x += rand_range(0, viewport.x)
		spawn.y += rand_range(0, viewport.y)
		child.position = spawn
		
		var angle = randi() * PI * 2
		var speed = rand_range(minSpeed, maxSpeed)
		child.linear_velocity = Vector2(speed, 0).rotated(angle)
	
	$Asteroids.add_child(child)



func _on_Timer_timeout():
	var viewport = get_viewport().get_visible_rect().size
	var newPlayer
	newPlayer = Player.instance()
	get_tree().current_scene.add_child(newPlayer)

func _on_EnemyTimer_timeout():
	print("enemy timeout")
	_spawn_enemy()
	#print("enemy added")
	$EnemyTimer.wait_time = rand_range(10, 15)


func _on_GameOverTimer_timeout():
	#play gameover music
	var game_over_label = get_tree().current_scene.get_node("GameOverLabel")
	game_over_label.visible = true


func _on_DefeatSound_finished():
	$GameOverBGM.play()
	pass # Replace with function body.
