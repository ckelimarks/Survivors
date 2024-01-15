extends Area2D

var audio_samples := [
	preload("res://sounds/gemsounds/gemsound1.mp3"),
	preload("res://sounds/gemsounds/gemsound2.mp3"),
	# ... add more audio samples as needed
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	
	
func _on_body_entered(body):
	#print(body)
	if body == Hero:
	#if body.is_in_group("player"):
		#print("entered")
		var random_note_index = randi() % audio_samples.size()
		$AudioStreamPlayer.set_stream(audio_samples[random_note_index])
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.connect("finished", self, "_on_Audio_finished")
		#print($AudioStreamPlayer.stream)
		
		
func _on_Audio_finished():
	print("hey")	
