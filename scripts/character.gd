class_name Character
extends Node

const SPRITES: Array[Texture2D] = [
	preload("res://assets/a_edited.png"),
	preload("res://assets/b_edited.png"),
	preload("res://assets/c_edited.png"),
	preload("res://assets/d_edited.png"),
	preload("res://assets/e_edited.png"),
	preload("res://assets/f_edited.png"),
	preload("res://assets/g_edited.png"),
	preload("res://assets/h_edited.png"),
	preload("res://assets/i_edited.png"),
]

var sprites: Array[Sprite2D]
var sprites_a: Array[Sprite2D]
var sprites_b: Array[Sprite2D]
var cursors: Array[ColorRect]

var target_index: int = -1

var map = [[-1, -1, -1, -1, -1, -1, -1, -1, -1]]

func _init() -> void:
	map[0][Main.PLAYER_CHARACTER_INDEX] = 0
	if not Main.MODE == 0:
		map[0][Main.RIVAL_CHARACTER_INDEX] = 1

	for i in range(SPRITES.size()):
		sprites.append(Sprite2D.new())
		add_child(sprites.back())
		sprites.back().scale = Vector2(0.45, 0.45)
		sprites.back().texture = SPRITES[i]
		sprites.back().position = Vector2(i * 200, 650)
		sprites.back().position.x += (Main.WINDOW.x - (SPRITES.size() - 1) * 200) / 2

		sprites_a.append(Sprite2D.new())
		add_child(sprites_a[i])
		sprites_a.back().texture = SPRITES[i]
		sprites_a.back().position = Vector2(1000, 250) if Main.MODE == 0 else Vector2(600, 250)

		if not Main.MODE == 0:
			sprites_b.append(Sprite2D.new())
			add_child(sprites_b[i])
			sprites_b.back().texture = SPRITES[i]
			sprites_b.back().position = Vector2(1400, 250)

	for i in range(2):
		var cursor = ColorRect.new()
		add_child(cursor)
		cursor.color = Color.from_hsv(i * 0.5, 1, 1)
		cursor.size = Vector2(200, 200)
		cursor.position = sprites[i].position - cursor.size / 2
		cursor.z_index = -1
		cursors.append(cursor)
		if Main.MODE == 0:
			break


	var input_handler = InputHandler.new()
	input_handler.threshold = 400 * 0.45
	input_handler.drag_area_end_x = 8000
	add_child(input_handler)
	input_handler.pressed.connect(func(position: Vector2) -> void:
		if Main.MODE == 0:
			target_index = 0
			return
		if Rect2(cursors[0].position, cursors[0].size).has_point(position):
			target_index = 0
		elif Rect2(cursors[1].position, cursors[1].size).has_point(position):
			target_index = 1
		else:
			if position.x < Main.WINDOW.x / 2:
				target_index = 0
			else:
				target_index = 1
	)
	input_handler.released.connect(func() -> void:
		target_index = -1
	)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if target_index == -1:
			return
		if direction.x > 0:
			Array2D.move_value(map, target_index, Vector2(1, 0))
		elif direction.x < 0:
			Array2D.move_value(map, target_index, Vector2(-1, 0))
	)

	var button_start = Main.button_new()
	add_child(button_start)
	button_start.text = "START"
	button_start.pressed.connect(func() -> void:
		Main.PLAYER_CHARACTER_INDEX = Array2D.get_position_value(map, 0)
		if Main.MODE == 0:
			Main.NODE.add_child(Arcade.new())
		else:
			Main.RIVAL_CHARACTER_INDEX = Array2D.get_position_value(map, 1)
			Main.NODE.add_child(Game.new())
		self.queue_free()
	)

	var button_back = Main.button_new()
	add_child(button_back)
	button_back.text = "BACK"
	button_back.size = Vector2(32 * 6, 32 * 2)
	button_back.position = Vector2(16, 16)
	button_back.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Main.Initial.new())
	)

func _process(_delta: float) -> void:
	if target_index == -1:
		cursors[0].color = Color.from_hsv(0, 1, 1, 1)
		if not Main.MODE == 0:
			cursors[1].color = Color.from_hsv(0.5, 1, 1, 1)
	else:
		cursors[target_index].color = Color(1, 1, 0)

	cursors[0].position = sprites[Array2D.get_position_value(map, 0)].position - cursors[0].size / 2
	if not Main.MODE == 0:
		cursors[1].position = sprites[Array2D.get_position_value(map, 1)].position - cursors[1].size / 2

	for i in SPRITES.size():
		sprites_a[i].visible = (i == Array2D.get_position_value(map, 0))
		if not Main.MODE == 0:
			sprites_b[i].visible = (i == Array2D.get_position_value(map, 1))
