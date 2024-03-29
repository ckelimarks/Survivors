extends Node2D

var cooldown = 200
var heat = 0

onready var weapon_nodes = get_node("/root/Main/WeaponManager").weapons
var blue_orb_scene = preload("res://scenes/weapons/BlueOrb.tscn")

func _ready():
	pass
	# spawn_orb()

func _physics_process(delta):
	heat -= delta
	if heat < 0:
#	if Input.is_action_pressed('ui_accept'):
		spawn_orb()
		heat = cooldown

func spawn_orb():
	var blue_orb_projectile = blue_orb_scene.instance()
	blue_orb_projectile.z_index = 4096
	blue_orb_projectile.global_position = Hero.get_node("PositionSmoother/OrbOrigin").global_position 
	add_child(blue_orb_projectile)
	weapon_nodes.append(blue_orb_projectile)

	var orb_audio = blue_orb_projectile.get_node("BlueOrbAudio")
	if orb_audio:
		orb_audio.play()
	else:
		print("BlueOrbAudio node not found.")
