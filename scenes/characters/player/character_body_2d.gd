extends CharacterBody2D

class_name Player

var air: bool = false
var fresh_jump: bool = true
var accelleration_due_to_gravity: float = 3000
var base_gravity: float = 3000.0
var terminal_velocity_y: float = 5000
var leeway: bool = false
var input_locked: bool = false
var warp_queued: bool = false
var warp_destination: Vector2 = Vector2.ZERO
var queued_warp_direction: Vector2 = Vector2.ZERO
var queued_warp_destination: Vector2 = Vector2.ZERO
var queued_warp_emergence_direction: Vector2 = Vector2.DOWN
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
	if !input_locked:
		velocity.x = Input.get_axis("move_left","move_right") * 300
		if Input.is_action_pressed("jump") and (is_on_floor() or leeway):
			leeway = false
			fresh_jump = true
			$Timer.start()
			velocity.y = -1400
		if Input.is_action_pressed("down") and warp_queued:
			warp(queued_warp_direction,queued_warp_destination)
	#if Input.is_action_pressed("jump") and fresh_jump and velocity.y < 0:
		#accelleration_due_to_gravity = 1750
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is StaticBody2D and collision.get_normal().y == 1:
			collision.get_collider().hit()

func queue_warp(direction: Vector2, destination: Vector2, emergence_direction: Vector2) -> void:
	warp_queued = true
	queued_warp_destination = destination
	queued_warp_direction = direction
	queued_warp_emergence_direction = emergence_direction

func unqueue_warp() -> void:
	warp_queued = false

func warp(direction: Vector2, destination: Vector2) -> void:
	velocity = Vector2.ZERO
	accelleration_due_to_gravity = 0
	input_locked = true
	warp_destination = destination
	$CollisionShape2D.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",position + (direction * 100),3)
	tween.tween_callback(conclude_warp)

func conclude_warp() -> void:
	if warp_destination != Vector2.ZERO:
		global_position = warp_destination
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",position + queued_warp_emergence_direction*60,1)
		tween.tween_callback(unlock_input_and_grav)

func unlock_input_and_grav() -> void:
	$CollisionShape2D.disabled = false
	input_locked = false
	accelleration_due_to_gravity = base_gravity

func get_input() -> void:
	pass
	
func pickup_coin() -> void:
	pass

func pickup_mushroom() -> void:
	pass

func _on_timer_timeout() -> void:
	leeway = false
