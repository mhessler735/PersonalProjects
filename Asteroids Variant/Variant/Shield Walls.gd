extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (global.space_station_Health == 0):
		game_over()
		set_process(false)


func game_over():
	var enemy_timer = get_tree().current_scene.get_node("Variant_Level/SpawnTimer")
	enemy_timer.stop()
	var difficulty_timer = get_tree().current_scene.get_node("Variant_Level/DifficultyTimer")
	difficulty_timer.stop()
	var game2_bgm = get_tree().current_scene.get_node("Game2BGM")
	game2_bgm.stop()
	var defeat_sound = get_tree().current_scene.get_node("Variant_Level/DefeatSound")
	defeat_sound.play()
	var game_over_timer = get_tree().current_scene.get_node("GameOverTimer")
	game_over_timer.start()
	print("GameOverTimer starts")
