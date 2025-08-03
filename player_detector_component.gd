extends Area2D

signal stomped


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var direction_to_player: Vector2 = body.position - global_position
		var posy =  global_position.y - body.position.y 
		if posy > 10:
			body.queue_bounce()
			stomped.emit()
			self.queue_free()
		else:
			body.hit(self)
