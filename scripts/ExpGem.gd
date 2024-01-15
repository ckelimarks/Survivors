extends Area2D

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
		print("entered")
		# Player picked up the experience gem
		#queue_free()  # Destroy the experience gem
		# Call your function to play the random audio
		pass
		#get_parent().on_experience_gem_pickup()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
