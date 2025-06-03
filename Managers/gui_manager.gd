extends Node

var gui_main : GUIMain
var gui_bottom : GUIBottom

func _ready() -> void:
	SignalManager.register_listener(self)


func _on_system_ready() -> void:
	gui_main = get_tree().get_first_node_in_group("GUIMain")
	gui_bottom = get_tree().get_first_node_in_group("GUIBottom")


func hide_bottom_gui() -> void:
	gui_bottom.hide_contents()

func show_bottom_gui() -> void:
	gui_bottom.show_contents()


func hide_gui_main() -> void:
	gui_main.hide()
	gui_main.process_mode = Node.PROCESS_MODE_DISABLED

func show_gui_main() -> void:
	gui_main.show()
	gui_main.process_mode = Node.PROCESS_MODE_INHERIT


func clear_gui_main() -> void:
	gui_main.clear_contents()
	gui_main.hide()
	gui_main.process_mode = Node.PROCESS_MODE_DISABLED
