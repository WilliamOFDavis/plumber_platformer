extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position -= Vector2(0,20)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(global_position.x,global_position.y-44), 1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pickup_detection_component_pickup(player: Variant) -> void:
	self.queue_free()
	player.pickup_mushroom()
