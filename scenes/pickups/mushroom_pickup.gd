extends Node2D

class_name MushroomPickup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	position -= Vector2(0,20)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(global_position.x,global_position.y-44), 1)
	tween.tween_callback(set_begin)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func set_begin() -> void:
	$MovementComponent.set_begin()

func _on_pickup_detection_component_pickup(player: Variant) -> void:
	self.queue_free()
	player.pickup_mushroom()


func _on_movement_component_move_position(new_position: Variant) -> void:
	global_position = new_position
