extends Node2D

class_name MovementComponent

@export var raycast_component: RaycastComponent 
@export var velocity_component: VelocityComponent

var direction: Vector2 = Vector2.RIGHT
var velocity: Vector2 
var dead: bool = false
var falling: bool = false
var begin:bool = false
signal move_position(new_position)

func set_begin() -> void:
	begin = true
	
func set_dead() -> void:
	dead = true
func _physics_process(delta: float) -> void:
	if !dead:
		if raycast_component.check_falling():
			velocity_component.set_falling(true)
			falling = true
		else:
			velocity_component.set_falling(false)
			falling = false
		velocity_component.set_x_direction(direction.x)
		velocity = velocity_component.get_velocity(delta)
		if !falling:
			if !raycast_component.get_collision(direction) and (raycast_component.get_collision(Vector2.DOWN) or get_parent() is MushroomPickup):
				var new_global_position: Vector2 = global_position + velocity * delta
				move_position.emit(new_global_position)
			elif raycast_component.get_collision(direction):
				if get_parent() is Sprite2D:
					get_parent().flip_h = not get_parent().flip_h
				direction = direction * -1
			elif !raycast_component.get_collision(Vector2.DOWN) and !get_parent() is MushroomPickup: 
				if get_parent() is Sprite2D:
					get_parent().flip_h = not get_parent().flip_h
				direction = direction * -1
				velocity_component.set_x_direction(direction.x)
				velocity = velocity_component.get_velocity(delta)
				var new_global_position: Vector2 = global_position + velocity * delta
				move_position.emit(new_global_position)
		else:
			var new_global_position: Vector2 = global_position + velocity * delta
			move_position.emit(new_global_position)
