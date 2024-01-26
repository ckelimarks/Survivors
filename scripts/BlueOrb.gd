extends Area2D

onready var weapon_nodes = get_node("/root/Main/WeaponManager").weapons
var speed = 200
var dir = Vector2()
var power = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	dir = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()
	$Sprite.connect("animation_finished", self, "_on_finished")
	$Sprite.play()

func _on_finished(name: String):
	weapon_nodes.erase(self)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += Vector2(speed * dir * delta)
