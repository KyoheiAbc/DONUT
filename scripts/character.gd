class_name Character
extends Node

static var CHARACTER_INDEXES: Array[int] = [0, 1]

const SPRITE_PATHS: Array[String] = [
	"res://assets/a_edited.png",
	"res://assets/b_edited.png",
	"res://assets/c_edited.png",
	"res://assets/d_edited.png",
	"res://assets/e_edited.png",
	"res://assets/f_edited.png",
	"res://assets/g_edited.png",
	"res://assets/h_edited.png",
]

var sprites: Array[Sprite2D]
var sprites_a: Array[Sprite2D]
var sprites_b: Array[Sprite2D]
var cursors: Array[ColorRect]

var target_index: int = 0

func _ready():
	for i in range(SPRITE_PATHS.size()):
		sprites.append(Sprite2D.new())
		add_child(sprites.back())
		sprites.back().scale = Vector2(0.5, 0.5)
		sprites.back().texture = load(SPRITE_PATHS[i])
		sprites.back().position = Vector2(i * 220, 650)
		sprites.back().position.x += (Main.WINDOW.x - (SPRITE_PATHS.size() - 1) * 220) / 2

		sprites_a.append(Sprite2D.new())
		add_child(sprites_a[i])
		sprites_a.back().texture = load(SPRITE_PATHS[i])
		sprites_a.back().position = Vector2(600, 250)

		sprites_b.append(Sprite2D.new())
		add_child(sprites_b[i])
		sprites_b.back().texture = load(SPRITE_PATHS[i])
		sprites_b.back().position = Vector2(1400, 250)

	for i in range(2):
		var cursor = ColorRect.new()
		add_child(cursor)
		cursor.color = Color.from_hsv(i * 0.5, 1, 1, 1)
		cursor.size = Vector2(220, 220)
		Main.set_position(cursor, sprites[i].position)
		cursor.z_index = -1
		cursors.append(cursor)

	var button = Button.new()
	add_child(button)
	button.add_theme_font_size_override("font_size", 32)
	button.text = "OK"
	button.size = Vector2(200, 100)
	Main.set_position(button, Vector2(Main.WINDOW.x * 0.5, Main.WINDOW.y * 0.9))
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Option.new())
	)

	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.pressed.connect(func(position: Vector2) -> void:
		if position.x < Main.WINDOW.x / 2:
			target_index = 0
		else:
			target_index = 1
	)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if direction.x > 0:
			CHARACTER_INDEXES[target_index] += 1
			if CHARACTER_INDEXES[target_index] == CHARACTER_INDEXES[target_index - 1]:
				CHARACTER_INDEXES[target_index] += 1
			if CHARACTER_INDEXES[target_index] >= SPRITE_PATHS.size():
				CHARACTER_INDEXES[target_index] = 0
		elif direction.x < 0:
			CHARACTER_INDEXES[target_index] -= 1
			if CHARACTER_INDEXES[target_index] == CHARACTER_INDEXES[target_index - 1]:
				CHARACTER_INDEXES[target_index] -= 1
			if CHARACTER_INDEXES[target_index] < 0:
				CHARACTER_INDEXES[target_index] = SPRITE_PATHS.size() - 1
	)

func _process(_delta: float) -> void:
	for i in cursors.size():
		cursors[i].position = sprites[CHARACTER_INDEXES[i]].position - cursors[i].size / 2
	
	for i in SPRITE_PATHS.size():
		sprites_a[i].visible = (i == CHARACTER_INDEXES[0])
		sprites_b[i].visible = (i == CHARACTER_INDEXES[1])