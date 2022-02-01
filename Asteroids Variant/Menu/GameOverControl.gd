extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	global.shield_1_Health = 3
	global.shield_2_Health = 3 
	global.shield_3_Health = 3 
	global.shield_4_Health = 3 
	global.space_station_Health = 5
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Replay_pressed():
	get_tree().reload_current_scene()


func _on_Menu_pressed():
	get_tree().change_scene("res://Menu/Menu.tscn")


func _on_Quit_pressed():
	get_tree().quit()
