class_name Arcade
extends Node

var rival_character_indexes: Array[int]
var level: int = 0

var ui_node: Node = null


static func rival_new_from_level(level: int) -> Rival:
	match level:
		0: return Rival.new(16, [1], 6.2 * 60)
		1: return Rival.new(32, [1, 2, 2], 5.4 * 60)
		2: return Rival.new(32, [1, 2, 2], 4.6 * 60)
		3: return Rival.new(64, [1, 2, 2, 3, 3, 3], 3.8 * 60)
		4: return Rival.new(64, [1, 2, 2, 3, 3, 3], 3.0 * 60)
		5: return Rival.new(64, [1, 2, 2, 3, 3, 3], 2.6 * 60)
		6: return Rival.new(128, [3, 4, 4, 5, 5, 5], 2.2 * 60)
		7: return Rival.new(128, [3, 4, 4, 5, 5, 5], 1.8 * 60)
		8: return Rival.new(256, [3, 5, 5, 7, 7, 7], 1.4 * 60)
	return null

func _ready() -> void:
	for i in range(Character.SPRITES.size()):
		if i != Main.CHARACTER_INDEXES[0]:
			rival_character_indexes.append(i)
	rival_character_indexes.shuffle()

	Main.CHARACTER_INDEXES[1] = rival_character_indexes[level]

	await ui()
	self.add_child(Game.new(self))

func next() -> void:
	level += 1
	if level == 8:
		level = 0
	await ui()
	Main.CHARACTER_INDEXES[1] = rival_character_indexes[level]
	self.add_child(Game.new(self))

func ui() -> void:
	if ui_node != null:
		return
	ui_node = Node.new()
	add_child(ui_node)

	var sprite_a = Sprite2D.new()
	ui_node.add_child(sprite_a)
	sprite_a.texture = Character.SPRITES[Main.CHARACTER_INDEXES[0]]
	sprite_a.position = Vector2(600, 250)
	
	var sprite_b = Sprite2D.new()
	ui_node.add_child(sprite_b)
	sprite_b.texture = Character.SPRITES[rival_character_indexes[level]]
	sprite_b.position = Vector2(1400, 250)

	for i in range(rival_character_indexes.size()):
		var sprite = Sprite2D.new()
		ui_node.add_child(sprite)
		sprite.texture = Character.SPRITES[rival_character_indexes[i]]
		sprite.scale = Vector2(0.45, 0.45)
		sprite.position = Vector2(i * 220, 700)
		sprite.position.x += (Main.WINDOW.x - (Character.SPRITES.size() - 2) * 220) / 2

		var color_rect = ColorRect.new()
		ui_node.add_child(color_rect)
		color_rect.size = Vector2(400 * 0.45, 400 * 0.45)
		color_rect.position = sprite.position - color_rect.size / 2

		if i < level:
			color_rect.color = Color(0, 0, 0, 0.6)
		elif i == level:
			color_rect.visible = false
		else:
			color_rect.color = Color(0, 0, 0, 0.95)

	var label = Main.label_new()
	ui_node.add_child(label)
	label.text = "VS"
	label.position.y = 250 - label.size.y / 2

	await get_tree().create_timer(1.0).timeout
	ui_node.queue_free()
