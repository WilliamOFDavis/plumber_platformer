extends Node2D

class_name VelocityComponent

@export var speed: float = 200.0
@export var gravity: float = 400.0

var is_falling: bool = false
var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.

func get_velocity(delta:float) -> Vector2:
	if is_falling: 
		velocity.x = 0 
		velocity.y += gravity
	else:
		velocity.y = 0
	return velocity

func set_x_direction(new_direction: float) -> void: 
	direction.x = new_direction
	velocity = direction*speed

func set_falling(falling: bool) -> void:
	is_falling = falling
