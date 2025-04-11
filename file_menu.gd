class_name FileMenu
extends PopupMenu

var open_id : int = 0
var save_as_id : int = 1
var save_id : int = 2
var quit_id : int = 3
var main_scene : Control

signal open(is_saving)
signal save_as(is_saving)
signal save
signal quit


func _ready() -> void:
	main_scene = get_tree().get_first_node_in_group("Main")
	open.connect(Callable(main_scene, "open_file_dialog"))
	save_as.connect(Callable(main_scene, "save_as"))
	save.connect(Callable(main_scene, "save"))
	quit.connect(Callable(main_scene, "quit"))


func _on_id_pressed(id: int) -> void:
	match id:
		open_id:
			open.emit(false)
		save_as_id:
			save_as.emit(true)
		save_id:
			save.emit()
		quit_id:
			quit.emit()
