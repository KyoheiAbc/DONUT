class_name Arcade
extends Node

func _ready() -> void:
	Main.ARCADE_LEVEL += 1
	
	var sprite_a = Sprite2D.new()
	add_child(sprite_a)
	sprite_a.texture = Character.SPRITES[Main.PLAYER_CHARACTER_INDEX]
	sprite_a.position = Vector2(600, 300)
	
	var sprite_b = Sprite2D.new()
	add_child(sprite_b)
	Main.RIVAL_CHARACTER_INDEX = Main.ARCADE_RIVAL_CHARACTER_INDEXES[Main.ARCADE_LEVEL]
	sprite_b.texture = Character.SPRITES[Main.RIVAL_CHARACTER_INDEX]
	sprite_b.position = Vector2(1400, 300)

	for i in range(Main.ARCADE_RIVAL_CHARACTER_INDEXES.size()):
		var sprite = Sprite2D.new()
		add_child(sprite)
		sprite.texture = Character.SPRITES[Main.ARCADE_RIVAL_CHARACTER_INDEXES[i]]
		sprite.scale = Vector2(0.45, 0.45)
		sprite.position = Vector2(i * 220, 685)
		sprite.position.x += (Main.WINDOW.x - (8) * 220) / 2

		var color_rect = ColorRect.new()
		add_child(color_rect)
		color_rect.size = Vector2(400 * 0.45, 400 * 0.45)
		color_rect.position = sprite.position - color_rect.size / 2

		if i < Main.ARCADE_LEVEL:
			color_rect.color = Color(0, 0, 0, 0.6)
		elif i == Main.ARCADE_LEVEL:
			color_rect.visible = false
		else:
			color_rect.color = Color(0, 0, 0, 0.95)

	var label = Main.label_new()
	add_child(label)
	label.text = "VS"
	label.position.y = 300 - label.size.y / 2

	var button_start = Main.button_new()
	add_child(button_start)
	button_start.text = "START"
	button_start.pressed.connect(func() -> void:
		self.queue_free()
		Main.NODE.add_child(Game.new())
	)
