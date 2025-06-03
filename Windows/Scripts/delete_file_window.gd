class_name DeleteFileWindow
extends AcceptDialog

func _ready():
	show()
	
	# One time check to make sure save directory exists. Create it if not.
	if not DirAccess.dir_exists_absolute(FileManager.save_folder_path):
		DirAccess.make_dir_absolute(FileManager.save_folder_path)

	# Loop through dir to display available save files
	var dir = DirAccess.open(FileManager.save_folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var button : Button = Button.new()
			button.text = file_name
			$ScrollContainer/VBoxContainer.add_child(button)
			button.pressed.connect(delete_file.bind(button.text))
			file_name = dir.get_next()


func delete_file(file_to_delete : String) -> void:
	var file_to_delete_path : String = FileManager.get_filename_as_full_path(file_to_delete)
	var cur_save_file_path : String = FileManager.get_filename_as_full_path(Globals.cur_save_file)
	
	# Show confirmation to delete file
	var new_window : ConfirmationDialog = ConfirmationDialog.new()
	add_child(new_window)
	new_window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	new_window.always_on_top = true
	new_window.show()
	new_window.dialog_text = "Are you sure you want to delete %s?" % file_to_delete
	var is_cur_save_file : bool = false
	if file_to_delete_path == cur_save_file_path:
		is_cur_save_file = true
		new_window.dialog_text += "\nThis is your current save file."
		
	new_window.confirmed.connect(confirm_delete_file.bind(file_to_delete_path, new_window, is_cur_save_file))


func confirm_delete_file(file_to_delete_path : String, new_window : ConfirmationDialog, is_cur_save_file : bool) -> void:
	FileManager.delete_file(file_to_delete_path, is_cur_save_file)
	new_window.queue_free()
	if is_cur_save_file:
		Globals.main_scene.gui_main.clear_contents()
		Globals.main_scene.bottom_gui.hide_contents() # A helluva hack
	queue_free()


func _on_canceled() -> void:
	queue_free()
