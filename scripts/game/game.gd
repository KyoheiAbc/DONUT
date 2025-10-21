class_name Game
extends Node

static var COLOR_NUMBER = 4

var all_donuts: Array[Donut] = []
var donuts_pair: DonutsPair = null

var rival: Rival = Rival.new()

var player_sprite: Sprite2D = Sprite2D.new()

var next_colors: NextColors = NextColors.new()

var score: int = 0

func _ready():
	Main.BUTTON.pressed.disconnect(Main.BUTTON.pressed.get_connections()[0].callable)
	Main.BUTTON.visible = false

	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color.from_hsv(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	rect.position = Vector2(1000 + Donut.SPRITE_SIZE.x * 3, 500) - rect.size / 2
	rect.z_index = -1

	Main.LABEL.visible = true
	Main.LABEL.text = "READY"
	await get_tree().create_timer(1.5).timeout
	Main.LABEL.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	Main.LABEL.visible = false


	var player = Node2D.new()
	add_child(player)
	player.add_child(player_sprite)
	player_sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]
	player.position = Vector2(700, 750)

	rival.signal_combo_ended.connect(func(combo: int) -> void:
		score -= combo_to_score(combo)
		if score > 0:
			var reduced = rival.reduce_hp(score)
			score -= reduced
	)

	add_child(rival)

	add_child(next_colors)


func next_donuts_pair() -> void:
	if Donut.get_donut_at_position(Vector2(350, 350), all_donuts) != null:
		return
	donuts_pair = DonutsPair.spawn_donuts_pair(all_donuts, [next_colors.next_color(), next_colors.next_color()], self)


func create_walls() -> void:
	for y in range(16):
		for x in range(8):
			if x == 0 or x == 7 or y == 15:
				all_donuts.append(Donut.new(-1))
				add_child(all_donuts.back())
				all_donuts.back().pos = Vector2(x * 100 + 50, y * 100 + 50)
				# Donut.render(all_donuts.back())
				all_donuts.back().visible = false


func setup_input() -> void:
	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.direction.connect(func(direction: Vector2) -> void:
		if donuts_pair == null:
			return
		if direction == Vector2.UP:
			DonutsPair.hard_drop(donuts_pair, all_donuts)
			donuts_pair.freeze_count = DonutsPair.FREEZE_COUNT + 1
			return
		if direction == Vector2.DOWN:
			if DonutsPair.move(donuts_pair, direction * 100, all_donuts) == Vector2.ZERO:
				donuts_pair.freeze_count = DonutsPair.FREEZE_COUNT + 1
			return
		if DonutsPair.move(donuts_pair, direction * 100, all_donuts) != Vector2.ZERO:
			donuts_pair.freeze_count = 0
	)

	input_handler.pressed.connect(func(position: Vector2) -> void:
		if position.x < Main.WINDOW.x * 0.75:
			return
		if donuts_pair == null:
			return
		DonutsPair.rotation(donuts_pair, all_donuts)
		donuts_pair.freeze_count = 0
	)

class NextColors extends Node:
	var next_donuts: Array[Sprite2D] = [Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new()]
	var bag: Array[int] = []

	func _init():
		for i in range(Game.COLOR_NUMBER):
			for j in range(4):
				bag.append(i)
		bag.shuffle()

		for i in range(next_donuts.size()):
			add_child(next_donuts[i])
			next_donuts[i].texture = Donut.DONUT_TEXTURE

		next_donuts[0].position = Vector2(1500, 100 + 64)
		next_donuts[1].position = Vector2(1500, 100 + 0)
		next_donuts[2].position = Vector2(1500, 100 + 256)
		next_donuts[3].position = Vector2(1500, 100 + 192)
		for i in range(next_donuts.size()):
			next_donuts[i].modulate = Color.from_hsv(bag[i] / float(Game.COLOR_NUMBER + 1), 0.5, 1)


	func next_color() -> int:
		if bag.size() < 4:
			var append_array: Array[int] = []
			for i in range(Game.COLOR_NUMBER):
				for j in range(4):
					append_array.append(i)
			append_array.shuffle()
			bag += append_array
		var color = bag.pop_front()
		for i in range(next_donuts.size()):
			next_donuts[i].modulate = Color.from_hsv(bag[i] / float(Game.COLOR_NUMBER + 1), 0.5, 1)
		return color

static func combo_to_score(combo: int) -> int:
	var total: int = 0
	for i in range(1, combo + 1):
		total += i * i
	return total
