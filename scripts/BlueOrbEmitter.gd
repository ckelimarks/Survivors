extends Node2D


onready var weapon_nodes = get_node("/root/Main/WeaponManager").weapons
var blue_orb = preload("res://scenes/weapons/BlueOrb.tscn")
var active_orbs = []

func _ready():
	spawn_orb()

func _physics_process(delta):
	pass

func spawn_orb():
	for orb in active_orbs:
		orb.queue_free()
		active_orbs.erase(orb)
		weapon_nodes.erase(orb)
	
	var blue_orb_projectile = blue_orb.instance()
	blue_orb_projectile.global_position = Hero.global_position 
	$BlueOrbTimer.connect("timeout", self, "spawn_orb")
	$BlueOrbTimer.start()
	add_child(blue_orb_projectile)
	active_orbs.append(blue_orb_projectile)
	weapon_nodes.append(blue_orb_projectile)
