extends Node2D
@onready var mushroom_scene: PackedScene = preload("res://scenes/pickups/mushroom_pickup.tscn")
@onready var goomba_scene: PackedScene = preload("res://scenes/characters/enemies/goomba/goomba.tscn")
@onready var floating_coin_scene: PackedScene = preload("res://scenes/pickups/floating_coin.tscn")
@onready var red_brick_scene: PackedScene = preload("res://scenes/bricks/wall_bricks/red_brick.tscn")
@onready var ground_tilemap: TileMapLayer = $GroundSmall
@onready var benign_question_brick_scene: PackedScene = preload("res://scenes/bricks/question_bricks/benign_question_brick.tscn")
@onready var coin_scene: PackedScene = preload("res://scenes/pickups/rigid_coin.tscn")

@onready var tile_scene_dictionary = {Vector2i(1,4) : red_brick_scene,
Vector2i(2,5) : benign_question_brick_scene,
Vector2i(1,5) : floating_coin_scene, 
Vector2i(4,5): goomba_scene}

@onready var alternate_tile_drop_scenes = {"rigid_coin" : coin_scene, 
"super_mushroom": mushroom_scene}

func _ready() -> void:
	
	var used_cells: Array[Vector2i] = ground_tilemap.get_used_cells()
	for i in used_cells:
		var cell_atlas_coords: Vector2i = ground_tilemap.get_cell_atlas_coords(i)
		var alt = ground_tilemap.get_cell_alternative_tile(i)
		var tile_scene = tile_scene_dictionary.get(cell_atlas_coords)
		
		if  tile_scene!= null:
			var new_scene: Node2D = tile_scene.instantiate()
			if alt > 0:
				var tile_data : TileData = ground_tilemap.get_cell_tile_data(i)
				var custom_data_drop = tile_data.get_custom_data("drop")
				var custom_data_quantity = tile_data.get_custom_data("quantity")
				new_scene.set_loot(alternate_tile_drop_scenes.get(custom_data_drop), custom_data_quantity)

			if new_scene is BenignQuestionBrick:
				new_scene.connect("question_brick_spent", replace_question_brick)
			if new_scene is Brick:
				new_scene.connect("loot_spawn_request", spawn_pickup_loot)
				
			new_scene.global_position = ground_tilemap.map_to_local(i)
			
			if new_scene.is_in_group("bricks"):
				$Bricks.add_child(new_scene)
				
			elif new_scene.is_in_group("pickups"):
				$Pickups.add_child(new_scene)
				
			elif new_scene.is_in_group("enemies"):
				$Enemies.add_child(new_scene)
				
			ground_tilemap.set_cell(i)


func replace_question_brick(brick_pos: Vector2) -> void:
	var tile_id: Vector2i = ground_tilemap.local_to_map(brick_pos)
	ground_tilemap.set_cell(tile_id,0, Vector2i(3,5))

func spawn_pickup_loot(loot:PackedScene, quantity: int, loot_position: Vector2) -> void:
	var loot_drop: Node2D = loot.instantiate()
	loot_drop.global_position = loot_position
	$Pickups.add_child(loot_drop)
