extends KinematicBody2D

var speed = 300.0
var pushing_strength = 300.0  # Adjust the pushing effect as needed
var HP = 100.0
var max_HP = 100.0
var ISO = Vector2(1, .5)  # isometric coordinate transform
var unISO = Vector2(1, 2) # undo isometric coordinate transform

onready var smooth_node = $PositionSmoother
onready var sprite_node = $PositionSmoother/Stan
onready var healthbar_node = $PositionSmoother/HealthNode/HeroHealth
onready var camera_node = get_node("/root/Main/Camera")
onready var main_node = get_node("/root/Main")
onready var xp_bar = get_node("/root/Main/UICanvas/xpBar")
onready var you_died = get_node("/root/Main/UICanvas/youdied")
onready var game_over = get_node("/root/Main/GameOverSound")
onready var music = get_node("/root/Main/Music")
onready var focusbutton = get_node("/root/Main/UICanvas/MarginContainer/VBoxContainer/Button1")

#onready var walking_sound =

var sprite_offset = Vector2()

func _ready():
	sprite_offset = smooth_node.position
	sprite_node.play("idle")
	sprite_node.speed_scale = speed / 300.0
	sprite_node.connect("animation_finished", self, "_on_animation_finished") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var start_position = global_position  # Save the current position before moving
	var sprite_start_position = smooth_node.position
	var velocity = Vector2() # The player's movement vector
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var up = Input.is_action_pressed('ui_up')
	var down = Input.is_action_pressed('ui_down')
	# Get input from the player
	#sprite_node.play("idle")
	#if Input.is_action_pressed('punch'):
		#sprite_node.play("punch")
		#get_tree().paused = true
	if sprite_node.animation != "dead":		
		if right and down:
			velocity += Vector2(speed, speed).normalized()
			sprite_node.play("walk_se")
		elif down and left:
			velocity -= Vector2(speed, -speed).normalized()
			sprite_node.play("walk_sw")
		elif left and up:
			velocity -= Vector2(speed, speed).normalized()
			sprite_node.play("walk_nw")
		elif up and right:
			velocity += Vector2(speed, -speed).normalized()
			sprite_node.play("walk_ne")
		elif right:
			velocity.x += 1
			sprite_node.play("walk_e")
		elif down:
			velocity.y += 1
			sprite_node.play("walk_s")
		elif left:
			velocity.x -= 1
			sprite_node.play("walk_w")
		elif up:
			velocity.y -= 1
			sprite_node.play("walk_n")
		

		if velocity.length() > 0 and !$WalkingSound.playing:
			#print("moving")
			$WalkingSound.play()
		elif velocity.length() == 0 and $WalkingSound.playing:
			#print("stopped")
			#$WalkingSound.stop()
			sprite_node.play("idle")
			$WalkingSound.stop()
		# Move the player
		# First, try to move normally.
	
	var collision = move_and_collide(velocity.normalized() * speed * delta * ISO)
	var push_vector = Vector2.ZERO
	
	sprite_node.modulate = Color(1, 1, 1, 1)
	
	if collision:
		$ImpactSound.play()
		if collision.collider.is_in_group("enemies"):
			HP -= collision.collider.power
			sprite_node.modulate = Color(1, 0, 0, 1)
			healthbar_node.value = HP / max_HP * 100
			if HP <= 0:
				sprite_node.play("dead")
				
			
		# Attempt to push the collider by manually adjusting the hero's global_position
		push_vector = collision.remainder.normalized() * pushing_strength * delta
	
	var new_position = global_position + push_vector
	var smoothed_position = (start_position + sprite_start_position).linear_interpolate(new_position + sprite_offset, 0.3)
	global_position = global_position + (new_position - global_position) * ISO 
	smooth_node.position = smoothed_position - new_position
	
	self.z_index = int(smoothed_position.y - camera_node.global_position.y)
	


func _on_Stan_animation_finished():

	if sprite_node.animation == "dead":
		music.stop()
		game_over.play()
		you_died.show()
		AudioServer.set_bus_effect_enabled(0, 0, true)
		get_tree().paused = true
		focusbutton.grab_focus()
		#main_node.reset()
		xp_bar.value = 0

		return
