extends StaticBody2D

class_name Brick

var is_hit: bool = false
var hits_to_kill: int = 4
var hits_taken: int = 0 
var loot_to_spawn: PackedScene
var loot_quantity: int = -1

signal loot_spawn_request(item: PackedScene, quant: int, spawn_position: Vector2)
signal question_brick_spent(brick_position: Vector2)



func hit() -> void:
	if !is_hit:
		hits_taken += 1
		if loot_quantity > 0:
			print("loot")
			spawn_loot()
			loot_quantity -= 1
		if hits_taken >= hits_to_kill:
			kill()
		is_hit = true
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position", position + Vector2(0,-20), 0.075)
		tween.tween_callback(come_back)

func come_back() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position", position - Vector2(0,-20), 0.075)
	tween.tween_callback(complete_hit)

func complete_hit() -> void:
	is_hit = false

func set_loot(loot_scene: PackedScene, quantity: int) -> void:
	loot_to_spawn = loot_scene
	loot_quantity = quantity

func spawn_loot() -> void:
	loot_spawn_request.emit(loot_to_spawn,1,global_position)

func kill() -> void:
	self.queue_free()
# Called when the node enters the scene tree for the first time.
