extends KinematicBody2D

var speed = 200
var pushing_strength = 300  # Adjust the pushing effect as needed


onready var sprite_node = $Sprite
onready var weapon_node = $Weapon1
onready var camera_node = get_node("/root/Main/Camera")

#Attack Nodes
onready var blueOrbTimer = get_node("%BlueOrbTimer")
onready var blueOrbAttackTimer = get_node("%BlueOrbAttackTimer")

#BlueOrb
#export (PackedScene) var BlueOrb
#onready var orb_origin = $OrbOrigin
var blueOrb = preload("res://scenes/weapons/BlueOrb.tscn")
var blueOrb_attackspeed = 1.5
var blueOrb_ammo = 0
var blueOrb_baseammo = 1
var blueOrb_level = 1

#Enemy

var enemy_close = []

var sprite_offset = Vector2()


func _ready():
	attack()
	
	sprite_offset = sprite_node.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var start_position = global_position  # Save the current position before moving
	var sprite_start_position = sprite_node.position
	var velocity = Vector2() # The player's movement vector

	# Get input from the player
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
		$Sprite.flip_h = true
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
		$Sprite.flip_h = false
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	#if Input.is_action_pressed('ui_accept'):	
		#shoot()

	# Move the player
	# First, try to move normally.
	var collision = move_and_collide(velocity.normalized() * speed * delta)
	if collision:
		if true or collision.collider.is_in_group("pushable"):  # Check if the collider can be pushed
			# Attempt to push the collider by manually adjusting the hero's global_position
			var push_vector = collision.remainder.normalized() * pushing_strength * delta
			var new_position = global_position + push_vector
			var smoothed_position = (start_position + sprite_start_position).linear_interpolate(new_position + sprite_offset, 0.1)
			global_position = new_position
			sprite_node.position = smoothed_position - new_position
	
	self.z_index = int(global_position.y - camera_node.global_position.y)
	#print(self.z_index)
	
func attack():
	if blueOrb_level > 0:
		blueOrbTimer.wait_time = blueOrb_attackspeed
		if blueOrbTimer.is_stopped():
			blueOrbTimer.start()


func _on_BlueOrbTimer_timeout():
	blueOrb_ammo += blueOrb_baseammo
	blueOrbAttackTimer.start() # Replace with function body.


func _on_BlueOrbAttackTimer_timeout():
	if blueOrb_ammo > 0:
		var blueOrb_attack = blueOrb.instance()
		blueOrb_attack.position = position 
		blueOrb_attack.target = get_random_target()
		blueOrb_attack.level = blueOrb_level
		add_child(blueOrb_attack)
		blueOrb_ammo -= 1
		if blueOrb_ammo > 0: 
			blueOrbAttackTimer.start()  # Fix typo here
		else:
			blueOrbAttackTimer.stop()
		
		#orb_attack.global_position = orb_origin.global_position
		#blueOrbTimer.wait_time = blueOrb_attackspeed
	
	if blueOrbTimer.is_stopped():
		blueOrbTimer.start()
		
		

func get_random_target():
	if enemy_close.size() > 0:
		var randomIndex = randi() % enemy_close.size()
		return enemy_close[randomIndex].global_position
	else:
		return Vector2.UP

func _on_EnemyDetection_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_EnemyDetection_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
