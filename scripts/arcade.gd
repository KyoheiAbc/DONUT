class_name Arcade
extends Node

static var LEVEL: int = 0
static var RIVAL_INDEXES: Array[int] = []

func _ready() -> void:
	Main.reset_button()

	Main.LABEL.visible = true
	Main.LABEL.text = "VS\n\n"

	Main.BUTTON.pressed.connect(func() -> void:
		self.queue_free()
		Main.CHARACTER_INDEXES[1] = Arcade.RIVAL_INDEXES[Arcade.LEVEL]
		Main.NODE.add_child(Game.new())
	)

	var sprite_a = Sprite2D.new()
	add_child(sprite_a)
	sprite_a.texture = Character.SPRITES[Main.CHARACTER_INDEXES[0]]
	sprite_a.position = Vector2(600, 250)
	
	var sprite_b = Sprite2D.new()
	add_child(sprite_b)
	sprite_b.texture = Character.SPRITES[Arcade.RIVAL_INDEXES[Arcade.LEVEL]]
	sprite_b.position = Vector2(1400, 250)


	for i in range(Arcade.RIVAL_INDEXES.size()):
		var sprite = Sprite2D.new()
		add_child(sprite)
		sprite.texture = Character.SPRITES[Arcade.RIVAL_INDEXES[i]]
		sprite.scale = Vector2(0.45, 0.45)
		sprite.position = Vector2(i * 220, 650)
		sprite.position.x += (Main.WINDOW.x - (Character.SPRITES.size() - 2) * 220) / 2

		var color_rect = ColorRect.new()
		add_child(color_rect)
		color_rect.size = Vector2(400 * 0.45, 400 * 0.45)
		color_rect.position = sprite.position - color_rect.size / 2

		if i < Arcade.LEVEL:
			color_rect.color = Color(0, 0, 0, 0.6)
		elif i == Arcade.LEVEL:
			color_rect.visible = false
		else:
			color_rect.color = Color(0, 0, 0, 0.95)
