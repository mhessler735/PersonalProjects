extends Node

var camera = null
var node_creation_parent = null
var player = null
var station = null
var shield_1 = null
var enemy_health = 30
var enemy_bullet_damage = 25
var enemy_speed = 175
var enemy_points = 100
var level = 0
var comet_speed = 200
var screensize = Vector2()

var asteroid_collision_damage = 1
var shield_1_Health = 3
var shield_2_Health = 3
var shield_3_Health = 3
var shield_4_Health = 3
var space_station_Health = 5

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

#extends Node


# enemy settings
