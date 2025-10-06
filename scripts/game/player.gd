class_name Player
extends Node

var combo_is_doing: bool = false
var garbage: int = 0

signal signal_combo(combo: int)
signal signal_damaged(damage: int)

var sprite: Sprite2D = null

func on_combo(combo: int) -> void:
	if combo >= 0:
		combo_is_doing = true
	elif combo == -1:
		combo_is_doing = false
	emit_signal("signal_combo", combo)

func on_score(score: int) -> void:
	if score > 0:
		return
	if combo_is_doing:
		print("Player continues combo, no damage taken\n")
		return
	emit_signal("signal_damaged", -score)
	garbage += -score

func on_receive_garbage() -> int:
	var return_garbage = garbage
	garbage = 0
	return return_garbage

func _init() -> void:
	var node = Node2D.new()
	add_child(node)
	node.position = Vector2(650, 750)
	sprite = Sprite2D.new()
	node.add_child(sprite)
	sprite.texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]