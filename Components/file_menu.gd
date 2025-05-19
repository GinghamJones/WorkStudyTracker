class_name FileMenu
extends PopupMenu


## Need to implement Rename and Delete ##
var open_id : int = 0
var rename_id : int = 1
var save_id : int = 2
var quit_id : int = 3
var new_id : int = 4
var delete_id : int = 5
var cur_window = null

signal open(is_saving)
signal save
signal quit
signal new
signal delete


func _ready() -> void:
	await(get_tree().physics_frame)
	var main_scene = Globals.main_scene
	open.connect(Callable(main_scene, "open_file_dialog"))
	save.connect(Callable(main_scene, "save"))
	quit.connect(Callable(main_scene, "quit"))
	new.connect(Callable(main_scene, "open_new_file_dialog"))
	delete.connect(Callable(main_scene, "delete_file"))


func _on_id_pressed(id: int) -> void:
	match id:
		open_id:
			open.emit(false)
		rename_id:
			create_rename_window()
		save_id:
			save.emit()
		quit_id:
			quit.emit()
		new_id:
			new.emit()
		delete_id:
			create_delete_window()


func create_rename_window() -> void:
	#var file = FileAccess.open(Globals.cur_save_file, FileAccess.READ_WRITE)
	var rename_window = preload("res://Windows/rename_file_window.tscn")
	var window : RenameFileWindow = rename_window.instantiate()
	add_child(window)
	#window.show()
	#cur_window = window
	#window.move_to_center()
	#var lineedit : LineEdit = LineEdit.new()
	#lineedit.placeholder_text = "Enter new name"
	#window.add_child(lineedit)


#func new_filename_chosen() -> void:
	#var new_name : String = ""
	#for c in cur_window.get_children():
		#if c is LineEdit:
			#new_name = c.text


func create_delete_window() -> void:
	var window : AcceptDialog = AcceptDialog.new()
	add_child(window)
	window.set_script(load("res://Windows/delete_file_window.gd"))
	window.initiate()
