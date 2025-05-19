class_name OpenFileWindow
extends AcceptDialog

func initiate(open_file : Callable):
	title = "Save As"
	popup_centered()
	size = Vector2(300, 300)
	
	# One time check to make sure save directory/file exists. Create it if not.
	if not FileAccess.file_exists(Globals.cur_save_file):
		#FileAccess.open(cur_save_file, FileAccess.WRITE)
		print("Can't obtain cur_save_file when opening files")
	if not DirAccess.dir_exists_absolute(FileManager.save_folder_path):
		DirAccess.make_dir_absolute(FileManager.save_folder_path)

	# Loop through dir to display available save files
	var dir = DirAccess.open(FileManager.save_folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var vbox : VBoxContainer = VBoxContainer.new()
		add_child(vbox)
		while file_name != "":
			var button : Button = Button.new()
			button.text = file_name
			vbox.add_child(button)
			button.pressed.connect(open_file.bind(button.text))
			file_name = dir.get_next()
