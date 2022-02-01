extends Node2D

var AsteroidLarge  = load("res://Variant/Asteroid/AsteroidLarge.tscn")
var Enemy = preload("res://Variant/Enemy2/Enemy2.tscn")
var Comet = preload("res://Variant/Comet/Comet.tscn")

export(float) var spawn_interval = 5
export(float) var difficulty_index = 0.9
var game_over = false
#export(float) var difficulty_ramp = 0.5

func _ready():
	_spawn_asteroid()
	#_spawn_enemy()

func _spawn_comet():
	$CometTimer.stop()
	$CometTimer.wait_time = rand_range(20, 40)
	$CometTimer.start()
	print("Enemy Spawn Time: ", $CometTimer.wait_time)
	var c = Comet.instance()
	c.call_deferred("_increase_Speed")
	add_child(c)
	
func _spawn_enemy():
	$EnemyTimer.stop()
	$EnemyTimer.wait_time = rand_range(20, 40)
	$EnemyTimer.start()
	print("Enemy Spawn Time: ", $EnemyTimer.wait_time)
	var e = Enemy.instance()
	add_child(e)
	
func _spawn_asteroid():
	var asteroid = AsteroidLarge.instance()
	
	_set_position(asteroid)
	
	add_child(asteroid)
	
func _set_position(asteroid):
	var screen = get_viewport().get_visible_rect().size
	match randi() % 2:
		0: asteroid.position = Vector2(-25, rand_range(0, screen.y))
		1: asteroid.position = Vector2(screen.x + 25, rand_range(0, screen.y))

func _on_SpawnTimer_timeout():
	_spawn_asteroid()
	print("Spawner timeout")


func _on_DifficultyTimer_timeout():
	print("Difficulty timeout")
	$SpawnTimer.wait_time = spawn_interval * difficulty_index
	spawn_interval = $SpawnTimer.wait_time
	#difficulty_index -= difficulty_ramp
	if spawn_interval <= 1.5:
		$SpawnTimer.wait_time = 1.5
		spawn_interval = 1.5
	print("New spawn time = ", $SpawnTimer.wait_time)


func _on_GameOverTimer_timeout():
	var game_over_label = get_tree().current_scene.get_node("GameOverLabel")
	game_over_label.visible = true
	game_over = true
	$EnemyTimer.stop()
	pass # Replace with function body.


func _on_DefeatSound_finished():
	$GameOverBGM.play()
	pass # Replace with function body.


		
func _on_EnemyTimer_timeout():
	if game_over == false:
		print("enemy timeout")
		_spawn_enemy()
		#print("enemy added")
		$EnemyTimer.wait_time = rand_range(10, 15)
	else:
		queue_free()


func _on_CometTimer_timeout():
		if game_over == false:

			_spawn_comet()
			#print("enemy added")
			$CometTimer.wait_time = rand_range(10, 15)
		else:
			queue_free()
		
