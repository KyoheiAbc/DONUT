class_name Arcade
extends Node

static func rival_new_from_level(level: int) -> Rival:
	match level:
		0: return Rival.new(Main.ARCADE_RIVAL_CHARACTER_INDEXES[level], 16, [1], 6.2 * 60)
		1: return Rival.new(Main.ARCADE_RIVAL_CHARACTER_INDEXES[level], 32, [1, 2, 2], 5.4 * 60)
		2: return Rival.new(Main.ARCADE_RIVAL_CHARACTER_INDEXES[level], 32, [1, 2, 2], 4.6 * 60)
		3: return Rival.new(Main.ARCADE_RIVAL_CHARACTER_INDEXES[level], 64, [1, 2, 2, 3, 3, 3], 3.8 * 60)
		4: return Rival.new(Main.ARCADE_RIVAL_CHARACTER_INDEXES[level], 64, [1, 2, 2, 3, 3, 3], 3.0 * 60)
		5: return Rival.new(Main.ARCADE_RIVAL_CHARACTER_INDEXES[level], 64, [1, 2, 2, 3, 3, 3], 2.6 * 60)
		6: return Rival.new(Main.ARCADE_RIVAL_CHARACTER_INDEXES[level], 128, [3, 4, 4, 5, 5, 5], 2.2 * 60)
		7: return Rival.new(Main.ARCADE_RIVAL_CHARACTER_INDEXES[level], 128, [3, 4, 4, 5, 5, 5], 1.8 * 60)
		8: return Rival.new(Main.ARCADE_RIVAL_CHARACTER_INDEXES[level], 256, [3, 5, 5, 7, 7, 7], 1.4 * 60)
	return null

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
