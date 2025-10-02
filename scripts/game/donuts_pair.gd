class_name DonutsPair
extends Node

var elements: Array[Donut]
var child_relative_pos: Array[Vector2] = [Vector2.UP * 100, Vector2.RIGHT * 100, Vector2.DOWN * 100, Vector2.LEFT * 100]

var freeze_count: int = 0
static var FREEZE_COUNT = 60
static var GRAVITY = 10

static func test_donuts_pair():
	var donuts_pair = DonutsPair.new(Vector2(300, 300))
	assert(donuts_pair.elements.size() == 2)
	assert(donuts_pair.elements[0].pos == Vector2(300, 300))
	assert(donuts_pair.elements[1].pos == Vector2(300, 200))

	donuts_pair.queue_free()


func _init(pos: Vector2) -> void:
	elements = [Donut.new(randi() % Game.COLOR_NUMBER), Donut.new(randi() % Game.COLOR_NUMBER)]
	add_child(elements[0])
	add_child(elements[1])
	elements[0].pos = pos
	elements[1].pos = pos + child_relative_pos[0]

func process(all_donuts: Array[Donut]) -> void:
	if DonutsPair.move(self, Vector2.DOWN * GRAVITY, all_donuts) == Vector2.ZERO:
		freeze_count += 1
	else:
		freeze_count = 0
	

static func test_move():
	var donuts: Array[Donut] = []
	var donuts_pair: DonutsPair
	donuts_pair = DonutsPair.new(Vector2(300, 300))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])
	assert(move(donuts_pair, Vector2(100, 0), donuts) == Vector2(100, 0))
	assert(donuts_pair.elements[0].pos == Vector2(400, 300))
	assert(donuts_pair.elements[1].pos == Vector2(400, 200))
	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(300, 300))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])
	assert(move(donuts_pair, Vector2(0, -100), donuts) == Vector2(0, -100))
	assert(donuts_pair.elements[0].pos == Vector2(300, 200))
	assert(donuts_pair.elements[1].pos == Vector2(300, 100))
	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(500, 500))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(500, 250)
	assert(move(donuts_pair, Vector2(0, -100), donuts) == Vector2(0, -50))
	assert(donuts_pair.elements[0].pos == Vector2(500, 450))
	assert(donuts_pair.elements[1].pos == Vector2(500, 350))
	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()

	donuts_pair = DonutsPair.new(Vector2(500, 500))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(500, 650)
	assert(move(donuts_pair, Vector2(0, 100), donuts) == Vector2(0, 50))
	assert(donuts_pair.elements[0].pos == Vector2(500, 550))
	assert(donuts_pair.elements[1].pos == Vector2(500, 450))
	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(500, 500))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 500)
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 400)
	assert(move(donuts_pair, Vector2(-100, 0), donuts) == Vector2.ZERO)
	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()

static func test_rotation():
	var donuts: Array[Donut] = []
	var donuts_pair: DonutsPair

	donuts_pair = DonutsPair.new(Vector2(300, 300))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])
	rotation(donuts_pair, donuts)
	assert(donuts_pair.elements[0].pos == Vector2(300, 300))
	assert(donuts_pair.elements[1].pos == Vector2(400, 300))
	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()
	

	donuts_pair = DonutsPair.new(Vector2(300, 300))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 300)
	rotation(donuts_pair, donuts)
	assert(donuts_pair.elements[0].pos == Vector2(200, 300))
	assert(donuts_pair.elements[1].pos == Vector2(300, 300))
	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(300, 300))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 300)
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(200, 300)
	rotation(donuts_pair, donuts)
	assert(donuts_pair.elements[0].pos == Vector2(300, 200))
	assert(donuts_pair.elements[1].pos == Vector2(300, 300))
	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()


	donuts_pair = DonutsPair.new(Vector2(300, 300))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(400, 350)
	rotation(donuts_pair, donuts)
	assert(donuts_pair.elements[0].pos == Vector2(300, 250))
	assert(donuts_pair.elements[1].pos == Vector2(400, 250))
	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()
	donuts.clear()

