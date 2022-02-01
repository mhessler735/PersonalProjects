tool
extends GridContainer

var Life = preload("res://UI/Lives.tscn")

export var health = 3 setget set_health

func _ready():
	set_health(health)
	
func set_health(newHealth):
	if get_child_count() < newHealth:
		for i in range(get_child_count(), newHealth):
			var child = Life.instance()
			add_child(child)
			
	elif get_child_count() > newHealth:
		for i in range(newHealth, get_child_count()):
			var child = get_child(newHealth)
			remove_child(child)
			
			
	health = newHealth
