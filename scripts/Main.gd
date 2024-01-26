extends Node2D

	
	
func _ready():
	print($WeaponManager.weapons)
	
	pass

func reset():
	# unspawn enemies
	for enemy in EnemyManager.enemies:
		enemy.queue_free()
	EnemyManager.enemies = []
		

	# unspawn weapons
	#for weapon in $WeaponManager.weapons:
	#	weapon.queue_free()
	#$WeaponManager.weapons = []
	
	# reset/respawn Hero
	Hero.HP = Hero.max_HP
	Hero.get_node("Smoother/HealthNode/HeroHealth").value = 100
	Hero.get_node("Smoother").position = Hero.sprite_offset
	Hero.global_position = Vector2.ZERO
