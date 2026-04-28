extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.size_changed.connect(_on_window_size_changed)

func _on_window_size_changed():
	self.size = get_tree().root.size
