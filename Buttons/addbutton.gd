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
	
	#if canceled: 
		#canceled = false
		#data_field.queue_free()
		#date_field.queue_free()
		#window.queue_free()
		#return



func create_time_entry_window() -> void:
	window = ConfirmationDialog.new()
	add_child(window)
	window.mode = Window.MODE_WINDOWED
	window.unresizable = true
	window.min_size = Vector2i(500, 200)
	window.exclusive = true
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	window.dialog_text = "How much time did you work?"
	window.popup_centered(Vector2i(2, 2))
	window.show()


func cancel() -> void:
	window.queue_free()


func confirm() -> void:
	main_scene.add_data(date_field.text, hours_field.text)
	
	hours_field.queue_free()
	date_field.queue_free()
	window.queue_free()
