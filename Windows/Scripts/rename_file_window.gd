class_name RenameFileWindow
extends AcceptDialog


func _ready() -> void:
	show()
	move_to_center()


func change_name() -> void:
	for c in get_children():
		if c is LineEdit:
			FileManager.rename_file(c.text)
			print("Called rename file in FileManager")
			queue_free()
