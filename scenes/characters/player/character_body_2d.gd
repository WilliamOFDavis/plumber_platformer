extends CharacterBody2D

class_name Player


@export var accelleration_due_to_gravity: float = 2500
@export var base_gravity: float = 3000.0
@export var jump_velocity: float = -1100.0
@export var terminal_velocity_y: float = 5000
@export var knock_back_magnitude: float = 1000

var growth_level: int = 1
var fire_active: bool = 0
var air: bool = false
var fresh_jump: bool = true
var leeway: bool = false
var input_locked: bool = false
var warp_queued: bool = false
var warp_destination: Vector2 = Vector2.ZERO
var queued_warp_direction: Vector2 = Vector2.ZERO
var queued_warp_destination: Vector2 = Vector2.ZERO
var queued_warp_emergence_direction: Vector2 = Vector2.DOWN
var bounce_queued: bool = false
var knockback_queued: bool = true
var knockback_vector: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.s
func _ready() -> void:
	scale = Vector2(0.5,0.5)


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
			velocity.y = jump_velocity
		if Input.is_action_pressed("down") and warp_queued:
			warp(queued_warp_direction,queued_warp_destination)
	#if Input.is_action_pressed("jump") and fresh_jump and velocity.y < 0:
		#accelleration_due_to_gravity = 1750
	if bounce_queued:
		velocity.y = -1000
		var vel = velocity
		bounce_queued = false
	velocity = velocity + knockback_vector
	move_and_slide()
	knockback_vector = lerp(knockback_vector, Vector2.ZERO, 0.2)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is StaticBody2D and collision.get_normal().y == 1:
			collider.hit()
		#if collider is Goomba and collision.get_normal() == Vector2(0,-1):
			#if !collider.dead:
				#bounce_queued = true
				#collider.flatten()

func queue_warp(direction: Vector2, destination: Vector2, emergence_direction: Vector2) -> void:
	warp_queued = true
	queued_warp_destination = destination
	queued_warp_direction = direction
	queued_warp_emergence_direction = emergence_direction

func queue_bounce() -> void:
	bounce_queued = true

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

func hit(knock_back_direction: Vector2) -> void:
	
	knockback_vector = Vector2(knock_back_direction.x,knock_back_direction.y * -0.2 - 0.1) * knock_back_magnitude
	reduce_growth()


func reduce_growth() -> void:
	if growth_level > 1:
		growth_level -= 1
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", scale-Vector2(0.5,0.5), 1)

func pickup_mushroom() -> void:
	if growth_level < 2:
		growth_level += 1
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", scale*2, 1)

func _on_timer_timeout() -> void:
	leeway = false
