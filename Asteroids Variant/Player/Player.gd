extends RigidBody2D #"res://Wrap_Around/wrap_around.gd"

var Laser = preload("res://Laser/Laser.tscn")
var player_explosion = preload("res://Player/ShipExplosion.tscn")

onready var ui = get_tree().current_scene.get_node("UI")
onready var shooting_sound = get_node("ShootingSound")

export(float) var engine_thrust = 350
export(float) var spin_thrust = 2.6 #2000
export(float) var laser_speed = 300
export(float) var recharge_time = .2
export(float) var acc = 0.08
export(float) var dec = 0.04

var thrust = Vector2.ZERO
var rotate = 0
var recharge_timer = 0
var screen_size = Vector2()
var pos = Vector2()
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():	
	global.player = self
	
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	set_position(pos)
	set_process(true)
	pass


func _exit_tree():
	global.player = null
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_pressed("ui_up"):
	#	thrust = Vector2(0, -engine_thrust)
	#	$AnimationPlayer.play("movement")
	#else:
	#	thrust = Vector2.ZERO
	#	$AnimationPlayer.play("idle")
	
	#if Input.is_action_pressed("ui_left"):
	#	rotate = -1
	#elif Input.is_action_pressed("ui_right"):
	#	rotate = 1
	#else:
	#	rotate = 0	
	
	if Input.is_action_pressed("ui_left"):
		rotate -= spin_thrust * delta
	elif Input.is_action_pressed("ui_right"):
		rotate += spin_thrust * delta
		
	if Input.is_action_just_pressed("ui_down"):
		pos.x = rand_range(0, screen_size.x)
		pos.y = rand_range(0, screen_size.y)
		set_position(pos)

	if Input.is_action_pressed("ui_up"):
		thrust = Vector2(0, -1).rotated(rotate)
		velocity = velocity.linear_interpolate(thrust, acc)
		$AnimationPlayer.play("movement")
	else:
		thrust = Vector2.ZERO
		velocity = velocity.linear_interpolate(thrust, dec)
		$AnimationPlayer.play("idle")

	pos += velocity * engine_thrust * delta

	if pos.x > screen_size.x:
		pos.x = 0
	elif pos.x < 0:
		pos.x = screen_size.x
	if pos.y > screen_size.y:
		pos.y = 0
	elif pos.y < 0:
		pos.y = screen_size.y

	set_position(pos)
	set_rotation(rotate)
	
	if Input.is_action_pressed("ui_accept"):
		if recharge_timer <= 0:
			var offset = Vector2(-3.5, -40)
			var laser = Laser.instance()
			laser.position = position + offset.rotated(rotation)
			laser.rotation = rotation
			laser.linear_velocity = linear_velocity + Vector2(0, -laser_speed).rotated(rotation)
			get_parent().add_child(laser)
			recharge_timer = recharge_time
			shooting_sound.play()
		else:
			recharge_timer -= delta
			
	
#func _integrate_forces(state):	
#	set_applied_force(thrust.rotated(rotation))
#	set_applied_torque(rotate * spin_thrust)
#	._integrate_forces(state)


func _on_Area2D_area_entered(area):
	if (area.is_in_group("asteroids") || area.is_in_group("enemy") || area.is_in_group("enemylaser")):
		explode()

func explode():
	#var explosion = player_exlosion_scene.instance()
	var explosion = player_explosion.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.play()
	ui.decrease_health()
	queue_free()
	var health = ui.get_health()
	if (health <= 0):
		#stop music
		var game1_bgm = get_tree().current_scene.get_node("Game1BGM")
		game1_bgm.stop()
		var defeat_sound = get_tree().current_scene.get_node("Asteroids_Level/DefeatSound")
		defeat_sound.play()
		var enemy_timer = get_tree().current_scene.get_node("Asteroids_Level/EnemyTimer")
		enemy_timer.stop()
		var game_over_timer = get_tree().current_scene.get_node("GameOverTimer")
		game_over_timer.start()
		return
	var timer = get_tree().current_scene.get_node("Timer")
	timer.start()



