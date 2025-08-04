extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0,-64), 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pickup_detection_component_pickup(player: Variant) -> void:
	player.fire_flower()
	self.queue_free()
