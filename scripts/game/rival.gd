class_name Rival
extends Node

static var IDLE_FRAME_COUNT: int = 90
static var ONE_ATTACK_FRAME_COUNT: int = 30
static var ATTACK_NUMBER: int = 1
static var STUN_COUNT: int = 30

static var HP: int = 100

var hp: int = HP * 100

var frame_count: int = 0
var is_idle: bool = true
var combo: Array[int] = []


func reduce_hp(damage: int) -> void:
	var tween = create_tween()
	tween.tween_property(self, "hp", -damage * 100, 3.0).as_relative()


func process(game: Game) -> void:
	frame_count += 1

	if hp <= 0:
		game.game_over(false)
		return

	if is_idle:
		if game.score > 0:
			reduce_hp(game.score)
			game.score = 0
			frame_count -= STUN_COUNT
			game.ui.action_motion(true)

		if frame_count > IDLE_FRAME_COUNT:
			frame_count = 0
			is_idle = false

	
	else:
		if frame_count >= ONE_ATTACK_FRAME_COUNT:
			frame_count = 0
			combo.append(1)
			if Game.sum(combo) <= ATTACK_NUMBER:
				print("Rival attacks! Combo: %d" % Game.sum(combo))
				game.ui.combo(false)
			else:
				combo.pop_back()
				game.score -= Game.sum_of_powers(combo)
				combo.clear()
				is_idle = true
