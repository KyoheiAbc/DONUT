class_name UI
extends Node2D


var sprites: Array[Sprite2D]

var rival_hp_slider: VisualEffect.GameVSlider = null
var rival_attack_slider: VisualEffect.GameVSlider = null

func _init():
	var rect = ColorRect.new()
	add_child(rect)
	rect.color = Color(0.5, 0.5, 0.5)
	rect.size = Vector2(Donut.SPRITE_SIZE.x * 6, Donut.SPRITE_SIZE.y * 12)
	VisualEffect.set_control_position(rect, Vector2(400 + Donut.SPRITE_SIZE.x * 3, 200))

	var node: Node2D
	node = Node2D.new()
	add_child(node)
	sprites.append(Sprite2D.new())
	node.add_child(sprites.back())
	sprites.back().texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 0)]
	node.position = Vector2(225, 300)

	node = Node2D.new()
	add_child(node)
	sprites.append(Sprite2D.new())
	node.add_child(sprites.back())
	sprites.back().texture = Character.SPRITES[Array2D.get_position_value(Character.MAP, 1)]
	node.position = Vector2(225, 100)

	rival_hp_slider = VisualEffect.GameVSlider.new(Vector2(20, 200), Color(0, 1, 0))
	node.add_child(rival_hp_slider)
	VisualEffect.set_control_position(rival_hp_slider, Vector2(130, 0))
	rival_hp_slider.min_value = 0
	rival_hp_slider.max_value = 1000
	rival_hp_slider.step = 1
	rival_hp_slider.editable = false
	rival_hp_slider.value = rival_hp_slider.max_value

	rival_attack_slider = VisualEffect.GameVSlider.new(Vector2(20, 200), Color(1, 0.5, 0))
	node.add_child(rival_attack_slider)
	VisualEffect.set_control_position(rival_attack_slider, Vector2(110, 0))
	rival_attack_slider.min_value = 0
	rival_attack_slider.max_value = 1000
	rival_attack_slider.step = 1
	rival_attack_slider.editable = false
	rival_attack_slider.value = rival_attack_slider.max_value

func on_damaged(index: int) -> void:
	VisualEffect.rotation(sprites[index], false)

func on_attack(index: int) -> void:
	VisualEffect.jump(sprites[index], true if index == 1 else false)


var rival_attack_prepared: bool = false
func on_combo(index: int, count: int) -> void:
	if count > 0:
		VisualEffect.hop(sprites[index], 1)
	if index == 1:
		rival_attack_prepared = false


func on_rival_progress(progress: int) -> void:
	if not rival_attack_prepared:
		if sprites[1].rotation == 0 and sprites[1].position == Vector2.ZERO:
			rival_attack_prepared = true
			VisualEffect.hop(sprites[1], 3)
	rival_attack_slider.value = progress
