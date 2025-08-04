extends Area2D

var flag_base: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flag_base = global_position + Vector2(0,64*7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.flag_travel(flag_base, body.global_position)
