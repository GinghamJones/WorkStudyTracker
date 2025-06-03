class_name GUIBottom
extends MarginContainer

func show_contents() -> void:
	$VBox/InfoVBox.show()
	$VBox/ButtonHBox/addbutton.show()


func hide_contents() -> void:
	$VBox/InfoVBox.hide()
	$VBox/ButtonHBox/addbutton.hide()
