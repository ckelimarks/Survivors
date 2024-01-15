extends KinematicBody2D

var speed = 75  # Adjust as needed
var pushing_strength = 10
onready var camera_node = get_node("/root/Main/Camera")
onready var sprite_node = $AnimatedSprite
onready var killsound = $AudioStreamPlayer2D

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
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		
		if true or collision.collider.is_in_group("pushable"):  # Check if the collider can be pushed
			#HP - DPS 
			#if HP <= 0
			killsound.play()
			speed = 0
			sprite_node.play("Dead")
			#release gem
			
			# Attempt to push the collider by manually adjusting the hero's global_position
			var push_vector = collision.remainder.normalized() * pushing_strength * delta
			var new_position = global_position + push_vector
			var smoothed_position = (start_position + sprite_start_position).linear_interpolate(new_position, 0.1)
			global_position = new_position
			sprite_node.position = smoothed_position - new_position	
			
			
	self.z_index = int(global_position.y - camera_node.global_position.y)


var exp_gem_scene = preload("res://scenes/ExpGem.tscn")

func _on_animation_finished():
	if sprite_node.get_animation() == "Dead":
		self.queue_free()
		var gem_instance = exp_gem_scene.instance()
		gem_instance.global_position = global_position
		EnemyManager.add_child(gem_instance)
		#respawn enemey somewhere else
