class_name FileMenu
extends PopupMenu


var open_id : int = 0
var rename_id : int = 1
var save_id : int = 2
var quit_id : int = 3
var new_id : int = 4
var delete_id : int = 5
var cur_window = null

signal save
signal quit


func _ready() -> void:
	SignalManager.register_listener(self)


func _on_system_ready() -> void:
	var main_scene : MainScene = Globals.main_scene
	save.connect(Callable(main_scene, "save"))
	quit.connect(Callable(main_scene, "quit"))


func _on_id_pressed(id: int) -> void:
	match id:
		open_id:
			WindowManager.create_window(WindowManager.Windows.Open)
		rename_id:
			WindowManager.create_window(WindowManager.Windows.Rename)
		save_id:
			save.emit()
		quit_id:
			quit.emit()
		new_id:
			WindowManager.create_window(WindowManager.Windows.NewFile)
		delete_id:
			WindowManager.create_window(WindowManager.Windows.Delete)
