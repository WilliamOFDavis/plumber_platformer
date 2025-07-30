extends CharacterBody2D

var air: bool = false
var fresh_jump: bool = true
var accelleration_due_to_gravity: float = 3000.0
var terminal_velocity_y: float = 5000
var leeway: bool = false
# Called when the node enters the scene tree for the first time.s
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass	
func _physics_process(delta: float) -> void:
	if !is_on_floor() and !air:
		air = true
		leeway = true
		$Timer.start()
	if is_on_floor() and air:
		air = false
	if !is_on_floor():
		if velocity.y < terminal_velocity_y:
			velocity.y += accelleration_due_to_gravity*delta
	velocity.x = Input.get_axis("move_left","move_right") * 300
	if Input.is_action_pressed("jump") and (is_on_floor() or leeway):
		leeway = false
		fresh_jump = true
		$Timer.start()
		velocity.y = -1400
	#if Input.is_action_pressed("jump") and fresh_jump and velocity.y < 0:
		#accelleration_due_to_gravity = 1750
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is StaticBody2D and collision.get_normal().y == 1:
			collision.get_collider().hit()



func _on_timer_timeout() -> void:
	leeway = false