static func rotation(donuts_pair: DonutsPair, donuts: Array[Donut]) -> void:
	var initial_pos = donuts_pair.elements[0].pos
	var initial_child_pos = donuts_pair.elements[1].pos

	donuts_pair.child_relative_pos.push_back(donuts_pair.child_relative_pos.pop_front())
	donuts_pair.elements[1].pos = donuts_pair.elements[0].pos
	Donut.move(donuts_pair.elements[1], donuts_pair.child_relative_pos[0], donuts)
	sync_position(donuts_pair, false, donuts)
	if Donut.get_colliding_donut(donuts_pair.elements[0], donuts) == null:
		return
	
	donuts_pair.child_relative_pos.push_back(donuts_pair.child_relative_pos.pop_front())
	donuts_pair.elements[1].pos = initial_pos
	donuts_pair.elements[0].pos = initial_child_pos
	return


static func move(donuts_pair: DonutsPair, direction: Vector2, donuts: Array[Donut]) -> Vector2:
	var initial_pos = donuts_pair.elements[0].pos

	var donuts_except_pair = donuts.duplicate()
	donuts_except_pair.erase(donuts_pair.elements[0])
	donuts_except_pair.erase(donuts_pair.elements[1])

	Donut.move(donuts_pair.elements[0], direction, donuts_except_pair)
	if sync_position(donuts_pair, true, donuts_except_pair):
		return donuts_pair.elements[0].pos - initial_pos
	
	donuts_pair.elements[0].pos = initial_pos
	sync_position(donuts_pair, true, donuts_except_pair)

	Donut.move(donuts_pair.elements[1], direction, donuts_except_pair)
	if sync_position(donuts_pair, false, donuts_except_pair):
		return donuts_pair.elements[0].pos - initial_pos

	donuts_pair.elements[0].pos = initial_pos
	sync_position(donuts_pair, true, donuts_except_pair)
	return Vector2.ZERO

static func hard_drop(donuts_pair: DonutsPair, donuts: Array[Donut]) -> void:
	while true:
		var moved = move(donuts_pair, Vector2.DOWN * 100, donuts)
		if moved == Vector2.ZERO:
			break
	donuts_pair.freeze_count = FREEZE_COUNT


static func test_sync_position():
	var donuts: Array[Donut] = []
	var donuts_pair = DonutsPair.new(Vector2(0, 0))
	donuts.append(donuts_pair.elements[0])
	donuts.append(donuts_pair.elements[1])

	donuts_pair.elements[0].pos = Vector2(300, 300)
	assert(sync_position(donuts_pair, true, donuts))
	assert(donuts_pair.elements[1].pos == Vector2(300, 200))

	donuts_pair.elements[1].pos = Vector2(500, 500)
	assert(sync_position(donuts_pair, false, donuts))
	assert(donuts_pair.elements[0].pos == Vector2(500, 600))

	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(700, 700)

	donuts_pair.elements[0].pos = Vector2(700, 800)
	assert(!sync_position(donuts_pair, true, donuts))

	donuts_pair.elements[1].pos = Vector2(700, 600)
	assert(!sync_position(donuts_pair, false, donuts))

	donuts_pair.elements[0].pos = Vector2(600, 700)
	assert(sync_position(donuts_pair, true, donuts))

	donuts_pair.queue_free()
	for donut in donuts:
		donut.queue_free()


static func sync_position(pair: DonutsPair, to_parent: bool, donuts: Array[Donut]) -> bool:
	var base_donut = pair.elements[0] if to_parent else pair.elements[1]
	var child_donut = pair.elements[1] if to_parent else pair.elements[0]
	var relative_pos = pair.child_relative_pos[0] if to_parent else pair.child_relative_pos[2]

	var initial_pos = child_donut.pos

	child_donut.pos = base_donut.pos + relative_pos
	if Donut.get_colliding_donut(child_donut, donuts) == null:
		return true
	child_donut.pos = initial_pos
	return false


static func spawn_donuts_pair(all_donuts: Array[Donut], node: Node) -> DonutsPair:
	var donuts_pair = DonutsPair.new(Vector2(350, 350))
	node.add_child(donuts_pair)
	for donut in donuts_pair.elements:
		all_donuts.append(donut)
		Donut.render(donut)
	return donuts_pair

static func copy_all_donuts_except_pair(all_donuts: Array[Donut], donuts_pair: DonutsPair) -> Array[Donut]:
	var result: Array[Donut] = all_donuts.duplicate()
	if donuts_pair != null:
		result.erase(donuts_pair.elements[0])
		result.erase(donuts_pair.elements[1])
	return result