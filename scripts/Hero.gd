extends KinematicBody2D

var speed = 200
var pushing_strength = 300  # Adjust the pushing effect as needed
var HP = 100.0
var max_HP = 100.0

onready var smooth_node = $Smoother
onready var healthbar_node = $Smoother/HealthNode/HeroHealth
onready var camera_node = get_node("/root/Main/Camera")
onready var main_node = get_node("/root/Main")

var sprite_offset = Vector2()


func _ready():
	sprite_offset = smooth_node.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var start_position = global_position  # Save the current position before moving
	var sprite_start_position = smooth_node.position
	var velocity = Vector2() # The player's movement vector

	# Get input from the player
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
		$Smoother/Sprite.flip_h = true
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
		$Smoother/Sprite.flip_h = false
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1

	# Move the player
	# First, try to move normally.
	var collision = move_and_collide(velocity.normalized() * speed * delta)

	$Smoother/Sprite.modulate = Color(1, 1, 1, 1)
	
	if collision:
		if collision.collider.is_in_group("enemies"):  # Check if the collider can be pushed
			HP -= collision.collider.power
			$Smoother/Sprite.modulate = Color(1, 0, 0, 1)
			healthbar_node.value = HP / max_HP * 100
			if HP <= 0:
				main_node.reset()
				return
			
		# Attempt to push the collider by manually adjusting the hero's global_position
		var push_vector = collision.remainder.normalized() * pushing_strength * delta
		var new_position = global_position + push_vector
		var smoothed_position = (start_position + sprite_start_position).linear_interpolate(new_position + sprite_offset, 0.1)
		global_position = new_position
		smooth_node.position = smoothed_position - new_position
	
	self.z_index = int(global_position.y - camera_node.global_position.y)
	
