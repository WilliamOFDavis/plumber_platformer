extends Area2D

class_name HitboxComponent

@onready var parent = get_parent()

signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	var direction_to_player = (Vector2(body.position.x, body.position.y) - parent.position ).normalized()
	if body.is_in_group("player"):
		body.hit(direction_to_player)
		player_hit.emit()
