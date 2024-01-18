extends Node2D

# Get a reference to the camera node
onready var camera_node = get_node("/root/Main/Camera")
var enemy_scene = preload("res://scenes/Enemy.tscn")
var max_enemies = 200
var active_enemies = 0
var enemies = []

func spawn_enemy(view):
	var enemy_instance = enemy_scene.instance()
	var vpos = view.position
	var vsiz = view.size
	var position = Vector2(0,0)
	var seg = int(rand_range(0, 4))
	if seg == 0:
		position = Vector2(vpos.x + rand_range(-2,-1)*vsiz.x, vpos.y + rand_range(-1,1)*vsiz.y)
	elif seg == 1:
		position = Vector2(vpos.x + rand_range(1,2)*vsiz.x, vpos.y + rand_range(-1,1)*vsiz.y)
	elif seg == 2:
		position = Vector2(vpos.x + rand_range(-1,1)*vsiz.x, vpos.y + rand_range(-2,-1)*vsiz.y)
	elif seg == 3:
		position = Vector2(vpos.x + rand_range(-1,1)*vsiz.x, vpos.y + rand_range(1,2)*vsiz.y)

	# Set the enemy's position and add it to the scene
	enemy_instance.global_position = position
	enemy_instance.add_to_group("enemies")
	add_child(enemy_instance)

	# Keep track of the enemy instance
	enemies.append(enemy_instance)

func _process(delta):
	# Define the maximum view rectangle considering the camera's position
	var view_rect = Rect2(camera_node.global_position, get_viewport_rect().size)
	if active_enemies < max_enemies && randf() < 5e-3:
		spawn_enemy(view_rect)
