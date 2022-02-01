extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$SoundControl.value = AudioServer.get_bus_volume_db((AudioServer.get_bus_index("Master")))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Asteroids_pressed():
	get_tree().change_scene("res://Asteroids_Stage/Asteroids_Stage.tscn")

func _on_Game2_pressed():
	get_tree().change_scene("res://Variant/Variant_Stage/Variant_Stage.tscn")

func _on_Quit_pressed():
	get_tree().quit()



func _on_SoundControl_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
