class_name Clearer
extends Node


static func clean(donuts: Array[Donut]) -> int:
	var size = Vector2(6, 12)
	var grid = []
	for y in range(size.y):
		grid.append([])
		for x in range(size.x):
			grid[y].append(-1)
	for donut in donuts:
		if donut.value == -1:
			continue
		if donut.freeze_count < 60:
			continue
		var grid_pos = Vector2(int(donut.pos.x / 100), int(donut.pos.y / 100))
		if grid_pos.x < 0 or grid_pos.x >= size.x or grid_pos.y < 0 or grid_pos.y >= size.y:
			continue
		grid[grid_pos.y][grid_pos.x] = donut.value

	var to_clear = find_large_groups(grid, 3)

	var cleared_count = 0
	for y in range(size.y):
		for x in range(size.x):
			if to_clear[y][x] == 1:
				for donut in donuts:
					var grid_pos = Vector2(int(donut.pos.x / 100), int(donut.pos.y / 100))
					if grid_pos.x == x and grid_pos.y == y:
						cleared_count += 1
						donuts.erase(donut)
						donut.queue_free()

	return cleared_count

static func find_large_groups(input: Array, find_threshold: int) -> Array:
	var size = Vector2(input[0].size(), input.size())
	var visited = []
	var result = []
	for y in range(size.y):
		visited.append([])
		result.append([])
		for x in range(size.x):
			visited[y].append(false)
			result[y].append(0)

	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]

	for y in range(size.y):
		for x in range(size.x):
			if not visited[y][x]:
				var stack = [Vector2(x, y)]
				var group = []
				var value = input[y][x]
				if value == -1:
					visited[y][x] = true
					continue
				while stack.size() > 0:
					var pos = stack.pop_back()
					if visited[pos.y][pos.x]:
						continue
					visited[pos.y][pos.x] = true
					group.append(pos)
					for dir in directions:
						var new_pos = pos + dir
						if new_pos.x >= 0 and new_pos.x < size.x and new_pos.y >= 0 and new_pos.y < size.y:
							if input[new_pos.y][new_pos.x] == value and not visited[new_pos.y][new_pos.x]:
								stack.append(new_pos)
				if group.size() >= find_threshold:
					for pos in group:
						result[pos.y][pos.x] = 1

	return result