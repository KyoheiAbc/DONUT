class_name Game
extends Node

static var COLOR_NUMBER = 3

static var SPRITES: Array[Sprite2D] = []

var all_donuts: Array[Donut] = []
var donuts_pairs: Array[DonutsPair] = []

var rival: Rival = Rival.new()

func _ready():
	for sprite in SPRITES:
		sprite.queue_free()
	SPRITES.clear()

	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_control_position(rect, Vector2(400 + Donut.SPRITE_SIZE.x * 3, 200))

	var node: Node2D
	node = Node2D.new()
	add_child(node)
	SPRITES.append(Sprite2D.new())
	node.add_child(SPRITES.back())
	SPRITES.back().texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]
	node.position = Vector2(225, 300)

	node = Node2D.new()
	add_child(node)
	SPRITES.append(Sprite2D.new())
	node.add_child(SPRITES.back())
	SPRITES.back().texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)]
	node.position = Vector2(225, 100)

	set_process(false)

	var label = Label.new()
	add_child(label)
	Main.setup_label(label)


	var input_handler = InputHandler.new()
	add_child(input_handler)

	label.text = "READY"
	await get_tree().create_timer(1.5).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	label.queue_free()


	set_process(true)

	add_child(rival)

func _process(delta: float) -> void:
	rival.process()
