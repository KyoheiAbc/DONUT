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

func _ready():
	var button = Button.new()
	add_child(button)
	button.add_theme_font_size_override("font_size", 32)
	button.text = "OK"
	button.size = Vector2(200, 100)
	Main.set_position(button, Vector2(Main.WINDOW.x * 0.5, Main.WINDOW.y * 0.9))
	button.pressed.connect(func() -> void:
		Main.show_black(0.1)
		self.queue_free()
		Main.ROOT.add_child(Initial.new())
	)
