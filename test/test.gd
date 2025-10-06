class_name Test
extends Node

var frame: int = 0

var offset = Offset.new()
var player = Player.new()
var rival = Rival.new()

func _ready():
	print(Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)])
	print(Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)])

	add_child(offset)
	add_child(player)
	add_child(rival)

	offset.signal_score.connect(func(score: int) -> void:
		print("offset score: %d, frame: %d\n" % [score, frame])
		player.on_score(score)
		rival.on_score(score)
	)

	player.signal_combo.connect(func(combo: int) -> void:
		print("player combo: %d, frame: %d\n" % [combo, frame])
		offset.on_combo(0, combo)
	)
	player.signal_damaged.connect(func(damage: int) -> void:
		print("player damaged: %d, frame: %d\n" % [damage, frame])
		offset.on_damaged(0, damage)
	)

	rival.signal_combo.connect(func(combo: int) -> void:
		print("rival combo: %d, frame: %d\n" % [combo, frame])
		offset.on_combo(1, combo)
	)
	rival.signal_damaged.connect(func(damage: int) -> void:
		print("rival damaged: %d, frame: %d\n" % [damage, frame])
		offset.on_damaged(1, damage)
	)

	for i in range(30 * 20):
		frame += 1
		if frame == 1:
			player.on_combo(0)
			assert(offset.scores_tmp[0] == 0)
		if frame == 10:
			player.on_combo(1)
			assert(offset.scores_tmp[0] == 1)
		if frame == 20:
			player.on_combo(2)
			assert(offset.scores_tmp[0] == 5)
			assert(offset.score == 0)
		if frame == 30:
			player.on_combo(-1)
			assert(offset.scores_tmp[0] == 0)
			assert(offset.score == 0)
			assert(rival.hp == 995)
		if frame == 330:
			player.on_combo(0)
			assert(offset.scores_tmp[0] == 0)
		if frame == 340:
			player.on_combo(2)
			assert(offset.scores_tmp[0] == 4)
			assert(offset.score == 0)
		if frame == 350:
			player.on_combo(-1)
			assert(offset.scores_tmp[0] == 0)
			assert(offset.score == 4)
			assert(rival.hp == 995)
		if frame == 360:
			player.on_combo(0)
		if frame == 370:
			player.on_combo(1)
		if frame == 380:
			player.on_combo(-1)
		
		rival.process()


	assert(rival.hp == 995)
	assert(player.garbage == 9)
	assert(offset.score == 0)
	assert(offset.scores_tmp[0] == 0)
	assert(offset.scores_tmp[1] == 0)


	get_tree().quit()

# 	Donut.test_all_donuts_are_stopped()
# 	Donut.test_sort_donuts_by_y_descending()
# 	Donut.test_all_garbage_donuts_are_dropped()
# 	Donut.test_get_colliding_donut()
# 	Donut.test_move()
# 	Donut.test_get_around()
# 	Donut.test_clear_garbage_donuts()
	
# 	DonutsPair.test_donuts_pair()
# 	DonutsPair.test_sync_position()
# 	DonutsPair.test_rotation()
# 	DonutsPair.test_move()

# 	Cleaner.test_find_clearable_donuts()
# 	Cleaner.test_mapping_donuts_to_2d_array()
# 	Cleaner.test_donut_out_of_area()
# 	Cleaner.test_donut_grid_position()
# 	Cleaner.test_find_large_groups()

# 	Main.test_sum_of_squares()

# 	test_array_2d()


# func test_array_2d():
# 	var array_2d = Array2D.new_array_2d(Vector2(3, 4), -1)

# 	assert(Array2D.get_size(array_2d) == Vector2(3, 4))

# 	assert(Array2D.out_of_bounds(Vector2(-1, 0), array_2d) == true)
# 	assert(Array2D.out_of_bounds(Vector2(0, -1), array_2d) == true)
# 	assert(Array2D.out_of_bounds(Vector2(2, 3), array_2d) == false)
# 	assert(Array2D.out_of_bounds(Vector2(3, 3), array_2d) == true)
# 	assert(Array2D.out_of_bounds(Vector2(2, 4), array_2d) == true)

# 	Array2D.set_value(array_2d, Vector2(0, 0), 5)
# 	Array2D.set_value(array_2d, Vector2(2, 3), 10)

