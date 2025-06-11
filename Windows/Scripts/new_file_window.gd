class_name NewFileWindow
extends AcceptDialog

@onready var term_line: LineEdit = $VBoxContainer/TermLine
@onready var max_hours_line: LineEdit = $VBoxContainer/MaxHoursLine
@onready var wage_line: LineEdit = $VBoxContainer/WageLine


signal request_new_file


func _ready() -> void:
	request_new_file.connect(get_tree().get_first_node_in_group("Main").create_new_file)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ENTER:
			confirmed.emit()


func _on_confirmed() -> void:
	var is_data_ok : bool = check_data()
	if not is_data_ok:
		return
	
	request_new_file.emit(term_line.text, max_hours_line.text, wage_line.text)
	queue_free()


func check_data() -> bool:
	if term_line.text == "":
		return false
	if max_hours_line.text == "":
		return false
	if wage_line.text == "":
		return false
	
	return true


func _on_text_submitted(new_text: String) -> void:
	confirmed.emit()
