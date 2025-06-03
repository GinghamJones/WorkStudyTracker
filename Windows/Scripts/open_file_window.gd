class_name OpenFileWindow
extends AcceptDialog


func _ready() -> void:
	if not DirAccess.dir_exists_absolute(FileManager.save_folder_path):
		DirAccess.make_dir_absolute(FileManager.save_folder_path)
		var label : Label = Label.new()
		add_child(label)
		label.text = "No files to open :("
		return
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
			button.pressed.connect(_on_button_pressed.bind(button.text))
			file_name = dir.get_next()


func _on_button_pressed(text : String) -> void:
	FileManager.open_file(text)
	queue_free()


func _on_confirmed() -> void:
	queue_free()
