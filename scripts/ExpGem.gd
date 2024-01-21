extends Area2D

onready var camera_node = get_node("/root/Main/Camera") # make autoload/global var

var audio_samples := [
	preload("res://sounds/gemsounds/v2/gemsound1.mp3"),
	preload("res://sounds/gemsounds/v2/gemsound2.mp3"),
	preload("res://sounds/gemsounds/v2/gemsound3.mp3"),
	preload("res://sounds/gemsounds/v2/gemsound4.mp3"),
	# ... add more audio samples as needed
]

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body):
	if body == Hero:
		var recoil = Vector2(0,0)
		recoil = (Hero.global_position - global_position).normalized() * 100
		print(recoil)
		var new_position = global_position + recoil

		var random_note_index = randi() % audio_samples.size()
		$Sprite.visible = false
		$AudioStreamPlayer.set_stream(audio_samples[random_note_index])
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.connect("finished", self, "_on_audio_finished")
		
func _on_audio_finished():
	queue_free()
	
func _process(delta):
	var recoil = Vector2(0,0)
	recoil = (Hero.global_position - global_position).normalized() * 100
	var new_position = global_position + recoil
	self.z_index = int(global_position.y - camera_node.global_position.y)
