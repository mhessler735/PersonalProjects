extends RigidBody2D

var Laser = preload("res://Variant/Laser2/Laser2.tscn")

export(float) var spin_thrust = 3
export(float) var laser_speed = 200
export(float) var recharge_time = .4
var rotate = 0
var recharge_timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	global.player = self
	pass # Replace with function body.

func _process(delta):

	if Input.is_action_pressed("ui_left"):
		rotate -= spin_thrust * delta
	elif Input.is_action_pressed("ui_right"):
		rotate += spin_thrust * delta
	
	set_rotation(rotate)
	
	if Input.is_action_pressed("ui_accept"):
		if recharge_timer <= 0:
			var offset = Vector2(15, -40)
			var laser = Laser.instance()
			laser.position = position + offset.rotated(rotation)
			laser.rotation = rotation
			laser.linear_velocity = linear_velocity + Vector2(0, -laser_speed).rotated(rotation)
			get_parent().add_child(laser)
			recharge_timer = recharge_time
			$ShootingSound.play()
		else:
			recharge_timer -= delta

func _exit_tree():
	global.player = null
	pass
