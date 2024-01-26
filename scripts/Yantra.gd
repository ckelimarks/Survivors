extends Node2D

var power = 1
var cooldown = 10
var heat = 0

func _ready():
	pass # Replace with function body.

onready var weapon_nodes = get_node("/root/Main/WeaponManager").weapons

func _physics_process(delta):
	heat -= delta
	print(heat)
	if heat < 0:
		$Collider.disabled = false
		heat = cooldown
	else:
		$Collider.disabled = true
