extends CharacterBody2D

class_name Fireball

@export var horizontal_velocity: float = 750.0
@export var gravity: float = 100.0
var horizontal_direction: float = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.y = -600


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.x = horizontal_velocity * horizontal_direction
	velocity.y += gravity
	
	var pre_collision_velocity = velocity
	
	move_and_slide()
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		var collider = collision.get_collider()
		if collider is RedBrick:
			collider.hit()
	

	if is_on_floor() or is_on_ceiling():
		velocity.y = -abs(pre_collision_velocity.y)
	if is_on_wall():
		self.queue_free()


func _on_enemy_detector_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies") and !area.get_parent().dead:
		area.get_parent().kill()
		self.queue_free()
