extends Node2D

class_name PlayerVelocityComponent

@onready var parent = get_parent()
@export var player_state_machine: StateMachine
@export var player_sprite: AnimatedSprite2D

@export var speed: float = 500 
@export var gravity: float = 3000.0
@export var velocity: Vector2
@export var direction: Vector2 = Vector2.ZERO

var knockback_force: float =  500.0
var knockback_velocity: Vector2
var warping: bool = false

func set_x_direction(axis: float) -> void:
	direction.x = axis
	if direction.x == 1:
		player_sprite.flip_h = false
	elif direction.x == -1:
		player_sprite.flip_h = true
	if knockback_velocity.length() < 50:  # or some small threshold
		velocity.x = speed * axis
func set_y_velocity(vel: float) -> void:
	velocity.y = vel

func _physics_process(delta: float) -> void:
	if !warping:
		if player_state_machine.get_state() == player_state_machine.get_states().in_air and !warping:
			velocity.y += gravity * delta
		elif knockback_velocity == Vector2.ZERO:
			velocity.y = 0
	else: 
		velocity =  Vector2.ZERO
	velocity = velocity + knockback_velocity
	knockback_velocity = lerp(knockback_velocity,Vector2.ZERO,0.2)
func is_moving() -> bool:
	if velocity.x == 0:
		return false
	else:
		return true

func get_velocity() -> Vector2:
	return velocity

func knock_back(knockback_direction: Vector2) -> void:
	knockback_velocity = knockback_direction * knockback_force
	knockback_velocity.y = min(knockback_velocity.y, 200) 

func cancel_knock_back() -> void:
	knockback_velocity = Vector2.ZERO
