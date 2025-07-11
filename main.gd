class_name MainScene
extends Control

@export var hours_logged_cont: VBoxContainer
#@export var gui_main: GUIMain
@export var addbutton: Button
@export var title_label : Label

@export var total: Label
@export var hours_left: Label
@export var money_earned: Label
#@export var bottom_gui : MarginContainer
#var max_hours : int
#var wage : float
#var term : String

var canceled : bool = false
var cur_file_browser = null
var is_quitting : bool = false
var time_entries : Array[TimeEntry] = []
var is_saved : bool = false
var auto_save_enabled : bool = true
var just_started : bool = true # Logs if program is just opened
var file_is_open : bool = false


func _ready() -> void:
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
		GuiManager.hide_bottom_gui() 
		print("Ready: cur_save_file not ultimately found")
		return
	
	FileManager.open_file(Globals.cur_save_file)
	just_started = false


#func cancel():
	### Are we using this?
	#print("canceled")
	#canceled = true
	#return


func update_total():
	var new_total = TimeEntryManager.get_total_hours()
	
	total.text = str(new_total)
	hours_left.text = str(Globals.max_hours - new_total)
	money_earned.text = "$%*.*f" % [7, 2, (new_total * Globals.wage)]
	
	title_label.text = Globals.term


func create_new_file(new_term : String, new_allotted_money : String, new_wage : String) -> void:
	if Globals.cur_save_file != "" and auto_save_enabled:
		save()
	
	var allotted_money : float = float(new_allotted_money)
	var wage : float = float(new_wage)
	
	Globals.term = new_term
	Globals.max_hours = allotted_money / wage
	Globals.wage = wage
	
	Globals.cur_save_file = new_term
	var success : bool = FileManager.create_new_file(new_term)
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
	save_file.close()
	#if is_quitting:
		#is_quitting = false
		#quit()


func _on_file_deleted() -> void:
	## Are we using this?
	GuiManager.clear_gui_main()
	GuiManager.hide_bottom_gui()


func _on_quit_button_pressed() -> void:
	WindowManager.create_window(WindowManager.Windows.Quit)


func quit() -> void:
	# Store cur_save_file for use when reopening program
	var config_file : ConfigFile = FileManager.get_config_file()
	print("current save: %s" % Globals.cur_save_file)
	config_file.set_value("files", "cur_save_file", Globals.cur_save_file)
	var err = config_file.save(FileManager.config_file_path)
	if err:
		print("Something went wrong with config file")
	
	get_tree().quit()
