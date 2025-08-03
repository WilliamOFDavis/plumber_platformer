extends Node2D

class_name PlayerVelocityComponent

@onready var parent = get_parent()
@export var player_state_machine: StateMachine
@export var player_sprite: AnimatedSprite2D

@export var speed: float = 500 
@export var gravity: float = 3000.0
@export var velocity: Vector2
@export var direction: Vector2 = Vector2.ZERO

var warping: bool = false

func set_x_direction(axis: float) -> void:
	direction.x = axis
	if direction.x == 1:
		player_sprite.flip_h = false
	elif direction.x == -1:
		player_sprite.flip_h = true
	velocity.x = speed * axis

func set_y_velocity(vel: float) -> void:
	velocity.y = vel

func _physics_process(delta: float) -> void:
	if player_state_machine.get_state() == player_state_machine.get_states().in_air and !warping:
		velocity.y += gravity * delta
	else:
		velocity.y = 0
func is_moving() -> bool:
	if velocity.x == 0:
		return false
	else:
		return true

func get_velocity() -> Vector2:
	return velocity
