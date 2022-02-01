extends Control

onready var healthNode = get_node("Health")

func increase_health():
	healthNode.health += 1
	pass
	
func decrease_health():
	healthNode.health -= 1

	if healthNode.health <= 0:
		global.level = 0
	pass
	
func get_health():
	return healthNode.health
