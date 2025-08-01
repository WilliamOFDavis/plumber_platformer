extends Area2D

class_name PickupDetectionComponent

signal pickup(player)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered",_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pickup.emit(body)
