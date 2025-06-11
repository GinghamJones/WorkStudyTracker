class_name MainScene
extends Control

@export var hours_logged_cont: VBoxContainer
@export var gui_main: GUIMain
@export var addbutton: Button
@export var title_label : Label

@export var total: Label
@export var hours_left: Label
@export var money_earned: Label
@export var bottom_gui : MarginContainer
var max_hours : int
var wage : float
var term : String

var canceled : bool = false
var cur_file_browser = null
var is_quitting : bool = false
var time_entries : Array[TimeEntry] = []
var is_saved : bool = false
var auto_save_enabled : bool = true
var just_started : bool = true # Logs if program is just opened
var file_is_open : bool = false


func _ready() -> void:
	# Needed for syncing initializations
	# SignalManager.register_listener(self)
	Globals.main_scene = self
	just_started = true
	SignalManager.mark_ready()
	
	# Open res://settings.ini
	var new_file : ConfigFile = FileManager.get_config_file()
	var err = new_file.load(FileManager.config_file_path)
	if err:
		print("Error opening file %s" % err)
		return
	if new_file.has_section("files"):
		Globals.cur_save_file = new_file.get_value("files", "cur_save_file")
	if Globals.cur_save_file == "":
		bottom_gui.hide_contents()
		print("Ready: cur_save_file not ultimately found")
		return
	
	FileManager.open_file(Globals.cur_save_file)
	just_started = false


func cancel():
	print("canceled")
	canceled = true
	return


func update_total():
	var new_total = TimeEntryManager.get_total_hours()
	
	total.text = "Total: " + str(new_total)
	hours_left.text = "Hours remaining: " + str(Globals.max_hours - new_total)
	money_earned.text = "Cash earned: $%*.*f" % [7, 2, (new_total * Globals.wage)]
	
	title_label.text = Globals.term
	#if auto_save_enabled:
		#save()


#func open_new_file_dialog() -> void:
	#var new_file_dialog : NewFileWindow = NewFileWindow.new()
	#add_child(new_file_dialog)


func create_new_file(new_term : String, new_max_hours : String, new_wage : String) -> void:
	if Globals.cur_save_file != "" and auto_save_enabled:
		save()
	
	Globals.term = new_term
	Globals.max_hours = int(new_max_hours)
	Globals.wage = float(new_wage)
	
	var filename : String = new_term
	# if not filename.ends_with(".sav"):
	# 	filename += ".sav"
	Globals.cur_save_file = filename
	#open_file(Globals.cur_save_file)
	var success : bool = FileManager.create_new_file(filename)
	if not success:
		print("Couldn't create file")
		return
	
	FileManager.open_file(Globals.cur_save_file)


func save() -> void:
	var save_file = FileManager.get_save_file(Globals.cur_save_file, FileAccess.WRITE)
	print("Saving to %s" % Globals.cur_save_file)
	if not save_file:
		print ("Error retrieving %s" % Globals.cur_save_file)
		return
	
	######## Save all data #########
	save_file.store_line("term | %s" % str(Globals.term))
	save_file.store_line("max_hours | %s" % str(Globals.max_hours))
	save_file.store_line("wage | %s" % str(Globals.wage))

	for entry in TimeEntryManager.get_entries():
		var data : Array[String] = entry.get_data_as_text()
		save_file.store_line(data[0] + "|" + data[1])
	################################
	
	# Cleanup
	is_saved = true
	if cur_file_browser:
		cur_file_browser.queue_free()
	save_file.close()
	if is_quitting:
		is_quitting = false
		quit()


func _on_file_deleted() -> void:
	GuiManager.clear_gui_main()
	GuiManager.hide_bottom_gui()


func _custom_action_pressed(action : String) -> void:
	if action == "quit":
		quit()


func _on_quit_button_pressed() -> void:
	# Setup confirmation window
	if not is_saved:
		var popup : ConfirmationDialog = ConfirmationDialog.new()
		add_child(popup)
		popup.popup_centered(Vector2i(2, 2))
		
		popup.dialog_text = "Do you want to save?"
		popup.cancel_button_text = "Cancel"
		popup.ok_button_text = "Save"
		popup.add_button("Quit Without Saving", false, "quit")
		
		popup.confirmed.connect(Callable(self, "save"))
		popup.canceled.connect(Callable(self, "cancel_dialogue"))
		popup.custom_action.connect(_custom_action_pressed)
		
		popup.show()
	else:
		print("_on_quit_button_pressed file already saved")
		quit()
	is_quitting = true


func quit() -> void:
	var config_file : ConfigFile = FileManager.get_config_file()
	print("current save: %s" % Globals.cur_save_file)
	config_file.set_value("files", "cur_save_file", Globals.cur_save_file)
	var err = config_file.save(FileManager.config_file_path)
	if err:
		print("Something went wrong with config file")
	
	get_tree().quit()
