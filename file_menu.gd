class_name FileMenu
extends PopupMenu

var open_id : int = 0
var save_as_id : int = 1
var save_id : int = 2
var quit_id : int = 3

signal open(is_saving)
signal save_as(is_saving)
signal save
signal quit

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
