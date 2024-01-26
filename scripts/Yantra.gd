extends Node2D

var power = 1
var cooldown = 2
var heat = 0

func _ready():
	pass # Replace with function body.

onready var weapon_nodes = get_node("/root/Main/WeaponManager").weapons

func _physics_process(delta):
	heat -= delta
	modulate = Color(1, 1, 1, heat)
	if heat < 0:
		heat = cooldown
	elif heat < .1:
		$Collider.disabled = false
	else:
		$Collider.disabled = true
