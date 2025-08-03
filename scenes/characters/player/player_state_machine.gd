extends StateMachine

@onready var parent: Player = get_parent()
@onready var sprite: AnimatedSprite2D = parent.get_node("AnimatedSprite2D")
@onready var velocity_component: PlayerVelocityComponent = parent.get_node("PlayerVelocityComponent")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_state("in_air")
	add_state("idle")
	add_state("run")
	call_deferred("set_state", states.idle)

func _state_logic(delta) -> void:
	pass

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
	match new_state:
		states.idle:
			sprite.play("idle")
		states.run: 
			sprite.play("walk")
		states.in_air:
			sprite.play("in_air")
func _exit_state(old_state, new_state) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
