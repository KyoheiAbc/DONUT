class_name Donut
extends Node2D

const SPRITE_SIZE = Vector2(64, 64)
const POSITION_OFFSET = Vector2(1000 - SPRITE_SIZE.x, 500 - SPRITE_SIZE.y * 9)

const DONUT_TEXTURE: Texture2D = preload("res://assets/donut.png")

var value: int
var pos: Vector2
var sprite: Sprite2D

var freeze_count: int = 0
const FREEZE_COUNT = 15
const GRAVITY = 30

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


	if move(self, Vector2(0, GRAVITY), all_donuts) == Vector2.ZERO:
		freeze_count += 1
		var animation_progress = min(freeze_count, FREEZE_COUNT) / float(FREEZE_COUNT) * PI
		sprite.scale.y = 1 - 0.3 * sin(animation_progress)
		sprite.scale.x = 1 + 0.3 * sin(animation_progress)
		sprite.position.y = 15 * sin(animation_progress)
	else:
		freeze_count = 0
		
	render()

	if freeze_count > FREEZE_COUNT:
		return false
	else:
		return true

func render() -> void:
	position = pos / 100 * SPRITE_SIZE + POSITION_OFFSET


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

static func spawn_garbage(count: int, all_donuts: Array[Donut], node: Node) -> int:
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
				return spawn_count
			if spawn_count >= 36:
				return spawn_count
	return spawn_count

static func sort_donuts_by_y_descending(all_donuts: Array[Donut]) -> void:
	all_donuts.sort_custom(func(a, b): return a.pos.y > b.pos.y)


static func create_walls(node: Node, all_donuts: Array[Donut]) -> void:
	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				all_donuts.append(Donut.new(-1))
				node.add_child(all_donuts.back())
				all_donuts.back().pos = Vector2(x * 100 + 50, y * 100 + 50)
				all_donuts.back().visible = false
