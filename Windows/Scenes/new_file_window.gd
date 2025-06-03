class_name NewFileWindow
extends AcceptDialog

signal request_new_file


func _ready() -> void:
	pass

func _on_confirmed() -> void:
	var is_data_ok : bool = check_data()
	if not is_data_ok:
		return
	

func check_data() -> bool:
	if $VBoxContainer/TermLine.text == "":
		return false
	if $VBoxContainer/MaxHoursLine.text == "":
		return false
	if $VBoxContainer/WageLine.text == "":
		return false
	
	return true
