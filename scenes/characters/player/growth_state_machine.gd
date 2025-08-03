extends StateMachine

class_name GrowthStateMachine

func _state_logic(delta) -> void:
	add_state("small")
	add_state("big")
	add_state("fire")

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state) -> void:
	pass

func _exit_state(old_state, new_state) -> void:
	pass
