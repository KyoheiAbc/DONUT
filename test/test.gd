class_name Test
extends Node

var offset = Offset.new()
var player = Player.new()
var rival = Rival.new()
var ui = UI.new()

func _ready():
	add_child(offset)
	add_child(player)
	add_child(rival)
	add_child(ui)

	Game.FRAME_COUNT = 0
	Game.setup(offset, player, rival, ui)

	
func _process(delta: float) -> void:
	Game.FRAME_COUNT += 1

	if Game.FRAME_COUNT == 10:
		player.on_combo(0)
	if Game.FRAME_COUNT == 20:
		player.on_combo(1)
	if Game.FRAME_COUNT == 30:
		player.on_combo(2)
	if Game.FRAME_COUNT == 40:
		player.on_combo(3)
	if Game.FRAME_COUNT == 50:
		player.on_combo(-1)
	
	if Game.FRAME_COUNT == 90:
		player.on_combo(0)
	if Game.FRAME_COUNT == 100:
		player.on_combo(1)
	if Game.FRAME_COUNT == 110:
		player.on_combo(-1)
	
	if Game.FRAME_COUNT == 130:
		player.on_combo(0)
	if Game.FRAME_COUNT == 140:
		player.on_combo(1)
	if Game.FRAME_COUNT == 150:
		player.on_combo(2)
	if Game.FRAME_COUNT == 160:
		player.on_combo(-1)

	if Game.FRAME_COUNT == 250:
		player.on_combo(0)
	if Game.FRAME_COUNT == 270:
		player.on_combo(1)
	if Game.FRAME_COUNT == 290:
		player.on_combo(2)
	if Game.FRAME_COUNT == 310:
		player.on_combo(3)
	if Game.FRAME_COUNT == 330:
		player.on_combo(4)
	if Game.FRAME_COUNT == 350:
		player.on_combo(-1)


	rival.process()
