extends Button

@export var main_scene : Control
@export var hours_label_script : Script
@export var date_label_script : Script
var window : ConfirmationDialog
var date_field : LineEdit
var hours_field : LineEdit


func _on_addbutton_pressed() -> void:
	# This purely creates the window in which to enter a new Time Entry
	create_time_entry_window()
	var container : VBoxContainer = VBoxContainer.new()
	hours_field = LineEdit.new()
	date_field = LineEdit.new()

	window.add_child(container)
	container.alignment = BoxContainer.ALIGNMENT_CENTER
	hours_field.set_script(hours_label_script)
	date_field.set_script(date_label_script)
	container.add_child(date_field)
	container.add_child(hours_field)
	
	hours_field.position += Vector2(10, 0)
	window.connect("canceled", Callable(self, "cancel"))
	window.connect("confirmed", Callable(self, "confirm"))


func create_time_entry_window() -> void:
	window = ConfirmationDialog.new()
	window.set_script(load("res://Windows/Scripts/add_time_entry_window.gd"))
	add_child(window)


func cancel() -> void:
	window.queue_free()


func confirm() -> void:
	# main_scene.add_data(date_field.text, hours_field.text)
	TimeEntryManager.add_entry(date_field.text, hours_field.text)
	
	hours_field.queue_free()
	date_field.queue_free()
	window.queue_free()
