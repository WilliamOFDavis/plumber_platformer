extends Node2D

@export var player_velocity_component: PlayerVelocityComponent

@export var jump_velocity: float = -1500.0

var input_locked: bool = false

func get_input():
	if !input_locked:
		var axis = Input.get_axis("move_left","move_right")
		player_velocity_component.set_x_direction(axis)
		if Input.is_action_pressed("jump") and get_parent().is_on_floor():
			player_velocity_component.set_y_velocity(jump_velocity)

func lock_input(): 
	input_locked = true

func unlock_input():
	input_locked = false
