extends RigidBody2D

class_name RigidCoin

var scene_entry: bool = true

func _ready() -> void:
	position.y -= 40
	var random_point: Vector2 = Vector2(position.x + randf_range(-10.0,10.0), position.y - 70)
	var direction: Vector2 
	direction = (random_point - position).normalized()
	$PickupDetectionRadius.connect("body_entered", body_entered)
	constant_force = direction * 3000

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if scene_entry:

		scene_entry = false
		position = position + Vector2(0,-30)

func _physics_process(delta: float) -> void:
	constant_force = lerp(constant_force, Vector2.ZERO, 0.15)

func body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		self.queue_free()
