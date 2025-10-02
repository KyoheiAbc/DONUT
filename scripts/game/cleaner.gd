class_name Cleaner
extends Node

static var GROUP_SIZE_TO_CLEAR = 3


static func test_find_clearable_donuts():
	var donuts: Array[Donut] = []
	donuts.append(Donut.new(1))
	donuts.back().pos = Vector2(150, 250)

	donuts.append(Donut.new(1))
	donuts.back().pos = Vector2(250, 250)

	donuts.append(Donut.new(1))
	donuts.back().pos = Vector2(350, 250)

	donuts.append(Donut.new(2))
	donuts.back().pos = Vector2(150, 350)

	donuts.append(Donut.new(2))
	donuts.back().pos = Vector2(250, 350)

	donuts.append(Donut.new(3))
	donuts.back().pos = Vector2(650, 1550)

	var clearable = find_clearable_donuts(donuts)
	assert(clearable[0].size() == 3)
	assert(clearable[0].has(donuts[0]))
	assert(clearable[0].has(donuts[1]))
	assert(clearable[0].has(donuts[2]))

	assert(clearable[1] == 1)

	for d in donuts:
		d.queue_free()

static func find_clearable_donuts(donuts: Array[Donut]):
	var ret = mapping_donuts_to_2d_array(donuts)
	var donuts_map = ret[1]
	var founded = find_large_groups(ret[0], GROUP_SIZE_TO_CLEAR)

	var clearable_donuts: Array[Donut] = []
	for y in range(founded[0].size()):
		for x in range(founded[0][y].size()):
			if founded[0][y][x] == 1 and donuts_map[y][x] != null:
				clearable_donuts.append(donuts_map[y][x])

	return [clearable_donuts, founded[1]]

static func test_mapping_donuts_to_2d_array():
	var donuts: Array[Donut] = []
	donuts.append(Donut.new(1))
	donuts.back().pos = Vector2(150, 250)

	donuts.append(Donut.new(2))
	donuts.back().pos = Vector2(150, 1600)

	donuts.append(Donut.new(3))
	donuts.back().pos = Vector2(650, 1550)

	var expected = create_2d_array(Vector2(8, 16), -1)
	expected[2][1] = 1
	expected[15][6] = 3

	var results = mapping_donuts_to_2d_array(donuts)
	assert(results[0] == expected)

	assert(results[1][2][1] == donuts[0])
	assert(results[1][15][1] == null)
	assert(results[1][15][6] == donuts[2])
	
	for d in donuts:
		d.queue_free()


static func mapping_donuts_to_2d_array(donuts: Array[Donut]):
	var result = create_2d_array(Vector2(8, 16), -1)
	var donuts_map = create_2d_array(Vector2(8, 16), null)
	for donut in donuts:
		if donut_out_of_area(donut):
			continue
		var grid_pos = donut_grid_position(donut)
		result[grid_pos.y][grid_pos.x] = donut.value
		donuts_map[grid_pos.y][grid_pos.x] = donut
	return [result, donuts_map]

static func test_donut_out_of_area():
	var donut = Donut.new(0)
	donut.pos = Vector2(50, 49)
	assert(donut_out_of_area(donut) == true)
	donut.queue_free()

	donut = Donut.new(0)
	donut.pos = Vector2(750, 1550)
	assert(donut_out_of_area(donut) == false)
	donut.queue_free()

static func donut_out_of_area(donut: Donut) -> bool:
	return donut.pos.x < 50 or donut.pos.x > 750 or donut.pos.y < 50 or donut.pos.y > 1550

static func test_donut_grid_position():
	var donut = Donut.new(0)
	donut.pos = Vector2(50, 50)
	assert(donut_grid_position(donut) == Vector2i(0, 0))

	donut.pos = Vector2(750, 1550)
	assert(donut_grid_position(donut) == Vector2i(7, 15))
	donut.queue_free()


static func donut_grid_position(donut: Donut) -> Vector2i:
	var x = int(donut.pos.x / 100)
	var y = int(donut.pos.y / 100)
	return Vector2i(x, y)

static func test_find_large_groups():
	var input = [
		[0, 1, 0, 0],
		[2, 2, 2, 0],
		[1, 2, 1, 3],
		[3, 3, 3, -1],
		[-1, -1, -1, -1],
	]
	var ret = find_large_groups(input, 3)
	assert(ret[0] == [
		[0, 0, 1, 1],
		[1, 1, 1, 1],
		[0, 1, 0, 0],
		[1, 1, 1, 0],
		[0, 0, 0, 0],
	])
	assert(ret[1] == 3)


static func find_large_groups(input: Array, find_threshold: int):
	var size = Vector2(input[0].size(), input.size())
	var result = create_2d_array(size, 0)
	var visited = create_2d_array(size, false)

	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]

	var group_count = 0
	for y in range(size.y):
		for x in range(size.x):
			var stack: Array[Vector2] = [Vector2(x, y)]
			var group: Array[Vector2] = []

			while stack.size() > 0:
				var pos = stack.pop_back()
				visited[pos.y][pos.x] = true
				group.append(pos)

				if input[pos.y][pos.x] == -1:
					continue

				for dir in directions:
					var new_pos = pos + dir

					if out_of_bounds(new_pos, input):
						continue

					if visited[new_pos.y][new_pos.x]:
						continue

					if input[new_pos.y][new_pos.x] == input[y][x]:
						stack.append(new_pos)

			if group.size() >= find_threshold:
				group_count += 1
				for pos in group:
					result[pos.y][pos.x] = 1

	return [result, group_count]

static func test_out_of_bounds():
	var array = create_2d_array(Vector2(6, 12), 0)
	assert(out_of_bounds(Vector2(0, 0), array) == false)
	assert(out_of_bounds(Vector2(5, 11), array) == false)
	assert(out_of_bounds(Vector2(6, 0), array) == true)
		

static func out_of_bounds(pos: Vector2, array: Array) -> bool:
	var size = Vector2(array[0].size(), array.size())
	return pos.x < 0 or pos.x >= size.x or pos.y < 0 or pos.y >= size.y

static func test_create_2d_array():
	var array = create_2d_array(Vector2(3, 4), 5)
	assert(array.size() == 4)
	assert(array[0].size() == 3)
	assert(array[0][0] == 5)
	assert(array[3][2] == 5)

static func create_2d_array(size: Vector2, initial_value) -> Array:
	var result: Array = []
	for y in range(size.y):
		result.append([])
		for x in range(size.x):
			result[y].append(initial_value)
	return result
