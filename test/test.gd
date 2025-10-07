class_name Test
extends Node

var frame_count: int = 0

var offset = Offset.new()
var player = Player.new()
var rival = Rival.new()
var ui = UI.new()

func _ready():
	add_child(offset)
	add_child(player)
	add_child(rival)
	add_child(ui)

	offset.signal_score_changed.connect(func(new_score: int) -> void:
		print("offset signal_score_changed:", new_score, " frame_count:", frame_count)
		player.on_score_changed(new_score)
		rival.on_score_changed(new_score)
	)
	player.signal_combo.connect(func(count: int) -> void:
		print("player signal_combo:", count, " frame_count:", frame_count)
		offset.on_combo(0, count)
		if count > 0:
			ui.on_combo(0, count)
	)
	rival.signal_combo.connect(func(count: int) -> void:
		print("rival signal_combo:", count, " frame_count:", frame_count)
		offset.on_combo(1, count)
		if count > 0:
			ui.on_combo(1, count)
	)
	player.signal_damaged.connect(func(damage: int) -> void:
		print("player signal_damaged:", damage, " frame_count:", frame_count)
		ui.on_damaged(0, damage)
		ui.on_attack(1)
		offset.on_damaged(0, damage)
	)
	rival.signal_damaged.connect(func(damage: int) -> void:
		print("rival signal_damaged:", damage, " frame_count:", frame_count)
		ui.on_damaged(1, damage)
		ui.on_attack(0)
		offset.on_damaged(1, damage)
	)
	
	rival.signal_progress.connect(ui.on_rival_progress)
	

func _process(delta: float) -> void:
	frame_count += 1

	if frame_count == 10:
		player.on_combo(0)
	if frame_count == 20:
		player.on_combo(1)
	if frame_count == 30:
		player.on_combo(2)
	if frame_count == 40:
		player.on_combo(3)
	if frame_count == 50:
		player.on_combo(-1)
	
	if frame_count == 90:
		player.on_combo(0)
	if frame_count == 100:
		player.on_combo(1)
	if frame_count == 110:
		player.on_combo(-1)
	
	if frame_count == 130:
		player.on_combo(0)
	if frame_count == 140:
		player.on_combo(1)
	if frame_count == 150:
		player.on_combo(2)
	if frame_count == 160:
		player.on_combo(-1)

	if frame_count == 250:
		player.on_combo(0)
	if frame_count == 270:
		player.on_combo(1)
	if frame_count == 290:
		player.on_combo(2)
	if frame_count == 310:
		player.on_combo(3)
	if frame_count == 330:
		player.on_combo(4)
	if frame_count == 350:
		player.on_combo(-1)


	rival.process()
