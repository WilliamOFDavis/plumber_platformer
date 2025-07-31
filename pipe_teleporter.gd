extends Area2D

@export var warp_destination_marker: Marker2D
@export var warp_direction: Vector2
@export var emergence_direction: Vector2

var warp_destination: Vector2

func _ready() -> void:
	warp_destination = warp_destination_marker.position

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.queue_warp(warp_direction, warp_destination, emergence_direction)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.unqueue_warp()
