class_name CharacterSingle
extends Node

var map = [[-1, -1, -1, -1, -1, -1, -1, -1, -1]]
var sprites: Array[Sprite2D] = []
var sprites_a: Array[Sprite2D] = []
var cursor: ColorRect

func _ready() -> void:
	Main.LABEL.text = ""
	Main.reset_button()
	Main.BUTTON.visible = true
	Main.BUTTON.text = "OK"
	Main.BUTTON.pressed.connect(func() -> void:
		self.queue_free()
		Main.CHARACTER_INDEXES[0] = Array2D.get_position_value(map, 0)
		Arcade.RIVAL_INDEXES = []
		for i in range(Character.SPRITES.size()):
			if i != Main.CHARACTER_INDEXES[0]:
				Arcade.RIVAL_INDEXES.append(i)
		Arcade.RIVAL_INDEXES.shuffle()
		Main.NODE.add_child(Arcade.new())
	)

	map[0][Main.CHARACTER_INDEXES[0]] = 0

	for i in range(map[0].size()):
		sprites.append(Sprite2D.new())
		add_child(sprites.back())
		sprites.back().scale = Vector2(0.45, 0.45)
		sprites.back().texture = Character.SPRITES[i]
		sprites.back().position = Vector2(i * 200, 650)
		sprites.back().position.x += (Main.WINDOW.x - (Character.SPRITES.size() - 1) * 200) / 2

		sprites_a.append(Sprite2D.new())
		add_child(sprites_a[i])
		sprites_a.back().texture = Character.SPRITES[i]
		sprites_a.back().position = Vector2(1000, 250)

	cursor = ColorRect.new()
	add_child(cursor)
	cursor.color = Color.from_hsv(0, 1, 1)
	cursor.size = Vector2(200, 200)
	cursor.z_index = -1

	var input_handler = InputHandler.new()
	input_handler.threshold = 400 * 0.45
	input_handler.drag_area_end_x = 8000
	add_child(input_handler)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if direction.x > 0:
			Array2D.move_value(map, 0, Vector2(1, 0))
		elif direction.x < 0:
			Array2D.move_value(map, 0, Vector2(-1, 0))
	)

func _process(_delta: float) -> void:
	cursor.position = sprites[Array2D.get_position_value(map, 0)].position - cursor.size / 2
	for i in sprites_a.size():
		sprites_a[i].visible = (i == Array2D.get_position_value(map, 0))
