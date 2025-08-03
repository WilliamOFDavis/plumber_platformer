extends StateMachine

class_name GrowthStateMachine
@onready var parent: Player = get_parent()

signal death

func _ready() -> void:
	add_state("dead")
	add_state("small")
	add_state("big")
	add_state("fire")
	call_deferred("set_state", states.fire)
func _get_transition(delta):
	return null

func _enter_state(new_state, old_state) -> void:
	match new_state:
		states.small:
			parent.scale = Vector2(0.5,0.5)
		states.big:
			parent.scale = Vector2(1,1)
		states.dead:
			death.emit()
			set_state(states.big)
func _exit_state(old_state, new_state) -> void:
	pass

func damage() -> void:
	state = get_state()
	state = state - 1

func pickup_mushroom() -> void:
	if state == states.small:
		set_state(states.big)
