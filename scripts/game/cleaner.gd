class_name Cleaner
extends Node

static var GROUP_SIZE_TO_CLEAR = 4
const CLEAR_WAIT_COUNT = 30

var clearable_donuts: Array[Donut] = []
var timer: Timer = Timer.new()

signal signal_cleared()

func _init():
	add_child(timer)
	timer.wait_time = CLEAR_WAIT_COUNT / 60.0
	timer.one_shot = true
	timer.timeout.connect(func() -> void:
		if clearable_donuts.size() == 0:
			return
		for donut in clearable_donuts:
			donut.queue_free()
		clearable_donuts.clear()
		emit_signal("signal_cleared")
	)

func process(all_donuts: Array[Donut]) -> bool:
	if timer.is_stopped():
		clearable_donuts = find_clearable_donuts(all_donuts, GROUP_SIZE_TO_CLEAR)[0]
		if clearable_donuts.size() > 0:
			for donut in clearable_donuts:
				if donut.value == 10:
					continue
				donut.sprite.scale = Vector2(0.7, 1.3)
				all_donuts.erase(donut)

				var around_garbage = donut.get_around_garbage(all_donuts)
				for garbage in around_garbage:
					all_donuts.erase(garbage)
					clearable_donuts.append(garbage)

			timer.start()
			return true
		else:
			return false
	return false


static func find_clearable_donuts(donuts: Array[Donut], group_size_to_clear: int):
	var ret = mapping_donuts_to_2d_array(donuts)
	var donuts_map = ret[1]
	var founded = find_large_groups(ret[0], group_size_to_clear)

	var clearable_donuts: Array[Donut] = []
	for y in range(founded[0].size()):
		for x in range(founded[0][y].size()):
			if founded[0][y][x] == 1 and donuts_map[y][x] != null:
				clearable_donuts.append(donuts_map[y][x])

	return [clearable_donuts, founded[1]]

static func mapping_donuts_to_2d_array(donuts: Array[Donut]):
	var result = Array2D.new_array_2d(Vector2(8, 16), -1)
	var donuts_map = Array2D.new_array_2d(Vector2(8, 16), null)
	for donut in donuts:
		if donut_out_of_area(donut):
			continue
		var grid_pos = donut_grid_position(donut)
		result[grid_pos.y][grid_pos.x] = donut.value
		donuts_map[grid_pos.y][grid_pos.x] = donut
	return [result, donuts_map]


static func donut_out_of_area(donut: Donut) -> bool:
	return donut.pos.x < 50 or donut.pos.x > 750 or donut.pos.y < 50 or donut.pos.y > 1550


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
	input = [
		[1, 1, 1],
		[1, 1, 1],
		[1, 1, 1],
	]
	ret = find_large_groups(input, 1)
	assert(ret[0] == [
		[1, 1, 1],
		[1, 1, 1],
		[1, 1, 1],
	])
	input = [
		[-1, 1],
		[1, -1],
	]
	ret = find_large_groups(input, 1)
	assert(ret[0] == [
		[0, 1],
		[1, 0],
	])
	assert(ret[1] == 2)

static func find_large_groups(input: Array, find_threshold: int):
	var size = Vector2(input[0].size(), input.size())
	var result = Array2D.new_array_2d(size, 0)
	var visited = Array2D.new_array_2d(size, false)

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
					group.pop_back()
					continue
				if input[pos.y][pos.x] >= 10:
					group.pop_back()
					continue

				for dir in directions:
					var new_pos = pos + dir

					if Array2D.out_of_bounds(new_pos, input):
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
