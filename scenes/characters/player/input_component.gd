extends Node2D

@export var player_velocity_component: PlayerVelocityComponent
@export var jump_velocity: float = -500.0
@export var growth_state_machine: GrowthStateMachine

var input_locked: bool = false

signal shoot_fireball

func get_input():
	var growth_state = growth_state_machine.get_state()
	var growth_states = growth_state_machine.get_states()
	if !input_locked:
		var axis = Input.get_axis("move_left","move_right")
		player_velocity_component.set_x_direction(axis)
		if Input.is_action_pressed("jump") and get_parent().is_on_floor():
			player_velocity_component.set_y_velocity(jump_velocity)
		if Input.is_action_just_pressed("shoot_fireball") and growth_state == growth_states.fire:
			shoot_fireball.emit()
func lock_input(): 
	input_locked = true

func unlock_input():
	input_locked = false
