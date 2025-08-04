extends Sprite2D

class_name Koopa

signal koopa_dead(global_pos)

var dead: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_movement_component_move_position(new_position: Variant) -> void:
	global_position = new_position

func kill() -> void:
	_on_hurtbox_component_dead()

func _on_hurtbox_component_dead() -> void:
	koopa_dead.emit(global_position)
	self.queue_free()


func _on_player_detector_component_stomped() -> void:
	koopa_dead.emit(global_position)
	self.queue_free()
