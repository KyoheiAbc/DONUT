class_name Game
extends Node

static var BOT_HP: int = 100
static var BOT_SPD: int = 100
static var BOT_COMBO_1: int = 1
static var BOT_COMBO_3: int = 3
static var BOT_COMBO_5: int = 3
static var BOT_COMBO_7: int = 3
static var BOT_COMBO_9: int = 0
static var BOT_COMBO_11: int = 0
static var BOT_COMBO_13: int = 0

var sprites: Array[Sprite2D]
var bot_hp_slider: HSlider


func _ready():
	sprites.append(Sprite2D.new())
	add_child(sprites.back())
	sprites.back().texture = load(Character.SPRITE_PATHS[Character.CHARACTER_INDEXES[0]])
	sprites.back().position = Vector2(700, 750)

	sprites.append(Sprite2D.new())
	add_child(sprites.back())
	sprites.back().texture = load(Character.SPRITE_PATHS[Character.CHARACTER_INDEXES[1]])
	sprites.back().scale = Vector2(0.8, 0.8)
	sprites.back().position = Vector2(700, 250)

	bot_hp_slider = HSlider.new()
	add_child(bot_hp_slider)

	var empty_image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
	empty_image.fill(Color(0, 0, 0, 0))
	var empty_texture = ImageTexture.create_from_image(empty_image)

	bot_hp_slider.add_theme_icon_override("grabber", empty_texture)
	bot_hp_slider.add_theme_icon_override("grabber_highlight", empty_texture)
	bot_hp_slider.add_theme_icon_override("grabber_disabled", empty_texture)

	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 1, 0)
	bot_hp_slider.add_theme_stylebox_override("grabber_area_highlight", stylebox)
	bot_hp_slider.add_theme_stylebox_override("grabber_area", stylebox)

	stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.4, 0.4, 0.4)
	stylebox.content_margin_top = 20

	bot_hp_slider.add_theme_stylebox_override("slider", stylebox)

	bot_hp_slider.min_value = 0
	bot_hp_slider.max_value = BOT_HP
	bot_hp_slider.value = BOT_HP
	bot_hp_slider.size = Vector2(320, 0)
	Main.set_position(bot_hp_slider, sprites[1].position + Vector2(0, -190))

	var color_rect = ColorRect.new()
	color_rect.color = Color.from_hsv(0.5, 1, 1, 1)
	color_rect.size = Vector2(400, 800)
	Main.set_position(color_rect, Vector2(1200, 500))
	add_child(color_rect)


	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.valid_area = Rect2(Main.WINDOW.x * 0.75, -4000, 8000, 8000)
	input_handler.pressed.connect(func(position: Vector2) -> void:
		var tween = sprites[0].get_tree().create_tween()
		tween.tween_property(sprites[0], "position", Vector2(0, -150), 0.15).as_relative()
		tween.tween_property(sprites[0], "position", Vector2(700, 750), 0.15)

		var tween_slider = bot_hp_slider.get_tree().create_tween()
		tween_slider.tween_property(bot_hp_slider, "value", -30, 1).as_relative()

		
	)

var timer: SceneTreeTimer

func _process(delta: float) -> void:
	if bot_hp_slider.value <= 0:
		sprites[1].rotation += PI / 30

		if timer == null:
			timer = get_tree().create_timer(3)
			timer.timeout.connect(func() -> void:
				Main.show_black(0.1)
				queue_free()
				Main.ROOT.add_child(Character.new())
			)
			var label = Label.new()
			add_child(label)
			label.text = "You Win!"
			label.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
			label.add_theme_font_size_override("font_size", 256)
			label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER


		return