extends CharacterBody2D

class_name Player

@onready var growth_state_machine: GrowthStateMachine = $GrowthStateMachine
@onready var velocity_component: PlayerVelocityComponent = $PlayerVelocityComponent
@onready var input_component = $InputComponent
var input_locked: bool = false
var warp_queued: bool = false
var warp_destination: Vector2 = Vector2.ZERO
var queued_warp_direction: Vector2 = Vector2.ZERO
var queued_warp_destination: Vector2 = Vector2.ZERO
var queued_warp_emergence_direction: Vector2 = Vector2.DOWN
var start_position: Vector2

signal shoot_fireball(fireball_pos, fireball_direction)

func _ready() -> void:
	start_position = global_position

func queue_warp(direction: Vector2, destination: Vector2, emergence_direction: Vector2) -> void:
	warp_queued = true
	queued_warp_destination = destination
	queued_warp_direction = direction
	queued_warp_emergence_direction = emergence_direction



func unqueue_warp() -> void:
	warp_queued = false

func warp(direction: Vector2, destination: Vector2) -> void:
	velocity = Vector2.ZERO
	velocity_component.warping = true
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
	input_component.unlock_input()
	velocity_component.warping = false

func pickup_mushroom() -> void:
	growth_state_machine.pickup_mushroom()

func pickup_coin() -> void:
	pass

func hit(attacking_body: Node2D) -> void:
	var knockback_direction: Vector2 = (global_position - attacking_body.global_position).normalized()
	velocity_component.knock_back(knockback_direction)
	$GrowthStateMachine.damage()
	
func queue_bounce() -> void:
	velocity_component.set_y_velocity(-1000.0)
	
func _physics_process(delta: float) -> void:
	input_component.get_input()
	velocity = velocity_component.get_velocity()
	if Input.is_action_pressed("down") and warp_queued:
		input_component.lock_input()
		warp(queued_warp_direction,queued_warp_destination)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is StaticBody2D and collision.get_normal().y == 1:
			collider.hit()
			velocity_component.set_y_velocity(0)
	

func death() -> void:
	position = start_position
	growth_state_machine.set_state(growth_state_machine.get_states().big)
	velocity_component.cancel_knock_back()

func _on_growth_state_machine_death() -> void:
	death()

func fire_flower() -> void: 
	growth_state_machine.pickup_fire()


func _on_input_component_shoot_fireball() -> void:
	if $AnimatedSprite2D.flip_h == true:
		shoot_fireball.emit(global_position - Vector2(16,0), -1.0)
	elif $AnimatedSprite2D.flip_h == false:
		shoot_fireball.emit(global_position + Vector2(16,0), 1.0)

func flag_travel(base_of_flag: Vector2, mounting_position):
	input_component.input_locked = true
	$PlayerVelocityComponent.warping = true
	global_position.x = base_of_flag.x
	get_tree().create_timer(0.5).timeout.connect(
		func(): flag_travel_timer_timeout(base_of_flag,mounting_position)
		)


func flag_travel_timer_timeout(base_of_flag:Vector2, mounting_position):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position", base_of_flag,1.5)
