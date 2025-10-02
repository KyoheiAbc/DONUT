class_name Donut
extends Node

static var SPRITE_SIZE = Vector2(64, 64)
static var POSITION_OFFSET = Vector2(1000 - SPRITE_SIZE.x, 500 - SPRITE_SIZE.y * 9)

static var GRAVITY = 30

static var FREEZE_COUNT = 30

var value: int
var pos: Vector2

var to_clear: bool = false

var freeze_count: int

var node: Node2D
var sprite: Sprite2D

func _init(_value: int):
	value = _value

	freeze_count = 0

	node = Node2D.new()
	add_child(node)

	sprite = Sprite2D.new()
	node.add_child(sprite)
	sprite.texture = load("res://assets/donut.png")
	if value == 10:
		sprite.modulate = Color(0.7, 0.7, 0.7)
	else:
		sprite.modulate = Color.from_hsv(value / 5.0, 0.5, 1)


func process(donuts: Array[Donut]) -> void:
	if value == -1:
		return

	if to_clear:
		sprite.scale.y = 1.3
		sprite.scale.x = 0.7
		render(self)
		return

	if move(self, Vector2(0, GRAVITY), donuts) == Vector2.ZERO:
		freeze_count += 1

		var animation_progress = min(freeze_count, FREEZE_COUNT) / float(FREEZE_COUNT) * PI
		sprite.scale.y = 1 - 0.3 * sin(animation_progress)
		sprite.scale.x = 1 + 0.3 * sin(animation_progress)
		sprite.position.y = 15 * sin(animation_progress)
	else:
		freeze_count = 0

	render(self)


static func render(donut: Donut) -> void:
	donut.node.position = donut.pos / 100 * SPRITE_SIZE + POSITION_OFFSET


static func test_move() -> void:
	var donuts: Array[Donut] = []
	var donut: Donut
	donut = Donut.new(0)
	donuts.append(donut)
	donut.pos = Vector2(100, 100)
	assert(move(donut, Vector2(100, 0), donuts) == Vector2(100, 0))
	assert(donut.pos == Vector2(200, 100))

	donut.pos = Vector2(300, 300)
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(300, 450)
	assert(move(donut, Vector2(0, 100), donuts) == Vector2(0, 50))
	assert(donut.pos == Vector2(300, 350))

	donut.pos = Vector2(500, 500)
	donuts.back().pos = Vector2(600, 550)
	assert(move(donut, Vector2(100, 0), donuts) == Vector2(100, -50))
	assert(donut.pos == Vector2(600, 450))

	donut.pos = Vector2(500, 500)
	donuts.back().pos = Vector2(600, 500)
	assert(move(donut, Vector2(100, 0), donuts) == Vector2.ZERO)
	assert(donut.pos == Vector2(500, 500))

	for d in donuts:
		d.queue_free()
	donuts.clear()


static func move(donut: Donut, delta: Vector2, donuts: Array[Donut]) -> Vector2:
	var original_position = donut.pos
	donut.pos += delta

	var colliding_donut = null
	colliding_donut = get_colliding_donut(donut, donuts)
	if colliding_donut == null:
		return donut.pos - original_position

	var dy = donut.pos.y - colliding_donut.pos.y
	if dy > 0:
		donut.pos.y = colliding_donut.pos.y + 100
	elif dy < 0:
		donut.pos.y = colliding_donut.pos.y - 100
	colliding_donut = get_colliding_donut(donut, donuts)
	if colliding_donut == null:
		return donut.pos - original_position

	donut.pos = original_position
	return donut.pos - original_position

static func test_get_colliding_donut() -> void:
	var donuts: Array[Donut] = []
	donuts.append(Donut.new(0))
	donuts.back().pos = Vector2(100, 100)
	donuts.append(Donut.new(1))
	donuts.back().pos = Vector2(200, 100)
	donuts.append(Donut.new(2))
	donuts.back().pos = Vector2(300, 100)

	assert(get_colliding_donut(donuts[0], donuts) == null)
	assert(get_colliding_donut(donuts[1], donuts) == null)
	assert(get_colliding_donut(donuts[2], donuts) == null)

	donuts.append(Donut.new(3))
	donuts.back().pos = Vector2(150, 100)
	assert(get_colliding_donut(donuts[0], donuts) == donuts[3])
	assert(get_colliding_donut(donuts[1], donuts) == donuts[3])
	assert(get_colliding_donut(donuts[2], donuts) == null)

	for donut in donuts:
		donut.queue_free()
	donuts.clear()

static func get_colliding_donut(donut: Donut, donuts: Array[Donut]) -> Donut:
	var rect_a = Rect2(donut.pos - Vector2(50, 50), Vector2(100, 100))
	for other_donut in donuts:
		if other_donut == donut:
			continue
		var rect_b = Rect2(other_donut.pos - Vector2(50, 50), Vector2(100, 100))
		if rect_a.intersects(rect_b):
			return other_donut
	return null