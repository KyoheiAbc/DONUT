class_name Donut
extends Node2D

static var SPRITE_SIZE = Vector2(64, 64)
static var POSITION_OFFSET = Vector2(1000 - SPRITE_SIZE.x, 500 - SPRITE_SIZE.y * 9)

const DONUT_TEXTURE: Texture2D = preload("res://assets/donut.png")

var value: int
var pos: Vector2
var sprite: Sprite2D

var freeze_count: int = 0
static var FREEZE_COUNT = 30
static var GRAVITY = 20
var to_clear: bool = false

func _init(_value: int):
	value = _value

	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = DONUT_TEXTURE
	if value >= 10:
		sprite.modulate = Color(0.8, 0.8, 0.8)
	else:
		sprite.modulate = Color.from_hsv(value / 5.0, 0.5, 1)


func process(all_donuts: Array[Donut]) -> void:
	if value == -1:
		return

	if to_clear:
		sprite.scale.y = 1.3
		sprite.scale.x = 0.7
		return

	if move(self, Vector2(0, GRAVITY), all_donuts) == Vector2.ZERO:
		freeze_count += 1
		var animation_progress = min(freeze_count, FREEZE_COUNT) / float(FREEZE_COUNT) * PI
		sprite.scale.y = 1 - 0.3 * sin(animation_progress)
		sprite.scale.x = 1 + 0.3 * sin(animation_progress)
		sprite.position.y = 15 * sin(animation_progress)
	else:
		freeze_count = 0

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

static func render(donut: Donut) -> void:
	donut.position = donut.pos / 100 * SPRITE_SIZE + POSITION_OFFSET


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

static func all_donuts_are_stopped(donuts_except_pair: Array[Donut]) -> bool:
	for donut in donuts_except_pair:
		if donut.value == -1:
			continue
		if get_donut_at_position(donut.pos + Vector2.DOWN * 100, donuts_except_pair) == null:
			return false
		if donut.freeze_count < Donut.FREEZE_COUNT:
			return false
		if donut.to_clear:
			return false
	return true

static func all_garbage_are_stopped(donuts_except_pair: Array[Donut]) -> bool:
	for donut in donuts_except_pair:
		if donut.value < 10:
			continue
		if get_donut_at_position(donut.pos + Vector2.DOWN * 100, donuts_except_pair) == null:
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


static func test_all_donuts_are_stopped() -> void:
	pass


static func spawn_garbage(count: int, all_donuts: Array[Donut], node: Node) -> void:
	var spawn_count = 0
	var y = 50
	while true:
		y -= 100
		var x_positions = [150, 250, 350, 450, 550, 650]
		x_positions.shuffle()
		for x in range(x_positions.size()):
			var donut = Donut.new(10)
			donut.pos = Vector2(x_positions[x], y)
			if Donut.get_colliding_donut(donut, all_donuts) != null:
				donut.queue_free()
				continue
			all_donuts.append(donut)
			node.add_child(donut)
			spawn_count += 1
			if spawn_count >= count:
				return

static func get_around(target: Donut, all_donuts: Array[Donut]) -> Array[Donut]:
	var result: Array[Donut] = []
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	for dir in directions:
		var pos = target.pos + dir * 100
		var donut = get_donut_at_position(pos, all_donuts)
		if donut != null and donut.value != -1:
			result.append(donut)
	return result