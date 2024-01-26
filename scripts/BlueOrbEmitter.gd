extends Node2D

var cooldown = 1
var heat = 0

onready var weapon_nodes = get_node("/root/Main/WeaponManager").weapons
var blue_orb = preload("res://scenes/weapons/BlueOrb.tscn")
#var active_orbs = []

func _ready():
	pass
	#spawn_orb()

func _physics_process(delta):
	heat -= delta
	if heat < 0:
		spawn_orb()
		heat = cooldown

func spawn_orb():
	var blue_orb_projectile = blue_orb.instance()
	blue_orb_projectile.z_index = 4096
	blue_orb_projectile.global_position = Hero.get_node("Smoother/OrbOrigin").global_position 
	add_child(blue_orb_projectile)
	weapon_nodes.append(blue_orb_projectile)
