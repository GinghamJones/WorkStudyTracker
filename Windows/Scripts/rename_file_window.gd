class_name RenameFileWindow
extends AcceptDialog

@export var new_name_edit : LineEdit


func _ready() -> void:
	show()
	move_to_center()


func change_name() -> void:
	FileManager.rename_file($VBoxContainer/LineEdit.text)
	queue_free()
