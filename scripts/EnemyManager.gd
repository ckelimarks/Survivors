extends Node2D

var enemy_scene = preload("res://scenes/Enemy.tscn")
var max_enemies = 200
var enemies = []

func initialize():
	spawn_enemies()

func spawn_enemies():
	var hero_position = Hero.global_position
	var spawn_radius = 500  # Distance from the hero

	for i in range(max_enemies):
		var enemy_instance = enemy_scene.instance()
		var angle = i * 2 * PI / max_enemies
		var position = hero_position + Vector2(cos(angle), sin(angle)) * spawn_radius * (1+randf())

		# Set the enemy's position and add it to the scene
		enemy_instance.global_position = position
		enemy_instance.add_to_group("enemies")
		add_child(enemy_instance)

		var transform = Transform2D(0, position)

		# Keep track of the enemy instance
		enemies.append(enemy_instance)

func _process(delta):
	for enemy in enemies:
		pass
