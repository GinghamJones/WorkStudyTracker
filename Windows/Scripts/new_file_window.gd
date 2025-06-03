
extends Node

var window : ConfirmationDialog
var term : String
var max_hours : String
var wage : String
var main_scene 
var filename : String

signal new_file_created

func _ready() -> void:
	main_scene = get_tree().get_first_node_in_group("Main")
	new_file_created.connect(Callable(main_scene, "create_new_file"))
	
	window = ConfirmationDialog.new()
	window.title = "Create New File"
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	window.size = Vector2(500, 250)
	add_child(window)
	window.confirmed.connect(send_new_file)
	window.show()
	
	var vbox : VBoxContainer = VBoxContainer.new()
	window.add_child(vbox)
	
	var term_edit : LineEdit = LineEdit.new()
	vbox.add_child(term_edit)
	term_edit.placeholder_text = "Enter term"
	term_edit.text_changed.connect(set_term)
	var max_hours_edit : LineEdit = LineEdit.new()
	vbox.add_child(max_hours_edit)
	max_hours_edit.placeholder_text = "Enter maximum allowed hours"
	max_hours_edit.text_changed.connect(set_max_hours)
	var wage_edit : LineEdit = LineEdit.new()
	vbox.add_child(wage_edit)
	wage_edit.placeholder_text = "Enter your wage"
	wage_edit.text_changed.connect(set_wage)


func set_term(value : String) -> void:
	term = value

func set_wage(value : String) -> void:
	wage = value

func set_max_hours(value : String) -> void:
	max_hours = value


func send_new_file() -> void:
	new_file_created.emit(term, max_hours, wage)
	print("Create file emitted")
	queue_free()
