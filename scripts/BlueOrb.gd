extends KinematicBody2D

var speed = 200
var dir = Vector2()
var power = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	dir = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(Vector2(speed * dir * delta))
