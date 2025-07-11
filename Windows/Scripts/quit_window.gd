class_name QuitWindow
extends ConfirmationDialog

signal request_save
signal request_quit


func _ready() -> void:
	add_button("Quit Without Saving", false, "quit")
	request_quit.connect(get_tree().get_first_node_in_group("Main").quit)
	request_save.connect(get_tree().get_first_node_in_group("Main").save)


func _on_confirmed() -> void:
	if Globals.auto_save_enabled:
		request_save.emit()
	request_quit.emit()
	queue_free()

func _on_canceled() -> void:
	queue_free()


func _on_custom_action(action: StringName) -> void:
	request_quit.emit()
	queue_free()
