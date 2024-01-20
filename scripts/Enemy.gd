extends KinematicBody2D

var speed = 75  # Adjust as needed
var pushing_strength = 10
var HP = 3 # hit points


onready var camera_node = get_node("/root/Main/Camera")
onready var sprite_node = $AnimatedSprite
onready var glow_sprite = sprite_node.get_node("Sprite")
onready var killsound = $AudioStreamPlayer2D
onready var weapon_node = Hero.get_node("Weapons")

func _ready():
	sprite_node.connect("animation_finished", self, "_on_animation_finished")
	# No need to connect signals if we're using physics for collision avoidance


func _physics_process(delta):
	var gap_vector = Hero.global_position - global_position
	var direction = (gap_vector).normalized()
	var start_position = global_position
	var sprite_start_position = sprite_node.position  # Save the current position before moving
	sprite_node.flip_h = gap_vector.x < 0
	
	#scale.x = abs(sprite_node.scale.x) * sign(gap_vector.x)	
	
	# First, try to move normally.
	var push_vector = Vector2(0,0)
	var recoil = Vector2(0,0)
	var collision = move_and_collide(direction * speed * delta)

	if collision:
		if true or collision.collider.is_in_group("pushable"):  # Check if the collider can be pushed
			if collision.collider == weapon_node: 
				HP -= weapon_node.attack
				recoil = (Hero.global_position - global_position).normalized() * 100
				glow()
				if HP <= 0:
					killsound.play()
					speed = 0
					sprite_node.play("Dead")
				
			# Attempt to push the collider by manually adjusting the hero's global_position
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
		self.queue_free()
		var gem_instance = exp_gem_scene.instance()
		gem_instance.global_position = global_position
		EnemyManager.add_child(gem_instance)
		#respawn enemey somewhere else
