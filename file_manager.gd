extends Node

var config_file_path : String = "user://settings.ini"
var save_folder_path : String = "user://saves/"


func get_save_file(filename : String, access_mode : FileAccess.ModeFlags) -> FileAccess:
	if not filename.begins_with(save_folder_path):
		filename = filename.insert(0, save_folder_path)
	if not filename.ends_with(".sav"):
		filename += ".sav"
	var file = FileAccess.open(filename, access_mode)
	if not file:
		print("Could not retrieve save file %s...." % filename)
		return
	
	return file


func get_config_file() -> ConfigFile:
	# Create base config file
	if not FileAccess.file_exists(config_file_path):
		var new_file : ConfigFile = ConfigFile.new()
		new_file.set_value("files", "cur_save_file", "")
		new_file.set_value("settings", "auto_save_enabled", "true")
		new_file.save(FileManager.config_file_path)
		return new_file
	
	var config_file : ConfigFile = ConfigFile.new()
	var err = config_file.load(config_file_path)
	if err:
		print("Error finding config file")
		return
	
	return config_file


func rename_file(new_file_name : String) -> void:
	var cur_save_file_path : String = Globals.cur_save_file
	if not cur_save_file_path.ends_with(".sav"):
		cur_save_file_path = cur_save_file_path + ".sav"
	if not cur_save_file_path.begins_with(save_folder_path):
		cur_save_file_path = save_folder_path + cur_save_file_path
	
	var new_save_file_path : String = (save_folder_path + new_file_name + ".sav")
	DirAccess.rename_absolute(cur_save_file_path, new_save_file_path)
	print("Attempted to rename file...")
	Globals.cur_save_file = new_save_file_path
	Globals.main_scene.update
