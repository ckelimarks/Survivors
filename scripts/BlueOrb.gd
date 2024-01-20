extends KinematicBody2D


#export (int) var speed = 600
var velocity = Vector2.ZERO
var rotation_speed = 0.1  # Adjust the rotation speed as needed

var angle = Vector2.ZERO
var target = Vector2.ZERO 
var power = 1
var level = 1
var hp = 1
var speed = 100
var damage =  5
var knock_amount = 100
var attack_size = 1.0

func _ready():
	#randomize()
	#velocity.x = [-1, 1][randi() % 2]
	#velocity.y = [-0.8, 0.8][randi() % 2]
	
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg2rad(135)
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knock_amount = 100
			attack_size = 1.0
	
	# Set the rotation direction based on the initial random choice
	#rotation_direction = velocity.x

func _physics_process(delta):
	
	position += angle*speed*delta
	
	var collision_info = move_and_collide(velocity * speed * delta)
	#global_position += velocity
	
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		
		# Check if the collision is with the enemy or player paddle
		#if collision_info.collider.name == "Enemy" or collision_info.collider.name == "Player":
			# Reverse the rotation direction
			#rotation_direction *= -1
			#get_node("/root/Level/CollisionSound").play()
	
	# Rotate the ball
#rotate(rotation_direction * rotation_speed)

