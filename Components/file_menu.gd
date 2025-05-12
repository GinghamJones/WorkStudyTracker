class_name FileMenu
extends PopupMenu

var open_id : int = 0
var save_as_id : int = 1
var save_id : int = 2
var quit_id : int = 3
var new_id : int = 4
var cur_window = null

signal open(is_saving)
signal save
signal quit
signal new


func _ready() -> void:
	await(get_tree().physics_frame)
	var main_scene = Globals.main_scene
	open.connect(Callable(main_scene, "open_file_dialog"))
	save.connect(Callable(main_scene, "save"))
	quit.connect(Callable(main_scene, "quit"))
	new.connect(Callable(main_scene, "open_new_file_dialog"))


func _on_id_pressed(id: int) -> void:
	match id:
		open_id:
			open.emit(false)
		save_as_id:
			create_rename_window()
		save_id:
			save.emit()
		quit_id:
			quit.emit()
		new_id:
			new.emit()


func create_rename_window() -> void:
	var file = FileAccess.open(Globals.main_scene.cur_save_file, FileAccess.READ_WRITE)
	var window : ConfirmationDialog = ConfirmationDialog.new()
	add_child(window)
	window.show()
	cur_window = window
	window.move_to_center()
	var lineedit : LineEdit = LineEdit.new()
	lineedit.placeholder_text = "Enter new name"
	window.add_child(lineedit)
	#while true:
		#var line = file.get_line()
		#if line.begins_with("filename"):
			#line.replace(line, "filename | %s" % new_name)


func new_filename_chosen() -> void:
	var new_name : String = ""
	for c in cur_window.get_children():
		if c is LineEdit:
			new_name = c.text
