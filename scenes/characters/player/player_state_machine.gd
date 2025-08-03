extends StateMachine

@onready var parent: Player = get_parent()
@onready var sprite: AnimatedSprite2D = parent.get_node("AnimatedSprite2D")
@onready var velocity_component: PlayerVelocityComponent = parent.get_node("PlayerVelocityComponent")
@export var growth_state_machine: GrowthStateMachine

var growth_state
var growth_states
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_state("in_air")
	add_state("idle")
	add_state("run")
	call_deferred("set_state", states.idle)

func _state_logic(delta) -> void:
	if growth_state_machine:
		growth_state = growth_state_machine.get_state()
		growth_states = growth_state_machine.get_states()

func _get_transition(delta):
	if !parent.is_on_floor():
		if state != states.in_air:
			return states.in_air
	
	elif parent.is_on_floor():
		if velocity_component.is_moving():
			if state != states.run:
				return states.run
		else:
			if state != states.idle:
				return states.idle

func _enter_state(new_state, old_state) -> void:
	var current_growth = growth_state_machine.get_state() if growth_state_machine else null
	var is_fire = current_growth == growth_states.fire if growth_states else false
	
	match new_state:
		states.idle:
			sprite.play("fire_idle" if is_fire else "idle")
		states.run: 
			sprite.play("fire_walk" if is_fire else "walk")
		states.in_air:
			sprite.play("fire_in_air" if is_fire else "in_air")

func _exit_state(old_state, new_state) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
