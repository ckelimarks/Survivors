extends Area2D

onready var camera_node = get_node("/root/Main/Camera") # make autoload/global var
var recoil = Vector2.ZERO
var touched = false

var audio_samples := [
	preload("res://sounds/gemsounds/v2/gemsound1.mp3"),
	preload("res://sounds/gemsounds/v2/gemsound2.mp3"),
	preload("res://sounds/gemsounds/v2/gemsound3.mp3"),
	preload("res://sounds/gemsounds/v2/gemsound4.mp3"),
	# ... add more audio samples as needed
]

onready var xpBar = get_node("/root/Main/UICanvas/xpBar")
onready var levelUp = get_node("/root/Main/UICanvas/MarginContainer")

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body):
	if body == Hero:
		if touched:
			gem_captured()
			return
			
		recoil = 1000
		touched = true

		var random_note_index = randi() % audio_samples.size()
		$AudioStreamPlayer.set_stream(audio_samples[random_note_index])
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.connect("finished", self, "_on_audio_finished")
		xpBar.value = xpBar.value + 10
		
	if xpBar.value == 100:
		levelUp.show()
		get_tree().paused = true
		
		
func gem_captured():
	$Sprite.visible = false
	
func _on_audio_finished():
	queue_free()
	
func _process(delta):
	if touched:
		var start_position = global_position
		var force = (Hero.global_position - global_position).normalized() * recoil * delta
		var new_position = global_position - force
		var sprite_start_position = $Sprite.position  # Save the current position before moving
		var smoothed_position = (start_position + sprite_start_position).linear_interpolate(new_position, 0.1)
		global_position = new_position
		$Sprite.position = smoothed_position - new_position
		recoil -= 10
		
	self.z_index = int(global_position.y - camera_node.global_position.y)
