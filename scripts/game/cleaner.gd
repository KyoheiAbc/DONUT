class_name Cleaner
extends Node

static var GROUP_SIZE_TO_CLEAR = 3

static func find_clearable_donuts(donuts: Array[Donut]) -> Array[Donut]:
	var input = create_2d_array(Vector2(6, 12), -1)

	for donut in donuts:
		if donut.value == -1:
			continue
		input[donut.grid_pos().y][donut.grid_pos().x] = donut.value

	var to_clear = find_large_groups(input, GROUP_SIZE_TO_CLEAR)

	var result: Array[Donut] = []
	for donut in donuts:
		if donut.value == -1:
			continue
		if to_clear[donut.grid_pos().y][donut.grid_pos().x] == 1:
			result.append(donut)
	return result

static func find_large_groups(input: Array, find_threshold: int) -> Array:
	var size = Vector2(input[0].size(), input.size())
	var result = create_2d_array(size, 0)
	var visited = create_2d_array(size, false)

	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]

	for y in range(size.y):
		for x in range(size.x):
			var stack: Array[Vector2] = [Vector2(x, y)]
			var group: Array[Vector2] = []

			while stack.size() > 0:
				var pos = stack.pop_back()
				visited[pos.y][pos.x] = true
				group.append(pos)

				for dir in directions:
					var new_pos = pos + dir

					if out_of_bounds(new_pos, size):
						continue

					if visited[new_pos.y][new_pos.x]:
						continue

					if input[new_pos.y][new_pos.x] == input[y][x]:
						stack.append(new_pos)

			if group.size() >= find_threshold:
				for pos in group:
					result[pos.y][pos.x] = 1

	return result

static func out_of_bounds(pos: Vector2, size: Vector2) -> bool:
	return pos.x < 0 or pos.x >= size.x or pos.y < 0 or pos.y >= size.y

static func create_2d_array(size: Vector2, initial_value) -> Array:
	var result: Array = []
	for y in range(size.y):
		result.append([])
		for x in range(size.x):
			result[y].append(initial_value)
	return result
