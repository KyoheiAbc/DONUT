class_name DonutsPair
extends Node

var elements: Array[Donut]
var child_relative_pos: Array[Vector2] = [Vector2.UP * 100, Vector2.RIGHT * 100, Vector2.DOWN * 100, Vector2.LEFT * 100]

var freeze_count: int = 0
static var FREEZE_COUNT = 30
static var GRAVITY = 20

func _init(pos: Vector2, colors: Array[int]) -> void:
	elements = [Donut.new(colors[0]), Donut.new(colors[1])]
	add_child(elements[0])
	add_child(elements[1])
	elements[0].pos = pos
	elements[1].pos = pos + child_relative_pos[0]

func process(all_donuts: Array[Donut]) -> void:
	if DonutsPair.move(self, Vector2.DOWN * GRAVITY, all_donuts) == Vector2.ZERO:
		freeze_count += 1
	else:
		freeze_count = 0
	
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


static func spawn_donuts_pair(all_donuts: Array[Donut], colors: Array[int], node: Node) -> DonutsPair:
	var donuts_pair = DonutsPair.new(Vector2(350, 350), colors)
	node.add_child(donuts_pair)
	for donut in donuts_pair.elements:
		all_donuts.append(donut)
		Donut.render(donut)
	return donuts_pair
