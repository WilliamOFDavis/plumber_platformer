extends Sprite2D

class_name Goomba

@onready var raycast_component: RaycastComponent = $RaycastComponent
@onready var movement_component: MovementComponent = $MovementComponent
var speed: int = 200
var gravity: float = 200
var flatten_starting_position: Vector2
var is_flattening: bool = false
var dead: bool = false
var direction_facing: Vector2 = Vector2.LEFT
# Called when the node enters the scene tree for the first time.

func is_dead() -> bool:
	return dead
func set_begin() -> void:
	movement_component.set_begin()
func _process(delta:float) -> void:
	pass

func flatten() -> void:
	##is_flattening = true
	##flatten_starting_position = position
	dead = true
	movement_component.set_dead()
	scale.y = 0.2
	global_position.y = global_position.y + 30


func _physics_process(delta: float) -> void:
	pass

func kill() -> void:
	if !dead:
		flatten()

func _on_hitbox_component_player_hit() -> void:
	direction_facing = direction_facing * -1


func _on_movement_component_move_position(new_position: Variant) -> void:
	global_position = new_position


func _on_player_detector_component_stomped() -> void:
	if !dead:
		flatten()
