extends Area2D

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
		var random_note_index = randi() % audio_samples.size()
		$Sprite.visible = false
		$AudioStreamPlayer.set_stream(audio_samples[random_note_index])
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.connect("finished", self, "_on_audio_finished")
		
func _on_audio_finished():
	queue_free()
