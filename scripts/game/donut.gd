class_name Donut
extends Node2D

static var SPRITE_SIZE = Vector2(64, 64)
static var POSITION_OFFSET = Vector2(1000 - SPRITE_SIZE.x, 500 - SPRITE_SIZE.y * 9)

const DONUT_TEXTURE: Texture2D = preload("res://assets/donut.png")

static var GARBAGE_HARDNESS = 1

var value: int
var pos: Vector2
var sprite: Sprite2D

var freeze_count: int = 0
const FREEZE_COUNT = 1
static var GRAVITY = 30
var to_clear: bool = false
var to_clear_count: int = 0

func _init(_value: int):
	value = _value

	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = DONUT_TEXTURE
	if value >= 10:
		sprite.modulate = Color(0.8, 0.8, 0.8).darkened((value - 10) * 0.1)
	else:
		sprite.modulate = Color.from_hsv(value / 5.0, 0.5, 1)


func process(all_donuts: Array[Donut]) -> bool:
	if value == -1:
		return false

	if to_clear:
		sprite.scale.y = 1.25
		sprite.scale.x = 1.25
		to_clear_count += 1
		if to_clear_count > Cleaner.CLEAR_WAIT_COUNT:
			Donut.clear_donut(self, all_donuts)
		return true

	if move(self, Vector2(0, GRAVITY), all_donuts) == Vector2.ZERO:
		freeze_count += 1
		var animation_progress = min(freeze_count, FREEZE_COUNT) / float(FREEZE_COUNT) * PI
		sprite.scale.y = 1 - 0.3 * sin(animation_progress)
		sprite.scale.x = 1 + 0.3 * sin(animation_progress)
		sprite.position.y = 15 * sin(animation_progress)
	else:
		freeze_count = 0

	if freeze_count > FREEZE_COUNT:
		return false
	else:
		return true

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

static func get_colliding_donut(donut: Donut, donuts: Array[Donut]) -> Donut:
	var rect_a = Rect2(donut.pos - Vector2(50, 50), Vector2(100, 100))
	for other_donut in donuts:
		if other_donut == donut:
			continue
		var rect_b = Rect2(other_donut.pos - Vector2(50, 50), Vector2(100, 100))
		if rect_a.intersects(rect_b):
			return other_donut
	return null


static func get_donut_at_position(pos: Vector2, donuts: Array[Donut]) -> Donut:
	for donut in donuts:
		if donut.pos == pos:
			return donut
	return null


static func spawn_garbage(count: int, all_donuts: Array[Donut], node: Node) -> int:
	var spawn_count = 0
	var y = 50
	while true:
		y -= 100
		var x_positions = [150, 250, 350, 450, 550, 650]
		x_positions.shuffle()
		for x in range(x_positions.size()):
			var donut = Donut.new(10 + GARBAGE_HARDNESS)
			donut.pos = Vector2(x_positions[x], y)
			if Donut.get_colliding_donut(donut, all_donuts) != null:
				donut.queue_free()
				continue
			all_donuts.append(donut)
			node.add_child(donut)
			spawn_count += 1
			if spawn_count >= count:
				return spawn_count
			if spawn_count >= 36:
				return spawn_count
	return spawn_count

static func get_around(target: Donut, all_donuts: Array[Donut]) -> Array[Donut]:
	var result: Array[Donut] = []
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	for dir in directions:
		var pos = target.pos + dir * 100
		var donut = get_donut_at_position(pos, all_donuts)
		if donut != null:
			result.append(donut)
	return result

static func clear_donut(donut: Donut, all_donuts: Array[Donut]) -> void:
	var around_donuts = get_around(donut, all_donuts)
	for around_donut in around_donuts:
		if around_donut.value < 10:
			continue
		if around_donut.value == 14:
			print("cannot reduce garbage further")
			continue
		if around_donut.freeze_count < Donut.FREEZE_COUNT:
			continue
		around_donut.value -= 1
		if around_donut.value == 10:
			around_donut.queue_free()
			all_donuts.erase(around_donut)

	all_donuts.erase(donut)
	donut.queue_free()

static func sort_donuts_by_y_descending(all_donuts: Array[Donut]) -> void:
	all_donuts.sort_custom(func(a, b): return a.pos.y > b.pos.y)
