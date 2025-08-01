class_name RenameFileWindow
extends AcceptDialog

@export var new_name_edit : LineEdit


func _ready() -> void:
	show()
	move_to_center()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ENTER:
			confirmed.emit()


func change_name() -> void:
	var new_name : String= new_name_edit.text
	if new_name.is_empty():
		return
	FileManager.rename_file(new_name_edit.text)
	queue_free()
