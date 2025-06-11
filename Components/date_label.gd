class_name DateLabel
extends LineEdit

## Probably won't need this later on. Should be checked in the TimeEntry itself ##
## @experimental
func _ready() -> void:
	text_changed.connect(_on_text_changed)
	placeholder_text = "Enter date in mm/dd format"


func _on_text_changed(new_text : String) -> void:
	for i in new_text.length():
		if not new_text[i].is_valid_float() and not new_text[i] == '/':
			new_text[i] = ''
			break
	
	text = new_text
	caret_column = text.length()