# 	assert(Array2D.get_value(array_2d, Vector2(0, 0)) == 5)
# 	assert(Array2D.get_value(array_2d, Vector2(2, 3)) == 10)
# 	assert(Array2D.get_value(array_2d, Vector2(1, 1)) == -1)

# 	assert(Array2D.get_position(array_2d, 5) == Vector2(0, 0))
# 	assert(Array2D.get_position(array_2d, 10) == Vector2(2, 3))
# 	assert(Array2D.get_position(array_2d, 100) == Vector2(-1, -1))

# 	assert(Array2D.warp_position(array_2d, Vector2(0, 0)) == Vector2(0, 0))
# 	assert(Array2D.warp_position(array_2d, Vector2(2, 3)) == Vector2(2, 3))
# 	assert(Array2D.warp_position(array_2d, Vector2(3, 3)) == Vector2(0, 3))
# 	assert(Array2D.warp_position(array_2d, Vector2(2, 4)) == Vector2(2, 0))

# 	assert(Array2D.move_value(array_2d, 5, Vector2(1, 0)) == true)
# 	assert(Array2D.move_value(array_2d, 10, Vector2(-1, 0)) == true)
# 	assert(Array2D.move_value(array_2d, 10, Vector2(0, 1)) == true)

# 	Array2D.set_value(array_2d, Vector2(1, 2), 20)
# 	assert(Array2D.move_value(array_2d, 20, Vector2(0, -1)) == true)
# 	assert(Array2D.get_position(array_2d, 20) == Vector2(1, 3))

# 	assert(Array2D.move_value(array_2d, 20, Vector2(0, 1)) == true)
# 	assert(Array2D.get_position(array_2d, 20) == Vector2(1, 2))

# 	assert(Array2D.move_value(array_2d, 20, Vector2(0, 1)) == true)
# 	assert(Array2D.get_position(array_2d, 20) == Vector2(1, 3))

# 	Array2D.set_value(array_2d, Vector2(1, 2), 30)

# 	assert(Array2D.move_value(array_2d, 30, Vector2(0, 1)) == false)
# 	assert(Array2D.get_value(array_2d, Vector2(1, 2)) == 30)

# 	assert(Array2D.move_value(array_2d, 30, Vector2(0, -1)) == false)
# 	assert(Array2D.get_value(array_2d, Vector2(1, 2)) == 30)

# 	assert(Array2D.move_value(array_2d, 30, Vector2(-1, 0)) == true)
# 	assert(Array2D.get_position(array_2d, 30) == Vector2(0, 2))

# 	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 0)) == 0)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(1, 0)) == 1)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(2, 0)) == 2)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 1)) == 3)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(1, 1)) == 4)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(2, 1)) == 5)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 2)) == 6)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(1, 2)) == 7)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(2, 2)) == 8)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 3)) == 9)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(1, 3)) == 10)
# 	assert(Array2D.vector2_to_value(array_2d, Vector2(2, 3)) == 11)

# 	assert(Array2D.value_to_vector2(array_2d, 0) == Vector2(0, 0))
# 	assert(Array2D.value_to_vector2(array_2d, 1) == Vector2(1, 0))
# 	assert(Array2D.value_to_vector2(array_2d, 2) == Vector2(2, 0))
# 	assert(Array2D.value_to_vector2(array_2d, 3) == Vector2(0, 1))
# 	assert(Array2D.value_to_vector2(array_2d, 4) == Vector2(1, 1))
# 	assert(Array2D.value_to_vector2(array_2d, 5) == Vector2(2, 1))
# 	assert(Array2D.value_to_vector2(array_2d, 6) == Vector2(0, 2))
# 	assert(Array2D.value_to_vector2(array_2d, 7) == Vector2(1, 2))
# 	assert(Array2D.value_to_vector2(array_2d, 8) == Vector2(2, 2))
# 	assert(Array2D.value_to_vector2(array_2d, 9) == Vector2(0, 3))
# 	assert(Array2D.value_to_vector2(array_2d, 10) == Vector2(1, 3))
# 	assert(Array2D.value_to_vector2(array_2d, 11) == Vector2(2, 3))

# 	assert(Array2D.get_position_value(array_2d, 5) == 1)
# 	assert(Array2D.get_position_value(array_2d, 10) == 4)
# 	assert(Array2D.get_position_value(array_2d, 30) == 6)
# 	assert(Array2D.get_position_value(array_2d, 20) == 10)
