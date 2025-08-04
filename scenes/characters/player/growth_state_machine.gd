extends StateMachine

class_name GrowthStateMachine
@onready var parent: Player = get_parent()
@export var player_state_machine: StateMachine
@export var sprite: AnimatedSprite2D 

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
		states.fire: 
			parent.scale = Vector2(1,1)
			var player_states = player_state_machine.get_states()
			match player_state_machine.get_state():
				player_states.idle:
					sprite.play("fire_idle")
				player_states.run:
					sprite.play("fire_walk")
				player_states.in_air:
					sprite.play("fire_in_air")


func _exit_state(old_state, new_state) -> void:
	pass

func damage() -> void:
	state = get_state()
	state = state - 1

func pickup_mushroom() -> void:
	if state == states.small:
		set_state(states.big)
 
func pickup_fire() -> void: 
	set_state(states.fire)
