class_name Test
extends Node

var all_donuts: Array[Donut] = []
var donut: Donut = null
var rival: Rival = Rival.new()
var frame_count: int = 0

func _ready() -> void:
	assert(Game.combo_to_score(0) == 0)
	assert(Game.combo_to_score(3) == 14)

	all_donuts.append(Donut.new(0))
	all_donuts.back().pos = Vector2(350, 350)

	donut = Donut.new(0)
	donut.pos = Vector2(250, 300)
	assert(Donut.move(donut, Vector2.RIGHT * 100, all_donuts) == Vector2(100, -50))
	assert(donut.pos == Vector2(350, 250))

	Donut.move(donut, Vector2.UP * 50, all_donuts)
	assert(Donut.move(donut, Vector2.DOWN * 100, all_donuts) == Vector2(0, 50))
	assert(donut.pos == Vector2(350, 250))

	
	donut.queue_free()
	for donut in all_donuts:
		donut.queue_free()
	all_donuts.clear()

	donut_move()

	donuts_pair_move()
	donuts_pair_rotation()

	array_2d()

	cleaner_find_large_groups()

	var next_colors = Game.NextColors.new()
	var initial_bag = next_colors.bag.duplicate()
	assert(next_colors.next_color() == initial_bag[0])
	assert(next_colors.next_color() == initial_bag[1])
	assert(next_colors.bag.size() == initial_bag.size() - 2)
	for i in range(10):
		next_colors.next_color()
	assert(next_colors.bag.size() == initial_bag.size() - 2 - 10)
	assert(next_colors.next_color() == initial_bag[12])
	assert(next_colors.bag.size() == initial_bag.size() - 2 - 10 - 1 + 16)
	next_colors.next_color()
	next_colors.next_color()
	assert(next_colors.next_color() == initial_bag[15])
	assert(next_colors.bag.size() == initial_bag.size() - 2 - 10 - 1 + 16 - 3)
	next_colors.queue_free()

	var garbage_count = Donut.spawn_garbage(13, all_donuts, self)
	assert(garbage_count == 13)
	assert(all_donuts.size() == 13)
	for i in range(all_donuts.size()):
		assert(all_donuts[i].value == 10)
		if i < 6:
			assert(all_donuts[i].pos.y == -50)
		elif i < 12:
			assert(all_donuts[i].pos.y == -150)
		else:
			assert(all_donuts[i].pos.y == -250)
	for donut in all_donuts:
		donut.queue_free()
	all_donuts.clear()

	assert(Donut.spawn_garbage(40, all_donuts, self) == 36)
	assert(all_donuts.size() == 36)
	for donut in all_donuts:
		donut.queue_free()
	all_donuts.clear()

	all_donuts.append(Donut.new(0))
	all_donuts[0].pos = Vector2(150, -50)
	assert(Donut.spawn_garbage(6, all_donuts, self) == 6)
	assert(all_donuts.back().pos.y == -150)
	var x_positions = [150, 250, 350, 450, 550, 650]
	for i in range(1, 6):
		assert(all_donuts[i].pos.y == -50)
		x_positions.erase(int(all_donuts[i].pos.x))
	assert(x_positions[0] == 150)
	for donut in all_donuts:
		donut.queue_free()
	all_donuts.clear()

	all_donuts.append(Donut.new(0))
	all_donuts[0].pos = Vector2(350, 450)

	all_donuts.append(Donut.new(0))
	all_donuts[1].pos = Vector2(450, 350)

	all_donuts.append(Donut.new(0))
	all_donuts[2].pos = Vector2(650, 650)

	all_donuts.append(Donut.new(0))
	all_donuts[3].pos = Vector2(550, 550)

	Donut.sort_donuts_by_y_descending(all_donuts)
	assert(all_donuts[0].pos.y == 650)
	assert(all_donuts[1].pos.y == 550)
	assert(all_donuts[2].pos.y == 450)
	assert(all_donuts[3].pos.y == 350)

	for donut in all_donuts:
		donut.queue_free()
	all_donuts.clear()


	add_child(rival)
	var reduced = 0
	assert(rival.reduce_hp(10) == 10)
	assert(rival.hp == Rival.HP - 10)
	assert(rival.frame_count == -60)

	rival.is_cool = false
	assert(rival.reduce_hp(10) == 0)
	assert(rival.hp == Rival.HP - 10)
	assert(rival.frame_count == -60)

	rival.queue_free()
	Rival.MAX_COMBO_CHOICES_ARRAY = [2]
	Rival.COOL_COUNT_TO_ONE_COMBO = 180
	Rival.ONE_COMBO_DURATION = 60
	rival = Rival.new()
	add_child(rival)

	for i in range(1200):
		frame_count += 1
		rival.process()
		if frame_count == 359:
			assert(rival.is_cool == true)
		if frame_count == 360:
			assert(rival.is_cool == false)
		if frame_count == 419:
			assert(rival.combo == 0)
		if frame_count == 420:
			assert(rival.combo == 1)
		if frame_count == 480:
			assert(rival.combo == 2)
		if frame_count == 539:
			assert(rival.combo == 2)
		if frame_count == 540:
			assert(rival.combo == 0)
			assert(rival.is_cool == true)

		if frame_count == 899:
			assert(rival.is_cool == true)
		if frame_count == 900:
			assert(rival.is_cool == false)
		if frame_count == 959:
			assert(rival.combo == 0)
		if frame_count == 960:
			assert(rival.combo == 1)
		if frame_count == 1020:
			assert(rival.combo == 2)
		if frame_count == 1079:
			assert(rival.combo == 2)
		if frame_count == 1080:
			assert(rival.combo == 0)
			assert(rival.is_cool == true)


	rival.queue_free()
	Rival.MAX_COMBO_CHOICES_ARRAY = [1, 2, 3]
	rival = Rival.new()
	add_child(rival)
	rival.signal_debug.connect(func(msg: String) -> void:
		pass
		# print("[Rival] ", msg, " @ frame ", frame_count)
	)
	frame_count = 0

	for i in range(60 * 30):
		frame_count += 1
		rival.process()
	rival.queue_free()

	get_tree().quit()


