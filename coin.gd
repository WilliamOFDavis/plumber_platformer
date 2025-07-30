extends RigidBody2D

var scene_entry: bool = true

func _ready() -> void:
	$PickupDetectionRadius.connect("body_entered", body_entered)
	constant_force = Vector2(0,-500)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if scene_entry:
		scene_entry = false
		position = position + Vector2(0,-30)
		
func body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		self.queue_free()
