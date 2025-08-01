extends CharacterBody2D

class_name Goomba


var speed: int = 200
var gravity: float = 200
var flatten_starting_position: Vector2
var is_flattening: bool = false
var dead: bool = false
var direction_facing: Vector2 = Vector2.LEFT
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HurtboxComponent.connect("dead", flatten)
	collision_mask
func is_dead() -> bool:
	return dead

func flatten() -> void:
	#$CollisionShape2D.disabled = true
	##is_flattening = true
	##flatten_starting_position = position
	dead = true
	$HitboxComponent.set_collision_mask_value(3,false)
	scale.y = 0.2
	global_position.y = global_position.y + 30
	set_collision_layer_value(4,false)
	set_collision_mask_value(3,false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if is_flattening:
		#scale.y = lerp(scale.y,0.1,0.8)
		#position.y = lerp(position.y, flatten_starting_position.y + 32, 0.8)
	#if scale.y <= 0.12:
		#is_flattening = false

func _physics_process(delta: float) -> void:


	velocity.y = gravity
	if !dead:
		velocity.x = speed * direction_facing.x
		move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if (collision.get_normal().x == 1 or collision.get_normal().x == -1):
			direction_facing = direction_facing * -1


func _on_hitbox_component_player_hit() -> void:
	direction_facing = direction_facing * -1
