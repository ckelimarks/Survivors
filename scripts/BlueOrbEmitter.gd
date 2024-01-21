extends Node2D


onready var weapon_nodes = get_node("/root/Main/WeaponManager").weapons
var blue_orb = preload("res://scenes/weapons/BlueOrb.tscn")
var active_orbs = []
#extends Node2D
#
##BlueOrb
#var velocity = Vector2.ZERO
#var rotation_speed = 0.1  # Adjust the rotation speed as needed
#
#var angle = Vector2.ZERO
#var target = Vector2.ZERO 
#var power = 1
#var level = 1
#var hp = 1
#var speed = 100
#var damage =  5
#var knock_amount = 100
#var attack_size = 1.0
#
#
##Attack Nodes
#onready var blueOrbTimer = $BlueOrbTimer
#onready var blueOrbAttackTimer = $BlueOrbTimer/BlueOrbAttackTimer
#
#
#
#var blueOrb_attackspeed = 1
#var blueOrb_ammo = 0
#var blueOrb_baseammo = 1
#var blueOrb_level = 1
#
##Enemy
#
#var enemy_close = []
#
#
func _ready():
	spawn_orb()
	#attack()
#	randomize()
#	velocity.x = [-1, 1][randi() % 2]
#	velocity.y = [-0.8, 0.8][randi() % 2]
#
#	#angle = global_position.direction_to(target)
#	#rotation = angle.angle() + deg2rad(135)
#	match level:
#		1:
#			hp = 1
#			speed = 100
#			damage = 5
#			knock_amount = 100
#			attack_size = 1.0
#
#	# Set the rotation direction based on the initial random choice
#	#rotation_direction = velocity.x
#
func _physics_process(delta):
	pass
#	#position += angle*speed*delta
#
#	var collision_info = move_and_collide(velocity * speed * delta)
#	global_position += velocity
#
#
#func attack():
#	print(0)
#	if blueOrb_level > 0:
#		blueOrbTimer.wait_time = blueOrb_attackspeed
#		if blueOrbTimer.is_stopped():
#			blueOrbTimer.start()
#
#
func spawn_orb():
	for orb in active_orbs:
		orb.queue_free()
		active_orbs.erase(orb)
		weapon_nodes.erase(orb)
	
	var blue_orb_projectile = blue_orb.instance()
	blue_orb_projectile.global_position = Hero.global_position 
	$BlueOrbTimer.connect("timeout", self, "spawn_orb")
	$BlueOrbTimer.start()
	add_child(blue_orb_projectile)
	active_orbs.append(blue_orb_projectile)
	weapon_nodes.append(blue_orb_projectile)
#	blueOrb_ammo += blueOrb_baseammo
#	blueOrbAttackTimer.start() # Replace with function body.
#
#
#func _on_BlueOrbAttackTimer_timeout():
#
#	if blueOrb_ammo > 0:
#		var blueOrb_attack = blueOrb.instance()
#		blueOrb_attack.position = position 
#		blueOrb_attack.target = get_random_target()
#		blueOrb_attack.level = blueOrb_level
#		add_child(blueOrb_attack)
#		blueOrb_ammo -= 1
#		if blueOrb_ammo > 0: 
#			blueOrbAttackTimer.start()  # Fix typo here
#		else:
#			blueOrbAttackTimer.stop()
#
#		#orb_attack.global_position = orb_origin.global_position
#		#blueOrbTimer.wait_time = blueOrb_attackspeed
#
#	if blueOrbTimer.is_stopped():
#		blueOrbTimer.start()
#
#
#
#func get_random_target():
#	if enemy_close.size() > 0:
#		var randomIndex = randi() % enemy_close.size()
#		return enemy_close[randomIndex].global_position
#	else:
#		return Vector2.UP
#
#func _on_EnemyDetection_body_entered(body):
#	if not enemy_close.has(body):
#		enemy_close.append(body)
#
#
#func _on_EnemyDetection_body_exited(body):
#	if enemy_close.has(body):
#		enemy_close.erase(body)
#
##	if collision_info:
##		velocity = velocity.bounce(collision_info.normal)
#
#		# Check if the collision is with the enemy or player paddle
#		#if collision_info.collider.name == "Enemy" or collision_info.collider.name == "Hero":
#			#print("enemy")
#			# Reverse the rotation direction
#			#rotation_direction *= -1
#			#get_node("/root/Level/CollisionSound").play()
#
#	# Rotate the ball
##rotate(rotation_direction * rotation_speed)
#
