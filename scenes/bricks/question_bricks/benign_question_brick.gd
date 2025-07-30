extends Brick

class_name BenignQuestionBrick

var kill_queued: bool = false

func _ready() -> void:
	hits_to_kill = 1

func kill() -> void:
	question_brick_spent.emit(global_position)
	self.queue_free()