static func donuts_pair_move():
	var donuts: Array[Donut] = []
	var donuts_pair: DonutsPair
	donuts_pair = DonutsPair.new(Vector2(300, 300), [0, 1])
	assert(DonutsPair.move(donuts_pair, Vector2(100, 0), donuts) == Vector2(100, 0))
	assert(donuts_pair.elements[0].pos == Vector2(400, 300))
	assert(donuts_pair.elements[1].pos == Vector2(400, 200))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(300, 300), [0, 1])
	assert(DonutsPair.move(donuts_pair, Vector2(0, -100), donuts) == Vector2(0, -100))
	assert(donuts_pair.elements[0].pos == Vector2(300, 200))
	assert(donuts_pair.elements[1].pos == Vector2(300, 100))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(500, 500), [0, 1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(500, 250)
	assert(DonutsPair.move(donuts_pair, Vector2(0, -100), donuts) == Vector2(0, -50))
	assert(donuts_pair.elements[0].pos == Vector2(500, 450))
	assert(donuts_pair.elements[1].pos == Vector2(500, 350))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()

	donuts_pair = DonutsPair.new(Vector2(500, 500), [0, 1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(500, 650)
	assert(DonutsPair.move(donuts_pair, Vector2(0, 100), donuts) == Vector2(0, 50))
	assert(donuts_pair.elements[0].pos == Vector2(500, 550))
	assert(donuts_pair.elements[1].pos == Vector2(500, 450))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(500, 500), [0, 1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 500)
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 400)
	assert(DonutsPair.move(donuts_pair, Vector2(-100, 0), donuts) == Vector2.ZERO)
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()

	donuts_pair = DonutsPair.new(Vector2(500, 500), [0, 1])
	DonutsPair.rotation(donuts_pair, donuts)

	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(500, 300)
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(600, 350)
	assert(DonutsPair.move(donuts_pair, Vector2(0, -100), donuts) == Vector2(0, -50))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()

	donuts_pair = DonutsPair.new(Vector2(500, 500), [0, 1])
	DonutsPair.rotation(donuts_pair, donuts)

	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(500, 650)
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(600, 700)
	assert(DonutsPair.move(donuts_pair, Vector2(0, 100), donuts) == Vector2(0, 50))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


static func donuts_pair_rotation():
	var donuts: Array[Donut] = []
	var donuts_pair: DonutsPair

	donuts_pair = DonutsPair.new(Vector2(300, 300), [0, 1])
	DonutsPair.rotation(donuts_pair, donuts)
	assert(donuts_pair.elements[0].pos == Vector2(300, 300))
	assert(donuts_pair.elements[1].pos == Vector2(400, 300))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()
	

	donuts_pair = DonutsPair.new(Vector2(300, 300), [0, 1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 300)
	DonutsPair.rotation(donuts_pair, donuts)
	assert(donuts_pair.elements[0].pos == Vector2(200, 300))
	assert(donuts_pair.elements[1].pos == Vector2(300, 300))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(300, 300), [0, 1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 300)
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(200, 300)
	DonutsPair.rotation(donuts_pair, donuts)
	assert(donuts_pair.elements[0].pos == Vector2(300, 200))
	assert(donuts_pair.elements[1].pos == Vector2(300, 300))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(300, 300), [0, 1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 350)
	DonutsPair.rotation(donuts_pair, donuts)
	assert(donuts_pair.elements[0].pos == Vector2(300, 250))
	assert(donuts_pair.elements[1].pos == Vector2(400, 250))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()

	donuts_pair = DonutsPair.new(Vector2(300, 300), [0, 1])
	DonutsPair.rotation(donuts_pair, donuts)
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(300, 450)
	DonutsPair.rotation(donuts_pair, donuts)
	assert(donuts_pair.elements[0].pos == Vector2(300, 250))
	assert(donuts_pair.elements[1].pos == Vector2(300, 350))
	donuts_pair.elements[0].queue_free()
	donuts_pair.elements[1].queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()

static func donut_move() -> void:
	var donuts: Array[Donut] = []
	var donut: Donut
	donut = Donut.new(0)
	donuts.append(donut)
	donut.pos = Vector2(100, 100)
	assert(Donut.move(donut, Vector2(100, 0), donuts) == Vector2(100, 0))
	assert(donut.pos == Vector2(200, 100))

	donut.pos = Vector2(300, 300)
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(300, 450)
	assert(Donut.move(donut, Vector2(0, 100), donuts) == Vector2(0, 50))
	assert(donut.pos == Vector2(300, 350))

	donut.pos = Vector2(500, 500)
	donuts.back().pos = Vector2(600, 550)
	assert(Donut.move(donut, Vector2(100, 0), donuts) == Vector2(100, -50))
	assert(donut.pos == Vector2(600, 450))

	donut.pos = Vector2(500, 500)
	donuts.back().pos = Vector2(600, 500)
	assert(Donut.move(donut, Vector2(100, 0), donuts) == Vector2.ZERO)
	assert(donut.pos == Vector2(500, 500))

	for d in donuts:
		d.queue_free()
	donuts.clear()

func array_2d():
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
	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 1)) == 3)
	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 2)) == 6)
	assert(Array2D.vector2_to_value(array_2d, Vector2(0, 3)) == 9)
	assert(Array2D.vector2_to_value(array_2d, Vector2(1, 3)) == 10)
	assert(Array2D.vector2_to_value(array_2d, Vector2(2, 3)) == 11)

	assert(Array2D.get_position_value(array_2d, 5) == 1)
	assert(Array2D.get_position_value(array_2d, 10) == 4)
	assert(Array2D.get_position_value(array_2d, 20) == 10)


static func cleaner_find_large_groups():
	var input = [
		[0, 1, 0, 0],
		[2, 2, 2, 0],
		[1, 2, 1, 3],
		[3, 3, 3, 10],
		[-1, -1, 10, 10],
	]
	var ret = Cleaner.find_large_groups(input, 3)
	assert(ret[0] == [
		[0, 0, 1, 1],
		[1, 1, 1, 1],
		[0, 1, 0, 0],
		[1, 1, 1, 1],
		[0, 0, 1, 0],
	])
	input = [
		[1, 1, 1],
		[1, 1, 1],
		[1, 1, 1],
	]
	ret = Cleaner.find_large_groups(input, 1)
	assert(ret[0] == [
		[1, 1, 1],
		[1, 1, 1],
		[1, 1, 1],
	])
	input = [
		[-1, 1],
		[1, -1],
	]
	ret = Cleaner.find_large_groups(input, 1)
	assert(ret[0] == [
		[0, 1],
		[1, 0],
	])
	assert(ret[1] == 2)