extends MarginContainer

func show_contents() -> void:
	for c in get_children():
		show()


func hide_contents() -> void:
	for c in get_children():
		if c.name == "QuitButton":
			continue
		c.hide()
