class_name TimeEntry
extends Resource

var date : String :
	get:
		return date
	set(value):
		date = value

var time : int : 
	get:
		return time 
	set(value):
		time = value


func get_data_as_text() -> Array[String]:
	return [date, str(time)]


func set_data(new_date : String, new_time : String):
	## Do something to check for proper formatting. Might just do this in individual setters ##
	date = new_date
	time = int(new_time)
