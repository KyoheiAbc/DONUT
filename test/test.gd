class_name Test
extends Node

func _ready():
	Donut.test_all_donuts_are_stopped()
	Donut.test_sort_donuts_by_y_descending()
	Donut.test_all_garbage_donuts_are_dropped()
	Donut.test_get_colliding_donut()
	Donut.test_move()
	
	DonutsPair.test_donuts_pair()
	DonutsPair.test_sync_position()
	DonutsPair.test_rotation()
	DonutsPair.test_move()

	Cleaner.test_find_clearable_donuts()
	Cleaner.test_mapping_donuts_to_2d_array()
	Cleaner.test_donut_out_of_area()
	Cleaner.test_donut_grid_position()
	Cleaner.test_find_large_groups()

	Main.test_sum_of_squares()

	test_array_2d()

	# test_score_board()
	# self.test_score_board_completed.connect(func() -> void:
	# 	print("All tests passed!")
	# 	get_tree().quit()
	# )
	get_tree().quit()

# func _process(delta: float) -> void:
# 	print("Test running, current time: " + str(Time.get_ticks_msec()))

func test_array_2d():
	var array_2d = Array2D.new_array_2d(Vector2(3, 4), -1)

	assert(Array2D.get_size(array_2d) == Vector2(3, 4))

	assert(Array2D.out_of_bounds(Vector2(-1, 0), array_2d) == true)
	assert(Array2D.out_of_bounds(Vector2(0, -1), array_2d) == true)
	assert(Array2D.out_of_bounds(Vector2(2, 3), array_2d) == false)
	assert(Array2D.out_of_bounds(Vector2(3, 3), array_2d) == true)
	assert(Array2D.out_of_bounds(Vector2(2, 4), array_2d) == true)

	Array2D.set_value(array_2d, Vector2(0, 0), 5)
	Array2D.set_value(array_2d, Vector2(2, 3), 10)

	assert(Array2D.get_value(array_2d, Vector2(0, 0)) == 5)
	assert(Array2D.get_value(array_2d, Vector2(2, 3)) == 10)
	assert(Array2D.get_value(array_2d, Vector2(1, 1)) == -1)

	assert(Array2D.get_position(array_2d, 5) == Vector2(0, 0))
	assert(Array2D.get_position(array_2d, 10) == Vector2(2, 3))
	assert(Array2D.get_position(array_2d, 100) == Vector2(-1, -1))

	assert(Array2D.warp_position(array_2d, Vector2(0, 0)) == Vector2(0, 0))
	assert(Array2D.warp_position(array_2d, Vector2(2, 3)) == Vector2(2, 3))
	assert(Array2D.warp_position(array_2d, Vector2(3, 3)) == Vector2(0, 3))
	assert(Array2D.warp_position(array_2d, Vector2(2, 4)) == Vector2(2, 0))

	assert(Array2D.move_value(array_2d, 5, Vector2(1, 0)) == true)
	assert(Array2D.move_value(array_2d, 10, Vector2(-1, 0)) == true)
	assert(Array2D.move_value(array_2d, 10, Vector2(0, 1)) == true)

	Array2D.set_value(array_2d, Vector2(1, 2), 20)
	assert(Array2D.move_value(array_2d, 20, Vector2(0, -1)) == true)
	assert(Array2D.get_position(array_2d, 20) == Vector2(1, 3))

	assert(Array2D.move_value(array_2d, 20, Vector2(0, 1)) == true)
	assert(Array2D.get_position(array_2d, 20) == Vector2(1, 2))

	assert(Array2D.move_value(array_2d, 20, Vector2(0, 1)) == true)
	assert(Array2D.get_position(array_2d, 20) == Vector2(1, 3))

	Array2D.set_value(array_2d, Vector2(1, 2), 30)

	assert(Array2D.move_value(array_2d, 30, Vector2(0, 1)) == false)
	assert(Array2D.get_value(array_2d, Vector2(1, 2)) == 30)

	assert(Array2D.move_value(array_2d, 30, Vector2(0, -1)) == false)
	assert(Array2D.get_value(array_2d, Vector2(1, 2)) == 30)

	assert(Array2D.move_value(array_2d, 30, Vector2(-1, 0)) == true)
	assert(Array2D.get_position(array_2d, 30) == Vector2(0, 2))

	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 0)) == 0)
	assert(Array2D.vector2_to_value(array_2d, Vector2(1, 0)) == 1)
	assert(Array2D.vector2_to_value(array_2d, Vector2(2, 0)) == 2)
	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 1)) == 3)
	assert(Array2D.vector2_to_value(array_2d, Vector2(1, 1)) == 4)
	assert(Array2D.vector2_to_value(array_2d, Vector2(2, 1)) == 5)
	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 2)) == 6)
	assert(Array2D.vector2_to_value(array_2d, Vector2(1, 2)) == 7)
	assert(Array2D.vector2_to_value(array_2d, Vector2(2, 2)) == 8)
	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 3)) == 9)
	assert(Array2D.vector2_to_value(array_2d, Vector2(1, 3)) == 10)
	assert(Array2D.vector2_to_value(array_2d, Vector2(2, 3)) == 11)

	assert(Array2D.value_to_vector2(array_2d, 0) == Vector2(0, 0))
	assert(Array2D.value_to_vector2(array_2d, 1) == Vector2(1, 0))
	assert(Array2D.value_to_vector2(array_2d, 2) == Vector2(2, 0))
	assert(Array2D.value_to_vector2(array_2d, 3) == Vector2(0, 1))
	assert(Array2D.value_to_vector2(array_2d, 4) == Vector2(1, 1))
	assert(Array2D.value_to_vector2(array_2d, 5) == Vector2(2, 1))
	assert(Array2D.value_to_vector2(array_2d, 6) == Vector2(0, 2))
	assert(Array2D.value_to_vector2(array_2d, 7) == Vector2(1, 2))
	assert(Array2D.value_to_vector2(array_2d, 8) == Vector2(2, 2))
	assert(Array2D.value_to_vector2(array_2d, 9) == Vector2(0, 3))
	assert(Array2D.value_to_vector2(array_2d, 10) == Vector2(1, 3))
	assert(Array2D.value_to_vector2(array_2d, 11) == Vector2(2, 3))

	assert(Array2D.get_position_value(array_2d, 5) == 1)
	assert(Array2D.get_position_value(array_2d, 10) == 4)
	assert(Array2D.get_position_value(array_2d, 30) == 6)
	assert(Array2D.get_position_value(array_2d, 20) == 10)

