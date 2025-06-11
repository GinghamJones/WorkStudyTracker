extends Node

@export var delete_file_window_scene : PackedScene
@export var rename_file_window_scene : PackedScene
@export var new_file_window_scene : PackedScene
@export var open_file_window_scene : PackedScene
@export var add_data_window_scene : PackedScene

# Window types available
enum Windows{
	Delete,
	Rename,
	NewFile,
	Open,
	AddData,
}

# Scene to type mapping
@onready var _windows : Dictionary = {
	Windows.Delete : delete_file_window_scene,
	Windows.Rename : rename_file_window_scene,
	Windows.NewFile : new_file_window_scene,
	Windows.Open : open_file_window_scene,
	Windows.AddData : add_data_window_scene,
}


func create_window(type : int) -> void:
	for w in _windows.keys():
		if w == type:
			var window = _windows[w].instantiate()
			add_child(window)
