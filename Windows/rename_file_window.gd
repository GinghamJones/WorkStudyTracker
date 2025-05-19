class_name RenameFileWindow
extends AcceptDialog


func _ready() -> void:
	print("Ready entered")
	#var file = FileAccess.open(Globals.cur_save_file, FileAccess.READ_WRITE)
	show()
	move_to_center()
	var lineedit : LineEdit = LineEdit.new()
	lineedit.placeholder_text = "Enter new name"
	add_child(lineedit)
	confirmed.connect(change_name)
	print("RenameFileWindows readied")


func change_name() -> void:
	for c in get_children():
		if c is LineEdit:
			FileManager.rename_file(c.text)
			print("Called rename file in FileManager")
			queue_free()
