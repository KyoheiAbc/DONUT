class_name Character
extends Node
func _ready():
	var input_handler = InputHandler.new()
	add_child(input_handler)
	input_handler.pressed.connect(func(position: Vector2) -> void:
		Main.show_black(0.1)
		Main.ROOT.add_child(Initial.new())
		self.queue_free()
	)
