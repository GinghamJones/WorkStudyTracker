extends Node

@export var delete_file_window_scene : PackedScene
@export var rename_file_window_scene : PackedScene

# Window types available
enum Windows{
    Delete,
    Rename,
}

# Scene to type mapping
var _windows : Dictionary = {
    Windows.Delete : delete_file_window_scene,
    Windows.Rename : rename_file_window_scene
}


func create_window(type : int) -> void:
    for w in _windows.keys():
        if w == type:
            var window = _windows[w].instantiate()
            add_child(window)