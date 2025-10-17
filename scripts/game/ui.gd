class_name UI
extends Node

var next_donuts: Array[Sprite2D] = [Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new()]

var player_sprite: Sprite2D = Sprite2D.new()
var player_latest_combo: int = 0

var rival_sprite: Sprite2D = Sprite2D.new()
var rival_hp_slider: GameVSlider = GameVSlider.new(Vector2(20, 200), Color(0, 1, 0))
var rival_idle_slider: GameVSlider = GameVSlider.new(Vector2(20, 200), Color(1, 0.7, 0))
var rival_attack_motion_count: int = 0
var rival_latest_combo: int = 0
var combo_label: Label = Label.new()
var score_slider: GameVSlider = GameVSlider.new(Vector2(30, 380), Color.from_hsv(0.2, 0.8, 1))

func _init() -> void:
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color.from_hsv(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	Main.set_control_position(rect, Vector2(400 + Donut.SPRITE_SIZE.x * 3, 200))
	rect.z_index = -1

	for i in range(next_donuts.size()):
		var next_donut = next_donuts[i]
		add_child(next_donut)
		next_donut.texture = Donut.DONUT_TEXTURE
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
	combo_label.text = ""
	combo_label.add_theme_font_size_override("font_size", 32)
	combo_label.add_theme_color_override("font_color", Color.from_hsv(0.15, 1, 1))
	combo_label.position = Vector2(500, 220)
	combo_label.visible = false

	add_child(score_slider)
	Main.set_control_position(score_slider, Vector2(700, 200))
	score_slider.value = 500

func process(game: Game) -> void:
	var rival = game.rival

	rival_hp_slider.value = rival.hp / float(Rival.HP) * rival_hp_slider.max_value

	if rival.is_idle:
		rival_idle_slider.value = rival.frame_count / float(rival.attack_prepare_count) * rival_idle_slider.max_value
		for i in range(rival.attack_count):
			if rival.frame_count >= rival.attack_prepare_count / float(rival.attack_count) * i:
				if rival_sprite.rotation == 0 and rival_sprite.position == Vector2.ZERO and rival_attack_motion_count == i:
					rival_attack_motion_count += 1
					if i == 0:
						hop(rival_sprite, rival.attack_count)
					else:
						hop(rival_sprite, 1)
	else:
		rival_attack_motion_count = 0
		rival_idle_slider.value = (rival.attack_count - rival.combo) / float(rival.attack_count) * rival_idle_slider.max_value

	if rival.combo > rival_latest_combo:
		hop(rival_sprite, 1)
		rival_latest_combo = rival.combo
	elif rival.combo < rival_latest_combo:
		rival_latest_combo = 0

	if game.combo > player_latest_combo:
		player_latest_combo = game.combo
		execute_after_wait(func() -> void:
			hop(player_sprite, 1)
			combo_label.visible = true
			combo_label.text = str(game.combo) + " COMBO!"
		)
	elif game.combo < player_latest_combo:
		player_latest_combo = 0
		execute_after_wait(func() -> void:
			combo_label.visible = false
		)

	score_slider.value = score_slider.max_value * 0.5
	score_slider.value += (game.score + game.combo * game.combo - rival.combo * rival.combo) * 32
	
	for donut in game.all_donuts:
		Donut.render(donut)

func attack(is_attack: bool) -> void:
	if is_attack:
		UI.jump(player_sprite, false)
		UI.rotation(rival_sprite, false)
	else:
		UI.jump(rival_sprite, true)
		UI.rotation(player_sprite, false)

func execute_after_wait(callback: Callable) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.start(Cleaner.CLEAR_WAIT_COUNT / 60.0)
	timer.timeout.connect(func() -> void:
		timer.queue_free()
		callback.call()
	)

func next_donuts_updated(next_colors: Array[int]) -> void:
	for i in range(next_donuts.size()):
		next_donuts[i].modulate = Color.from_hsv(next_colors[i] / float(Game.COLOR_NUMBER + 1), 0.5, 1)


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
		editable = false
		value = max_value


static func jump(sprite: Sprite2D, down: bool) -> void:
	var tween = sprite.create_tween()
	var height = 80 if down else -80
	tween.tween_property(sprite, "position", Vector2(0, height), 0.2).as_relative()
	tween.tween_property(sprite, "position", Vector2.ZERO, 0.2)
	await tween.finished
	tween.kill()
	sprite.position = Vector2.ZERO

static func hop(sprite: Sprite2D, iterations: int) -> void:
	if iterations == -1:
		iterations = 1000
	for i in range(iterations):
		var tween = sprite.create_tween()
		if iterations > 1000:
			tween.set_loops()
		var delta = Vector2(30, -30) if randf() < 0.5 else Vector2(-30, -30)
		var duration = 0.22 if iterations >= 1000 else 0.15
		tween.tween_property(sprite, "position", delta, duration).as_relative()
		tween.parallel().tween_property(sprite, "rotation", PI / 6 if delta.x > 0 else -PI / 6, duration).as_relative()
		tween.chain().tween_property(sprite, "position", Vector2.ZERO, duration)
		tween.parallel().tween_property(sprite, "rotation", 0, duration)
		await tween.finished
		tween.kill()
		sprite.position = Vector2.ZERO
		sprite.rotation = 0

static func rotation(sprite: Sprite2D, loop: bool) -> void:
	var tween = sprite.create_tween()
	if loop:
		tween.set_loops()
	tween.tween_property(sprite, "rotation", 2 * PI, 1 if not loop else 1.25).as_relative()
	await tween.finished
	tween.kill()
	sprite.rotation = 0
