class_name Loop
extends Node

var target_donut: Donut
var target_donut_freeze_count: int = 0


var donuts: Array[Donut] = []

signal game_over()

static var COLOR_NUMBER = 2
static var TARGET_DONUT_FREEZE_COUNT = 60
static var TARGET_DONUT_GRAVITY = 10
static var CLEAR_WAIT_TIME = 0.5

static var ACTIVE: bool = true

signal found_clearable_group(count: int)
signal cleared_donuts(count: int)

func _ready():
	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				donuts.append(Donut.new(-1))
				donuts.back().pos = Vector2(100 * x + 50, 100 * y + 50)
				donuts.back().sprite.visible = false


	target_donut = spawn_donut()

	await get_tree().create_timer(2.0).timeout
	setup_input()

	var score_board = ScoreBoard.new()
	add_child(score_board)
	self.found_clearable_group.connect(score_board.on_found_clearable_group)
	self.cleared_donuts.connect(func(count: int) -> void:
		score_board.render()
	)

	var spawn_garbage_timer = Timer.new()
	add_child(spawn_garbage_timer)
	spawn_garbage_timer.start(3.0)
	spawn_garbage_timer.timeout.connect(func() -> void:
		spawn_garbage(9)
	)


func setup_input() -> void:
	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if target_donut == null:
			return
		var delta = Donut.move(target_donut, direction * 100, donuts)
		if direction == Vector2.DOWN and delta == Vector2.ZERO:
			target_donut_freeze_count = TARGET_DONUT_FREEZE_COUNT
		Donut.render(target_donut)
	)

func spawn_garbage(count: int) -> void:
	var spawn_count = 0
	
	var y = 50
	while true:
		y -= 100
		var x_positions = [50, 150, 250, 350, 450, 550]
		x_positions.shuffle()
		for x in range(x_positions.size()):
			var donut = Donut.new(10)
			donut.pos = Vector2(x_positions[x], y)
			if Donut.get_colliding_donut(donut, donuts) != null:
				donut.queue_free()
				continue
			Donut.render(donut)
			add_child(donut)
			donuts.append(donut)
			spawn_count += 1

			if spawn_count >= count:
				return

func spawn_donut() -> Donut:
	var donut = Donut.new(randi() % COLOR_NUMBER)
	donut.pos = Vector2(350, 350)
	if Donut.get_colliding_donut(donut, donuts) != null:
		donut.queue_free()
		return null
	Donut.render(donut)
	add_child(donut)
	donuts.append(donut)
	return donut

func next_or_game_over() -> bool:
	target_donut = spawn_donut()
	if target_donut == null:
		emit_signal("game_over")
		set_process(false)
		return false
	return true

func target_donut_process() -> void:
	if target_donut == null:
		return
	if Donut.move(target_donut, Vector2(0, TARGET_DONUT_GRAVITY), donuts) == Vector2.ZERO:
		target_donut_freeze_count += 1
	else:
		target_donut_freeze_count = 0

	Donut.render(target_donut)

	if target_donut_freeze_count >= TARGET_DONUT_FREEZE_COUNT:
		target_donut = null

func donuts_process() -> void:
	for donut in donuts:
		if donut.value == -1:
			continue
		if donut == target_donut:
			continue
		donut.process(donuts)

static func all_donuts_are_stopped(target_donut: Donut, donuts: Array[Donut]) -> bool:
	for donut in donuts:
		if donut.value == -1:
			continue
		if donut == target_donut:
			continue
		if get_donut_at_position(donut.pos + Vector2.DOWN * 100, donuts) == null:
			return false
		if donut.freeze_count < Donut.FREEZE_COUNT:
			return false
		if donut.to_clear:
			return false
	return true

static func get_donut_at_position(pos: Vector2, donuts: Array[Donut]) -> Donut:
	for donut in donuts:
		if donut.pos == pos:
			return donut
	return null

static func copy_donuts_excluding_target(target_donut: Donut, donuts: Array[Donut]) -> Array[Donut]:
	var result: Array[Donut] = donuts.duplicate()
	if target_donut != null:
		result.erase(target_donut)
	return result

func _process(_delta: float) -> void:
	if target_donut == null:
		if ACTIVE:
			if not next_or_game_over():
				return
		else:
			if all_donuts_are_stopped(target_donut, donuts):
				if not next_or_game_over():
					return


	target_donut_process()

	donuts_process()

	if all_donuts_are_stopped(target_donut, donuts):
		var ret = Cleaner.find_clearable_donuts(copy_donuts_excluding_target(target_donut, donuts))
		var clearable_donuts = ret[0]
		var group_count = ret[1]
		for donut in clearable_donuts:
			donut.to_clear = true
		if clearable_donuts.size() > 0:
			var count = clearable_donuts.size()
			var timer = Timer.new()
			add_child(timer)
			timer.start(CLEAR_WAIT_TIME)
			timer.timeout.connect(func() -> void:
				for clearable_donut in clearable_donuts:
					donuts.erase(clearable_donut)
					clearable_donut.queue_free()
				timer.queue_free()
				emit_signal("cleared_donuts", count)
			)
		emit_signal("found_clearable_group", group_count)

static func test_all_donuts_are_stopped() -> void:
	var donuts: Array[Donut] = []
	var target_donut: Donut = null

	donuts.append(Donut.new(-1))
	donuts.back().pos = Vector2(500, 500)
	assert(all_donuts_are_stopped(target_donut, donuts) == true)

	target_donut = Donut.new(0)
	target_donut.pos = Vector2(500, 0)
	assert(all_donuts_are_stopped(target_donut, donuts) == true)
	
	donuts.append(target_donut)
	donuts.back().pos = Vector2(500, 400)
	target_donut = Donut.new(0)
	target_donut.pos = Vector2(500, 0)
	assert(all_donuts_are_stopped(target_donut, donuts) == false)

	donuts.back().freeze_count = Donut.FREEZE_COUNT
	assert(all_donuts_are_stopped(target_donut, donuts) == true)

	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(500, 300)
	donuts.back().freeze_count = Donut.FREEZE_COUNT
	assert(all_donuts_are_stopped(target_donut, donuts) == true)

	donuts.back().pos -= Vector2(0, 1)
	assert(all_donuts_are_stopped(target_donut, donuts) == false)

	donuts.back().pos += Vector2(0, 1)
	assert(all_donuts_are_stopped(target_donut, donuts) == true)

	donuts.back().to_clear = true
	assert(all_donuts_are_stopped(target_donut, donuts) == false)


	for donut in donuts:
		donut.queue_free()
	donuts.clear()
	target_donut.queue_free()
