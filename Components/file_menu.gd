class_name FileMenu
extends PopupMenu

@export var delete_window_scene : PackedScene
@export var rename_window_scene : PackedScene
@export var open_window_scene : PackedScene

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
	SignalManager.register_listener(self)


func _on_system_ready() -> void:
	var main_scene = Globals.main_scene
	open.connect(Callable(main_scene, "open_file_dialog"))
	save.connect(Callable(main_scene, "save"))
	quit.connect(Callable(main_scene, "quit"))
	new.connect(Callable(main_scene, "open_new_file_dialog"))
	delete.connect(Callable(TimeEntryManager.remove_entry))


func _on_id_pressed(id: int) -> void:
	match id:
		open_id:
			create_open_window()
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


func create_open_window() -> void:
	var window : OpenFileWindow = open_window_scene.instantiate()
	add_child(window)


func create_rename_window() -> void:
	#var rename_window = rename_window_scene.ins
	var window : RenameFileWindow = rename_window_scene.instantiate()
	add_child(window)


func create_delete_window() -> void:
	var window : DeleteFileWindow = delete_window_scene.instantiate()
	add_child(window)
