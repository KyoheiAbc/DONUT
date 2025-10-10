class_name UI
extends Node

var next_donuts: Array[Sprite2D] = [Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new()]

var player_sprite: Sprite2D = Sprite2D.new()

var rival_sprite: Sprite2D = Sprite2D.new()
var rival_hp_slider: GameVSlider = GameVSlider.new(Vector2(20, 200), Color(0, 1, 0))
var rival_idle_slider: GameVSlider = GameVSlider.new(Vector2(20, 200), Color(1, 0.7, 0))
var rival_attack_motion_count: int = 0

var combo_label: Label = Label.new()
var score_slider: GameVSlider = GameVSlider.new(Vector2(30, 380), Color.from_hsv(0.2, 0.8, 1))

func _init(game: Node) -> void:
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_control_position(rect, Vector2(400 + Donut.SPRITE_SIZE.x * 3, 200))

	for i in range(next_donuts.size()):
		var next_donut = next_donuts[i]
		add_child(next_donut)
		next_donut.texture = Donut.DONUT_TEXTURE
		next_donut.z_index = 1000
		# next_donut.modulate = Color.from_hsv(game.next_colors[i] / 5.0, 0.5, 1)
	next_donuts[0].position = Vector2(630, 50 + 32)
	next_donuts[1].position = Vector2(630, 50 + 0)
	next_donuts[2].position = Vector2(630, 50 + 128)
	next_donuts[3].position = Vector2(630, 50 + 96)

	var player = Node2D.new()
	add_child(player)
	player.add_child(player_sprite)
	player_sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]
	player.position = Vector2(225, 300)
	
	var rival = Node2D.new()
	add_child(rival)
	rival.add_child(rival_sprite)
	rival_sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)]
	rival.position = Vector2(225, 100)

	add_child(rival_hp_slider)
	Main.set_control_position(rival_hp_slider, Vector2(225 + 130, 100))

	add_child(rival_idle_slider)
	Main.set_control_position(rival_idle_slider, Vector2(225 + 110, 100))
	rival_idle_slider.value = 0

	add_child(combo_label)
	combo_label.text = "0 COMBO"
	combo_label.add_theme_font_size_override("font_size", 32)
	combo_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	combo_label.position = Vector2(500, 220)
	combo_label.z_index = 1000

	add_child(score_slider)
	Main.set_control_position(score_slider, Vector2(700, 200))
	score_slider.max_value = 32
	score_slider.min_value = -32
	score_slider.value = 0

	game.signal_next_donuts_pair.connect(func() -> void:
		for i in range(next_donuts.size()):
			var next_donut = next_donuts[i]
			next_donut.modulate = Color.from_hsv(game.next_colors[i] / 5.0, 0.5, 1)
		)
	game.signal_combo.connect(func(count: int) -> void:
		combo_label.text = str(count) + " COMBO"
		if count > 0:
			UI.hop(player_sprite, 1)
			score_slider.value += count * count
	)
	game.signal_damage.connect(func() -> void:
		UI.jump(rival_sprite, false)
		UI.rotation(player_sprite, false)
	)
	game.signal_hop.connect(func() -> void:
		UI.hop(player_sprite, 1)
	)
	game.rival.signal_frame_count.connect(func(frame_count: int) -> void:
		rival_idle_slider.value = float(frame_count) / float(Rival.IDLE_FRAME_COUNT) * rival_idle_slider.max_value

		for i in range(Rival.ATTACK_NUMBER):
			if rival_idle_slider.value >= rival_idle_slider.max_value / float(Rival.ATTACK_NUMBER) * i and rival_attack_motion_count == i:
				if rival_sprite.rotation == 0 and rival_sprite.position == Vector2.ZERO:
					UI.hop(rival_sprite, 3 if i == 0 else 1)
					rival_attack_motion_count += 1
	)
	game.rival.signal_combo.connect(func(count: int) -> void:
		UI.hop(rival_sprite, 1)
		score_slider.value -= count * count
	)
	game.rival.signal_attack_end.connect(func() -> void:
		rival_attack_motion_count = 0
	)
	game.rival.signal_damage.connect(func() -> void:
		UI.jump(player_sprite, false)
		UI.rotation(rival_sprite, false)
	)
	game.signal_score.connect(func(value: int) -> void:
		score_slider.value = value
	)

class GameVSlider extends VSlider:
	func _init(_size: Vector2, color: Color) -> void:
		var empty_image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
		empty_image.fill(Color(0, 0, 0, 0))
		var empty_texture = ImageTexture.create_from_image(empty_image)
		add_theme_icon_override("grabber", empty_texture)
		add_theme_icon_override("grabber_highlight", empty_texture)
		add_theme_icon_override("grabber_disabled", empty_texture)

		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = color
		add_theme_stylebox_override("grabber_area_highlight", stylebox)
		add_theme_stylebox_override("grabber_area", stylebox)
		stylebox = StyleBoxFlat.new()
		stylebox.bg_color = Color(0.4, 0.4, 0.4)
		stylebox.content_margin_left = _size.x
		add_theme_stylebox_override("slider", stylebox)

		size = _size

		min_value = 0
		max_value = 1000
		step = 1
		editable = false
		value = max_value


static func jump(sprite: Sprite2D, down: bool) -> void:
	var tween = sprite.create_tween()
	var height = 80 if down else -80
	tween.tween_property(sprite, "position", Vector2(0, height), 0.2).as_relative()
	tween.tween_property(sprite, "position", Vector2.ZERO, 0.2)
	await tween.finished
	sprite.position = Vector2.ZERO

static func hop(sprite: Sprite2D, iterations: int) -> void:
	for i in range(iterations):
		var tween = sprite.create_tween()
		var delta = Vector2(30, -30) if randf() < 0.5 else Vector2(-30, -30)
		tween.tween_property(sprite, "position", delta, 0.15).as_relative()
		tween.parallel().tween_property(sprite, "rotation", PI / 6 if delta.x > 0 else -PI / 6, 0.15).as_relative()
		tween.chain().tween_property(sprite, "position", Vector2.ZERO, 0.15)
		tween.parallel().tween_property(sprite, "rotation", 0, 0.15)
		await tween.finished
		sprite.position = Vector2.ZERO
		sprite.rotation = 0

static func rotation(sprite: Sprite2D, loop: bool) -> void:
	var tween = sprite.create_tween()
	if loop:
		tween.set_loops()
	tween.tween_property(sprite, "rotation", 2 * PI, 1).as_relative()
	await tween.finished
	sprite.rotation = 0