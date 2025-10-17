class_name Initial

extends Node

func _ready():
	var label = Label.new()
	add_child(label)
	Main.setup_label(label)
	label.text = "DONUTS POP"

	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.pressed.connect(func(_position: Vector2) -> void:
		Main.NODE.add_child(Character.new())
		self.queue_free()
	)
