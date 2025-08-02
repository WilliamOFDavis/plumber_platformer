extends Area2D

class_name HurtboxComponent

signal dead

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var direction_to_player: Vector2 = body.position - position
		var normalized_direction: Vector2 = direction_to_player.normalized()
		var angle_to = normalized_direction.angle()
		if body.position.y > position.y + 50:
			dead.emit()
			body.queue_bounce()
