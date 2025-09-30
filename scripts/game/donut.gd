class_name Donut
extends Node

static var SPRITE_SIZE = Vector2(64, 64)
static var POSITION_OFFSET = Vector2(1000, 500 - SPRITE_SIZE.y * 6)

var value: int
var pos: Vector2

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
	sprite.modulate = Color.from_hsv(value / 5.0, 0.5, 1)


func process(donuts: Array[Donut]) -> void:
	if value == -1:
		return

	if move(self, Vector2(0, 10), donuts) == Vector2.ZERO:
		freeze_count += 1

		var animation_progress = min(freeze_count, 30) / 30.0 * PI
		sprite.scale.y = 1 - 0.3 * sin(animation_progress)
		sprite.scale.x = 1 + 0.3 * sin(animation_progress)
		sprite.position.y = 15 * sin(animation_progress)
	else:
		freeze_count = 0

	render()

func drop(donuts: Array[Donut]) -> void:
	while true:
		if move(self, Vector2(0, 100), donuts) == Vector2.ZERO:
			break

func render() -> void:
	node.position = pos / 100 * SPRITE_SIZE + POSITION_OFFSET

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