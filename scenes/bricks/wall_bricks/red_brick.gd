extends Brick
class_name RedBrick


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
		if $GPUParticles2D.emitting:
			$GPUParticles2D.emitting = false
			$GPUParticles2D.emitting = true
		else: 
			$GPUParticles2D.emitting = true
