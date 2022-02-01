extends Control

onready var healthNode = get_tree().current_scene.get_node("Health")

export(int) var max_hp = 3
#export(int) var hp1 = 3
var hp1 = 3
export(int) var hp2 = 3
export(int) var hp3 = 3
export(int) var hp4 = 3
var amount = 1
#func damage(wall):
#	if wall == "ShieldWall 1":
#		hp1 -= 1
#		$"Wall 1".value = hp1
#	elif wall == "ShieldWall 2":
#		hp1 -= 1
#		$"Wall 2".value = hp2
#	elif wall == "ShieldWall 3":
#		hp1 -= 1
#		$"Wall 3".value = hp3
#	elif wall == "ShieldWall 4":
#		hp1 -= 1
#		$"Wall 4".value = hp4
#
#	if hp1 == 0:
#		wall1.queue_free()
#	if hp2 == 0:
#		$"ShieldWall 2".queue_free()
#	if hp3 == 0:
#		$"ShieldWall 3".queue_free()
#	if hp4 == 0:
#		$"ShieldWall 4".queue_free()

	
func healthBar1():
	$"Wall 1".value -=1

func healthBar2():
	$"Wall 2".value -=1

func healthBar3():
	$"Wall 3".value -=1
	
func healthBar4():
	$"Wall 4".value -=1
	
func coreHealthBar():
	$Station.value -=1
