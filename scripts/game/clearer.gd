class_name Clearer
extends Node

signal cleared(count: int)
signal clear_donuts_detected

var wait_count: int = 0
var combo: int = 0
var clear_text_count: int = 0
var label: Label

func _init() -> void:
	label = Label.new()
	add_child(label)
	label.position = Vector2(1400, 50)
	label.add_theme_font_size_override("font_size", 96)
	label.add_theme_color_override("font_color", Color(1, 1, 0))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _process(_delta: float) -> void:
	if combo >= 1:
		label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
		label.text = "%dx COMBO!" % combo
		clear_text_count = 0
	else:
		clear_text_count += 1
		label.add_theme_color_override("font_color", Color(1, 1, 0, max(0, 1 - clear_text_count / 60.0)))
		if clear_text_count > 60:
			label.text = ""

func process(donuts: Array[Donut]) -> void:
	if should_clear(donuts):
		wait_count += 1
		if wait_count > 60:
			clear_marked_donuts(donuts)
			wait_count = 0
			combo += 1
		return

	wait_count = 0

	if not all_donuts_stopped(donuts.back(), donuts):
		return

	var size = Vector2(6, 12)
	var grid = []
	for y in range(size.y):
		grid.append([])
		for x in range(size.x):
			grid[y].append(-1)
	for donut in donuts:
		if donut.value == -1:
			continue
		if donut.freeze_count < 30:
			continue
		var grid_pos = Vector2(int(donut.pos.x / 100), int(donut.pos.y / 100))
		if grid_pos.x < 0 or grid_pos.x >= size.x or grid_pos.y < 0 or grid_pos.y >= size.y:
			continue
		grid[grid_pos.y][grid_pos.x] = donut.value

	var to_clear = find_large_groups(grid, 3)

	for y in range(size.y):
		for x in range(size.x):
			if to_clear[y][x] == 1:
				for donut in donuts:
					var grid_pos = Vector2(int(donut.pos.x / 100), int(donut.pos.y / 100))
					if grid_pos.x == x and grid_pos.y == y:
						donut.to_clear = true

func all_donuts_stopped(target_donut: Donut, donuts: Array[Donut]) -> bool:
	for donut in donuts:
		if donut == target_donut:
			continue
		if donut.value == -1:
			continue
		if donut.freeze_count < 30:
			return false
	return true

func should_clear(donuts: Array[Donut]) -> bool:
	for donut in donuts:
		if donut.to_clear:
			return true
	return false

func clear_marked_donuts(donuts: Array[Donut]) -> void:
	var count = 0
	var to_remove = []
	for donut in donuts:
		if donut.to_clear:
			to_remove.append(donut)
	for donut in to_remove:
		count += 1
		donuts.erase(donut)
		donut.queue_free()
	emit_signal("cleared", count)

func find_large_groups(input: Array, find_threshold: int) -> Array:
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

	var detected: bool = false
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
					detected = true
					for pos in group:
						result[pos.y][pos.x] = 1
	if detected:
		emit_signal("clear_donuts_detected")
	else:
		combo = 0

	return result
