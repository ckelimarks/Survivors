extends KinematicBody2D

var speed = 75  # Adjust as needed
var pushing_strength = 10
var HP = 3 # hit points
var power = 1
var distance_to_hero = -1

onready var camera_node = get_node("/root/Main/Camera")
onready var sprite_node = $AnimatedSprite
onready var glow_sprite = sprite_node.get_node("Sprite")
onready var killsound = $AudioStreamPlayer2D
onready var weapon_nodes = get_node("/root/Main/WeaponManager").weapons
#onready var weapon_node2 = Hero.get_node("/root/Main/Hero/BlueOrb")

func _ready():
	sprite_node.connect("animation_finished", self, "_on_animation_finished")
	# No need to connect signals if we're using physics for collision avoidance

func thing():
	print("!")

func _physics_process(delta):
	distance_to_hero = global_position.distance_to(Hero.global_position)
	var gap_vector = Hero.global_position - global_position
	var direction = (gap_vector).normalized()
	var start_position = global_position
	var sprite_start_position = sprite_node.position  # Save the current position before moving
	
	if HP > 0:
		sprite_node.flip_h = gap_vector.x < 0
	
	# First, try to move normally.	
	var push_vector = Vector2(0,0)
	var recoil = Vector2(0,0)
	var collision = move_and_collide(direction * speed * delta)

	if collision:
		if weapon_nodes.has(collision.collider): 
			HP -= collision.collider.power
			recoil = (Hero.global_position - global_position).normalized() * 100
			glow()
			if HP <= 0:
				EnemyManager.enemies.erase(self)
				killsound.play()
				speed = 0
				sprite_node.play("Dead")
				# remove from collision layers
				set_collision_layer_bit(0, false)
				set_collision_mask_bit(0, false)
				set_collision_layer_bit(1, false)
				set_collision_mask_bit(1, false)

			
		# Attempt to push the collider by manually adjusting the enemy's global_position
		push_vector = collision.remainder.normalized() * pushing_strength * delta
	
	var new_position = global_position + push_vector - recoil
	var smoothed_position = (start_position + sprite_start_position).linear_interpolate(new_position, 0.1)
	global_position = new_position
	sprite_node.position = smoothed_position - new_position	
			
			
	self.z_index = int(global_position.y - camera_node.global_position.y)


var exp_gem_scene = preload("res://scenes/ExpGem.tscn")

func glow():
	glow_sprite.visible = true
	yield(get_tree().create_timer(0.2), "timeout")
	glow_sprite.visible = false
	
func _on_animation_finished():
	if sprite_node.get_animation() == "Dead":
		var gem_instance = exp_gem_scene.instance()
		gem_instance.global_position = global_position
		EnemyManager.add_child(gem_instance)
		EnemyManager.enemies.erase(self)
		self.queue_free()
