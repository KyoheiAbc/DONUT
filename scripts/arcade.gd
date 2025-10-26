class_name Arcade
extends Node

func _ready() -> void:
	var sprite_a = Sprite2D.new()
	add_child(sprite_a)
	sprite_a.texture = Character.SPRITES[Main.ARCADE_PLAYER_CHARACTER_INDEX]
	sprite_a.position = Vector2(600, 250)
	
	var sprite_b = Sprite2D.new()
	add_child(sprite_b)
	sprite_b.texture = Character.SPRITES[Main.ARCADE_RIVAL_CHARACTER_INDEXES[Main.ARCADE_LEVEL]]
	sprite_b.position = Vector2(1400, 250)

	for i in range(Main.ARCADE_RIVAL_CHARACTER_INDEXES.size()):
		var sprite = Sprite2D.new()
		add_child(sprite)
		sprite.texture = Character.SPRITES[Main.ARCADE_RIVAL_CHARACTER_INDEXES[i]]
		sprite.scale = Vector2(0.45, 0.45)
		sprite.position = Vector2(i * 220, 700)
		sprite.position.x += (Main.WINDOW.x - (Character.SPRITES.size() - 2) * 220) / 2

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
	label.position.y = 250 - label.size.y / 2

	await get_tree().create_timer(1.5).timeout
	queue_free()
	Main.NODE.add_child(Game.new())
