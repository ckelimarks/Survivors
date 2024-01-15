extends Camera2D

var ground_material  # Reference to the ground material

func _ready():
	pass
	
func _process(delta):
	var target_position = Hero.global_position
	global_position = global_position.linear_interpolate(target_position, smoothing_speed * delta)
