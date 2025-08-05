extends Node2D

class_name RaycastComponent

@onready var raycasts = {
Vector2(0,1): $RayCastDown,
Vector2(0,-1): $RayCastUp,
Vector2(1,0): $RayCastRight,
Vector2(-1,0): $RayCastLeft
}
@onready var raycasts_falling: Array[RayCast2D] = [$RayCastDown,$RayCastFallingLeft,$RayCastFallingRight]

func get_collision(direction: Vector2) -> bool:
	var raycast: RayCast2D = raycasts.get(direction)
	var result = raycast.is_colliding()
	var collider = raycast.is_colliding()
	return raycast.is_colliding()

func get_collider(direction: Vector2) -> Node2D:
	var raycast: RayCast2D = raycasts.get(direction)
	return raycast.get_collider()

func check_falling() -> bool:
	var falling: bool = true
	for i in raycasts_falling:
		var raycast = i
		if raycast.is_colliding():
			falling = false
	return falling
