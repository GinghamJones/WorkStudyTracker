extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	placeholder_text = "Enter a number"
	text_changed.connect(Callable(_on_text_changed))
	text_submitted.connect(_on_text_changed)


func _on_text_changed(new_text : String) -> void:
	for i in new_text.length():
		if not new_text[i].is_valid_float():
			new_text[i] = ''
	
	text = new_text
	caret_column = text.length()
