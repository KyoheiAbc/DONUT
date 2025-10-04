class_name Character
extends Node

static var MAP = [[0, 1, -1, -1, -1, -1, -1, -1]]
const SPRITES: Array[Texture2D] = [
	preload("res://assets/a_edited.png"),
	preload("res://assets/b_edited.png"),
	preload("res://assets/c_edited.png"),
	preload("res://assets/d_edited.png"),
	preload("res://assets/e_edited.png"),
	preload("res://assets/f_edited.png"),
	preload("res://assets/g_edited.png"),
	preload("res://assets/h_edited.png"),
]

var sprites: Array[Sprite2D]
var sprites_a: Array[Sprite2D]
var sprites_b: Array[Sprite2D]
var cursors: Array[ColorRect]

var target_index: int = 0

func _ready():
	for i in range(SPRITES.size()):
		sprites.append(Sprite2D.new())
		add_child(sprites.back())
		sprites.back().scale = Vector2(0.5, 0.5)
		sprites.back().texture = SPRITES[i]
		sprites.back().position = Vector2(i * 220, 650)
		sprites.back().position.x += (Main.WINDOW.x - (SPRITES.size() - 1) * 220) / 2

		sprites_a.append(Sprite2D.new())
		add_child(sprites_a[i])
		sprites_a.back().texture = SPRITES[i]
		sprites_a.back().position = Vector2(600, 250)

		sprites_b.append(Sprite2D.new())
		add_child(sprites_b[i])
		sprites_b.back().texture = SPRITES[i]
		sprites_b.back().position = Vector2(1400, 250)

	for i in range(2):
		var cursor = ColorRect.new()
		add_child(cursor)
		cursor.color = Color.from_hsv(i * 0.5, 1, 1, 1)
		cursor.size = Vector2(220, 220)
		Main.set_control_position(cursor, sprites[i].position)
		cursor.z_index = -1
		cursors.append(cursor)

	var button = Button.new()
	add_child(button)
	button.text = "OK"
	Main.setup_button(button)
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Option.new())
	)

	var input_handler = InputHandler.new()
	input_handler.drag_area_end_x = 8000
	add_child(input_handler)
	input_handler.pressed.connect(func(position: Vector2) -> void:
		if position.x < Main.WINDOW.x / 2:
			target_index = 0
		else:
			target_index = 1
	)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if direction.x > 0:
			Array2D.move_value(MAP, target_index, Vector2(1, 0))
		elif direction.x < 0:
			Array2D.move_value(MAP, target_index, Vector2(-1, 0))
	)


func _process(_delta: float) -> void:
	for i in cursors.size():
		cursors[i].position = sprites[Array2D.get_position_value(MAP, i)].position - cursors[i].size / 2
	for i in SPRITES.size():
		sprites_a[i].visible = (i == Array2D.get_position_value(MAP, 0))
		sprites_b[i].visible = (i == Array2D.get_position_value(MAP, 1))