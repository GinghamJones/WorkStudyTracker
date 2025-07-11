class_name GUIBottom
extends MarginContainer

@export var info_vbox : VBoxContainer
@export var add_button : Button

func show_contents() -> void:
	info_vbox.show()
	add_button.show()


func hide_contents() -> void:
	info_vbox.hide()
	add_button.hide()
