extends KinematicBody2D


var speed = 100
var velocity = Vector2.ZERO
var rotation_direction = 1  # 1 for clockwise, -1 for counterclockwise
var rotation_speed = 0.1  # Adjust the rotation speed as needed


func _ready():
	randomize()
	velocity.x = [-1, 1][randi() % 2]
	velocity.y = [-0.8, 0.8][randi() % 2]
	
	# Set the rotation direction based on the initial random choice
	rotation_direction = velocity.x

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * speed * delta)

	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		
		# Check if the collision is with the enemy or player paddle
		#if collision_info.collider.name == "Enemy" or collision_info.collider.name == "Player":
			# Reverse the rotation direction
			#rotation_direction *= -1
			#get_node("/root/Level/CollisionSound").play()
	
	# Rotate the ball
	#rotate(rotation_direction * rotation_speed)