signal test_score_board_completed

func test_score_board() -> void:
	var score_board = ScoreBoard.new()
	add_child(score_board)
		
	assert(score_board.combo == 0)
	assert(score_board.combo_label.text == "")
	assert(score_board.combo_stop_timer.is_stopped())

	score_board.on_found_clearable_group(3)
	assert(score_board.combo == 3)
	assert(score_board.combo_label.text == "")
	assert(score_board.combo_stop_timer.is_stopped())

	score_board.render()
	assert(score_board.combo == 3)
	assert(score_board.combo_label.text == "3 COMBO!")
	assert(score_board.combo_stop_timer.is_stopped())

	score_board.on_found_clearable_group(2)
	assert(score_board.combo == 5)
	assert(score_board.combo_label.text == "3 COMBO!")
	assert(score_board.combo_stop_timer.is_stopped())

	score_board.render()
	assert(score_board.combo == 5)
	assert(score_board.combo_label.text == "5 COMBO!")
	assert(score_board.combo_stop_timer.is_stopped())

	score_board.on_found_clearable_group(0)
	assert(score_board.combo == 5)
	assert(score_board.combo_label.text == "5 COMBO!")
	assert(not score_board.combo_stop_timer.is_stopped())
	await get_tree().create_timer(ScoreBoard.COMBO_STOP_TIME - 0.1).timeout
	assert(score_board.combo == 5)
	await get_tree().create_timer(0.2).timeout
	assert(score_board.combo == 0)

	score_board.on_found_clearable_group(2)
	assert(score_board.combo == 2)
	await get_tree().create_timer(ScoreBoard.COMBO_STOP_TIME - 0.1).timeout
	assert(score_board.combo == 2)
	score_board.on_found_clearable_group(1)
	assert(score_board.combo == 3)
	assert(score_board.combo_stop_timer.is_stopped())

	score_board.on_found_clearable_group(0)
	assert(score_board.combo == 3)
	await get_tree().create_timer(ScoreBoard.COMBO_STOP_TIME - 0.3).timeout
	assert(score_board.combo == 3)
	score_board.on_found_clearable_group(0)
	score_board.on_found_clearable_group(0)
	await get_tree().create_timer(0.1).timeout
	assert(score_board.combo == 3)
	await get_tree().create_timer(0.3).timeout
	assert(score_board.combo == 0)

	score_board.queue_free()

	emit_signal("test_score_board_completed")