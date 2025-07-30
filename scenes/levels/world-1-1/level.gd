extends Node2D


@onready var red_brick_scene: PackedScene = preload("res://scenes/bricks/wall_bricks/red_brick.tscn")
@onready var ground_tilemap: TileMapLayer = $GroundSmall
@onready var benign_question_brick_scene: PackedScene = preload("res://scenes/bricks/question_bricks/benign_question_brick.tscn")
@onready var coin_scene: PackedScene = preload("res://coin.tscn")
@onready var brick_scenes = {"RedBrick" : red_brick_scene, "BenignQuestionBrick" : benign_question_brick_scene }
@onready var pickup_scenes = {"Coin": coin_scene}


var brick_dictionary = {"RedBrick" : Vector2i(1,4), "BenignQuestionBrick" : Vector2i(2,5), "SpentQuestionBrick" : Vector2i(3,5)}

func _ready() -> void:
	var used_cells: Array[Vector2i] = ground_tilemap.get_used_cells()
	for i in used_cells:
		for j in brick_dictionary:
			if ground_tilemap.get_cell_atlas_coords(i) == brick_dictionary.get(j):
				var brick: Brick = brick_scenes.get(j).instantiate()
				brick.set_loot(coin_scene,4)
				if brick is BenignQuestionBrick:
					brick.connect("question_brick_spent", replace_question_brick)
				brick.global_position = ground_tilemap.map_to_local(i)
				$Bricks.add_child(brick)
				ground_tilemap.set_cell(i)


func replace_question_brick(brick_pos: Vector2) -> void:
	var tile_id: Vector2i = ground_tilemap.local_to_map(brick_pos)
	ground_tilemap.set_cell(tile_id,0, brick_dictionary.get("SpentQuestionBrick"))
